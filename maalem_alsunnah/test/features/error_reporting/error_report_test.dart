import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';

void main() {
  const device = DeviceSnapshot(
    appVersion: '0.2.01',
    buildNumber: '3',
    platform: 'android',
    osVersion: 'Android 14',
    manufacturer: 'Google',
    model: 'Pixel 8',
    appLocale: 'ar',
    systemLocale: 'ar',
    screenSize: '411x914',
    pixelRatio: 3,
    theme: 'light',
  );

  group('ErrorReport', () {
    test(
        'text has the user description, device, error, stack and recent '
        'events, in that order', () {
      final report = ErrorReport(
        error: 'Bad state: No element',
        stackTrace: StackTrace.fromString('#0 main (file.dart:1)'),
        device: device,
        recentEvents: const ['09:00:00 route: /home'],
        createdAt: DateTime.utc(2026, 11, 17, 10, 22, 5),
      ).withDescription('  Opened a bookmark\nthen it closed  ');

      expect(
        report.toText(),
        '=== Error report ===\n'
        'Time (UTC): 2026-11-17T10:22:05.000Z\n'
        '\n'
        '=== User description ===\n'
        'Opened a bookmark\n'
        'then it closed\n'
        '\n'
        '=== Device ===\n'
        'App version: 0.2.01+3\n'
        'Platform: android\n'
        'OS: Android 14\n'
        'Device: Google Pixel 8\n'
        'App locale: ar\n'
        'System locale: ar\n'
        'Screen: 411x914 @3x\n'
        'Theme: light\n'
        '\n'
        '=== Error ===\n'
        'Bad state: No element\n'
        '\n'
        '=== Stack trace ===\n'
        '#0 main (file.dart:1)\n'
        '\n'
        '=== Recent events ===\n'
        '09:00:00 route: /home\n',
      );
    });

    test('missing stack trace and empty history are stated, not blank', () {
      final text = ErrorReport(
        error: 'oops',
        stackTrace: null,
        device: device,
        recentEvents: const [],
        createdAt: DateTime.utc(2026),
      ).toText();

      expect(text, contains('=== User description ===\n(none)\n'));
      expect(text, contains('=== Stack trace ===\n(none)\n'));
      expect(text, contains('=== Recent events ===\n(none)\n'));
    });

    test('a blank description counts as none', () {
      final report = ErrorReport(
        error: 'oops',
        stackTrace: null,
        device: device,
        recentEvents: const [],
        createdAt: DateTime.utc(2026),
      ).withDescription('   \n ');

      expect(report.toText(), contains('=== User description ===\n(none)\n'));
    });

    test('file name is a filesystem-safe timestamp', () {
      final report = ErrorReport(
        error: 'x',
        stackTrace: null,
        device: device,
        recentEvents: const [],
        createdAt: DateTime.utc(2026, 11, 17, 10, 22, 5),
      );

      expect(report.fileName, 'maalem_error_2026-11-17T10-22-05.txt');
    });

    test('summary is the first line of the error, capped', () {
      final report = ErrorReport(
        error: '${'a' * 200}\nsecond line',
        stackTrace: null,
        device: device,
        recentEvents: const [],
        createdAt: DateTime.utc(2026),
      );

      expect(report.summary, '${'a' * 120}…');
    });
  });
}
