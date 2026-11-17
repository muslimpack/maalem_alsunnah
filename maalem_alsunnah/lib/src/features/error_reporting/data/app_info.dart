import 'package:package_info_plus/package_info_plus.dart';

/// App version and build number, read from the platform once at startup.
class AppInfo {
  const AppInfo._();

  static String version = 'unknown';
  static String buildNumber = 'unknown';

  /// Safe to call more than once; failures keep the `unknown` placeholders.
  static Future<void> load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      version = info.version;
      buildNumber = info.buildNumber;
    } catch (_) {
      // Keep placeholders; a missing version must never block startup.
    }
  }
}
