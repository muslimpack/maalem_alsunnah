import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';

void main() {
  group('DeviceSnapshot', () {
    test('renders exactly the allowlisted fields, in a fixed order', () {
      const snapshot = DeviceSnapshot(
        appVersion: '0.2.01',
        buildNumber: '3',
        platform: 'android',
        osVersion: 'Android 14 (SDK 34)',
        manufacturer: 'Google',
        model: 'Pixel 8',
        appLocale: 'ar',
        systemLocale: 'en_US',
        screenSize: '411x914',
        pixelRatio: 2.625,
        theme: 'dark',
      );

      expect(snapshot.lines, [
        'App version: 0.2.01+3',
        'Platform: android',
        'OS: Android 14 (SDK 34)',
        'Device: Google Pixel 8',
        'App locale: ar',
        'System locale: en_US',
        'Screen: 411x914 @2.63x',
        'Theme: dark',
      ]);
    });

    test('missing device fields show as unknown instead of disappearing', () {
      const snapshot = DeviceSnapshot(
        appVersion: '0.2.01',
        buildNumber: '3',
        platform: 'web',
        osVersion: null,
        manufacturer: null,
        model: null,
        appLocale: 'ar',
        systemLocale: 'ar',
        screenSize: '1280x720',
        pixelRatio: 1,
        theme: 'light',
      );

      expect(snapshot.lines, contains('OS: unknown'));
      expect(snapshot.lines, contains('Device: unknown'));
    });
  });
}
