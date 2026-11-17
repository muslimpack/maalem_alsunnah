import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/app_info.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';
import 'package:maalem_alsunnah/src/features/themes/data/repository/theme_repo.dart';

/// Reads the allowlisted [DeviceSnapshot] fields from the platform.
///
/// Needs no [BuildContext], so it works from a global error handler and
/// before the app finished starting. Every lookup is best-effort.
Future<DeviceSnapshot> loadDeviceSnapshot() async {
  final dispatcher = PlatformDispatcher.instance;
  final view = dispatcher.views.firstOrNull;
  final ratio = view?.devicePixelRatio ?? 1;
  final size = (view?.physicalSize ?? Size.zero) / ratio;
  final (os, manufacturer, model) = await _readDevice();

  return DeviceSnapshot(
    appVersion: AppInfo.version,
    buildNumber: AppInfo.buildNumber,
    platform: kIsWeb ? 'web' : defaultTargetPlatform.name,
    osVersion: os,
    manufacturer: manufacturer,
    model: model,
    appLocale: Intl.getCurrentLocale(),
    systemLocale: dispatcher.locale.toLanguageTag(),
    screenSize: '${size.width.round()}x${size.height.round()}',
    pixelRatio: ratio,
    theme: _theme(),
  );
}

String _theme() {
  try {
    return sl<ThemeRepo>().brightness.name;
  } catch (_) {
    return 'unknown';
  }
}

/// Only OS and hardware model are read. Device names, user names, serials
/// and IDs that these plugins also expose are deliberately ignored.
Future<(String?, String?, String?)> _readDevice() async {
  try {
    final plugin = DeviceInfoPlugin();
    if (kIsWeb) {
      final web = await plugin.webBrowserInfo;
      return (web.platform, null, web.browserName.name);
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final a = await plugin.androidInfo;
        return (
          'Android ${a.version.release} (SDK ${a.version.sdkInt})',
          a.manufacturer,
          a.model,
        );
      case TargetPlatform.iOS:
        final i = await plugin.iosInfo;
        return (
          '${i.systemName} ${i.systemVersion}',
          'Apple',
          i.utsname.machine,
        );
      case TargetPlatform.windows:
        final w = await plugin.windowsInfo;
        return (
          '${w.productName} ${w.displayVersion} (${w.buildNumber})',
          null,
          null,
        );
      case TargetPlatform.macOS:
        final m = await plugin.macOsInfo;
        return ('macOS ${m.osRelease}', 'Apple', m.model);
      case TargetPlatform.linux:
        final l = await plugin.linuxInfo;
        return (l.prettyName, null, null);
      case TargetPlatform.fuchsia:
        return (null, null, null);
    }
  } catch (_) {
    return (null, null, null);
  }
}
