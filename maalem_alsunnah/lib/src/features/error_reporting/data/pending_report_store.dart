import 'dart:convert';
import 'dart:io';

import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';

/// Keeps the last unhandled report on disk, so it can be offered again on
/// the next launch if the app was closed or killed before the user acted.
class PendingReportStore {
  PendingReportStore(this._directory);

  final Future<Directory> Function() _directory;

  static const _fileName = 'pending_error_report.json';

  Future<File> get _file async =>
      File('${(await _directory()).path}/$_fileName');

  /// Replaces any earlier report: only the latest one is kept.
  Future<void> save(ErrorReport report) async {
    final file = await _file;
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(report.toJson()));
  }

  /// Returns the saved report, if any, and removes it, so it's offered once.
  /// A file that can't be read is removed too.
  Future<ErrorReport?> take() async {
    final file = await _file;
    if (!file.existsSync()) return null;
    try {
      final json = jsonDecode(await file.readAsString());
      return ErrorReport.fromJson(json as Map<String, dynamic>);
    } catch (_) {
      return null;
    } finally {
      await file.delete();
    }
  }

  Future<void> clear() async {
    final file = await _file;
    if (file.existsSync()) await file.delete();
  }
}
