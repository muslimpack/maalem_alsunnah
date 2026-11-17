import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';

/// One unexpected error, packaged as a plain-text file the user can read
/// before sending it.
class ErrorReport {
  const ErrorReport({
    required this.error,
    required this.stackTrace,
    required this.device,
    required this.recentEvents,
    required this.createdAt,
    this.userDescription = '',
  });

  /// What the user says they were doing; optional, so it may be empty.
  final String userDescription;

  ErrorReport withDescription(String description) => ErrorReport(
        error: error,
        stackTrace: stackTrace,
        device: device,
        recentEvents: recentEvents,
        createdAt: createdAt,
        userDescription: description.trim(),
      );

  /// For keeping a report across launches. The error and stack come back
  /// as text, which is all the report ever uses of them.
  Map<String, Object?> toJson() => {
        'error': error.toString(),
        'stackTrace': stackTrace?.toString(),
        'device': device.toJson(),
        'recentEvents': recentEvents,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'userDescription': userDescription,
      };

  factory ErrorReport.fromJson(Map<String, dynamic> json) {
    final stack = json['stackTrace'] as String?;
    return ErrorReport(
      error: json['error'] as String,
      stackTrace: stack == null ? null : StackTrace.fromString(stack),
      device: DeviceSnapshot.fromJson(json['device'] as Map<String, dynamic>),
      recentEvents: (json['recentEvents'] as List).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      userDescription: json['userDescription'] as String? ?? '',
    );
  }

  final Object error;
  final StackTrace? stackTrace;
  final DeviceSnapshot device;
  final List<String> recentEvents;
  final DateTime createdAt;

  static const int _summaryLength = 120;

  String get fileName {
    final stamp = createdAt
        .toUtc()
        .toIso8601String()
        .split('.')
        .first
        .replaceAll(':', '-');
    return 'maalem_error_$stamp.txt';
  }

  /// First line of the error, short enough for an email body or a title.
  String get summary {
    final firstLine = error.toString().split('\n').first.trim();
    if (firstLine.length <= _summaryLength) return firstLine;
    return '${firstLine.substring(0, _summaryLength)}…';
  }

  String toText() {
    final stack = stackTrace?.toString().trimRight() ?? '';
    final sb = StringBuffer()
      ..writeln('=== Error report ===')
      ..writeln('Time (UTC): ${createdAt.toUtc().toIso8601String()}')
      ..writeln();
    final description = userDescription.trim();
    _section(
      sb,
      'User description',
      description.isEmpty ? const [] : [description],
    );
    _section(sb, 'Device', device.lines);
    _section(sb, 'Error', [error.toString().trimRight()]);
    _section(sb, 'Stack trace', stack.isEmpty ? const [] : [stack]);
    _section(sb, 'Recent events', recentEvents, last: true);
    return sb.toString();
  }

  static void _section(
    StringBuffer sb,
    String title,
    List<String> lines, {
    bool last = false,
  }) {
    sb.writeln('=== $title ===');
    if (lines.isEmpty) {
      sb.writeln('(none)');
    } else {
      lines.forEach(sb.writeln);
    }
    if (!last) sb.writeln();
  }
}
