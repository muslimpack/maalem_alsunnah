import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_color.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_platform.dart';

class ThemeRepo {
  final Box box;
  ThemeRepo(this.box);

  ///
  static const String _brightnessKey = "prefThemeBrightness";

  Brightness get brightness {
    final String? brightness = box.get(_brightnessKey) as String?;
    return brightness == Brightness.light.toString()
        ? Brightness.light
        : Brightness.dark;
  }

  Future setBrightness(Brightness brightness) async {
    await box.put(_brightnessKey, brightness.toString());
  }

  ///
  static const _fontFamilyKey = 'prefFontFamily';
  String get fontFamily => box.get(_fontFamilyKey) as String? ?? "Roboto";

  Future<void> changFontFamily(String value) async {
    box.put(_fontFamilyKey, value);
  }

  ///

  static const _appLocaleKey = 'prefAppLocale';
  Locale? get appLocale {
    final value = box.get(_appLocaleKey) as String?;
    final Locale? locale;
    if (value == null) {
      final languageCode = PlatformExtension.languageCode;
      if (languageCode == null) {
        locale = null;
      } else {
        ///TODO use languageCode
        // locale = Locale(languageCode);
        locale = const Locale("ar");
      }
    } else {
      locale = Locale(value);
    }

    return locale;
  }

  Future<void> changAppLocale(String value) async {
    box.put(_appLocaleKey, value);
  }

  ///
  static const String _colorKey = "prefThemeColor";

  Color get color {
    final int? data = box.get(_colorKey) as int?;
    final defaultValue = Color(0xFF451b1b);
    final result = Color(data ?? defaultValue.toARGB32);
    return result;
  }

  Future setColor(Color color) async {
    await box.put(_colorKey, color.toARGB32);
  }
}
