import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/pending_report_store.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';

void main() {
  late Directory dir;
  late PendingReportStore store;

  final report = ErrorReport(
    error: StateError('No element'),
    stackTrace: StackTrace.fromString('#0 main (file.dart:1)'),
    device: const DeviceSnapshot(
      appVersion: '0.2.01',
      buildNumber: '3',
      platform: 'android',
      osVersion: null,
      manufacturer: 'Google',
      model: null,
      appLocale: 'ar',
      systemLocale: 'en_US',
      screenSize: '411x914',
      pixelRatio: 2.75,
      theme: 'dark',
    ),
    recentEvents: const ['09:00:00 route push: /home'],
    createdAt: DateTime.utc(2026, 11, 17, 10, 22, 5),
  ).withDescription('Opened a bookmark');

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('pending_report_test');
    store = PendingReportStore(() async => dir);
  });

  tearDown(() async {
    if (dir.existsSync()) await dir.delete(recursive: true);
  });

  test('nothing saved means nothing to take', () async {
    expect(await store.take(), isNull);
  });

  test('a saved report comes back once, reading exactly the same', () async {
    await store.save(report);

    final taken = await store.take();
    expect(taken, isNotNull);
    expect(taken!.toText(), report.toText());
    expect(taken.fileName, report.fileName);
    expect(taken.summary, report.summary);

    expect(await store.take(), isNull);
  });

  test('a cleared report is gone', () async {
    await store.save(report);
    await store.clear();

    expect(await store.take(), isNull);
  });

  test('a damaged file is dropped, not thrown', () async {
    await store.save(report);
    for (final file in dir.listSync().whereType<File>()) {
      file.writeAsStringSync('{not json');
    }

    expect(await store.take(), isNull);
    expect(await store.take(), isNull);
  });
}
