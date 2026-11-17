/// The non-sensitive device data a user may attach to a report.
///
/// This class *is* the allowlist: anything not a field here is never sent.
/// No device IDs, advertising IDs, IPs, account names or file paths.
class DeviceSnapshot {
  const DeviceSnapshot({
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.osVersion,
    required this.manufacturer,
    required this.model,
    required this.appLocale,
    required this.systemLocale,
    required this.screenSize,
    required this.pixelRatio,
    required this.theme,
  });

  final String appVersion;
  final String buildNumber;
  final String platform;
  final String? osVersion;
  final String? manufacturer;
  final String? model;
  final String appLocale;
  final String systemLocale;
  final String screenSize;
  final double pixelRatio;
  final String theme;

  Map<String, Object?> toJson() => {
        'appVersion': appVersion,
        'buildNumber': buildNumber,
        'platform': platform,
        'osVersion': osVersion,
        'manufacturer': manufacturer,
        'model': model,
        'appLocale': appLocale,
        'systemLocale': systemLocale,
        'screenSize': screenSize,
        'pixelRatio': pixelRatio,
        'theme': theme,
      };

  factory DeviceSnapshot.fromJson(Map<String, dynamic> json) => DeviceSnapshot(
        appVersion: json['appVersion'] as String,
        buildNumber: json['buildNumber'] as String,
        platform: json['platform'] as String,
        osVersion: json['osVersion'] as String?,
        manufacturer: json['manufacturer'] as String?,
        model: json['model'] as String?,
        appLocale: json['appLocale'] as String,
        systemLocale: json['systemLocale'] as String,
        screenSize: json['screenSize'] as String,
        pixelRatio: (json['pixelRatio'] as num).toDouble(),
        theme: json['theme'] as String,
      );

  static const _unknown = 'unknown';

  List<String> get lines {
    final device = [manufacturer, model].whereType<String>().join(' ');
    return [
      'App version: $appVersion+$buildNumber',
      'Platform: $platform',
      'OS: ${osVersion ?? _unknown}',
      'Device: ${device.isEmpty ? _unknown : device}',
      'App locale: $appLocale',
      'System locale: $systemLocale',
      'Screen: $screenSize @${_ratio(pixelRatio)}x',
      'Theme: $theme',
    ];
  }

  static String _ratio(double value) {
    final fixed = value.toStringAsFixed(2);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
