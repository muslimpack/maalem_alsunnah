import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_color_settings.dart';

/// A colour family for the shared image. Each one has a hand-tuned light and
/// dark variant, see [ShareImageTheme.resolve].
enum ShareImagePalette { maroon, emerald, indigo, sand }

/// The colours of one shared-image preset.
///
/// The formatter colours (hadith, Quran, brackets, numbers) belong to the
/// preset rather than to the reader's in-app settings, so they always keep
/// their contrast against this preset's background.
class ShareImageTheme {
  final ShareImagePalette palette;
  final Brightness brightness;

  final Color background;
  final Color text;
  final Color accent;

  /// Opacity of the tiled pattern drawn behind the content.
  final double patternOpacity;

  final TextFormatterColorSettings formatterColors;

  const ShareImageTheme({
    required this.palette,
    required this.brightness,
    required this.background,
    required this.text,
    required this.accent,
    required this.patternOpacity,
    required this.formatterColors,
  });

  bool get isDark => brightness == Brightness.dark;

  /// Lines and ornaments: the accent, softened.
  Color get ornament => accent.withValues(alpha: isDark ? .55 : .6);

  /// Secondary text such as the hashtag.
  Color get mutedText => text.withValues(alpha: .62);

  static ShareImageTheme resolve(ShareImagePalette palette, Brightness brightness) {
    return _themes.firstWhere(
      (theme) => theme.palette == palette && theme.brightness == brightness,
    );
  }

  static const List<ShareImageTheme> _themes = [
    // Maroon: the app's brand colour. The dark variant is the previous card.
    ShareImageTheme(
      palette: ShareImagePalette.maroon,
      brightness: Brightness.dark,
      background: Color(0xff1a110e),
      text: Color(0xfff3e9e1),
      accent: Color(0xfffeb99c),
      patternOpacity: .07,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xfff3e9e1),
        hadithTextColor: Color(0xffffd48a),
        quranTextColor: Color(0xffa8d8a0),
        squareBracketsColor: Color(0xff9fd3e0),
        roundBracketsColor: Color(0xfff2a3a3),
        startingNumberColor: Color(0xffd5b8f2),
      ),
    ),
    ShareImageTheme(
      palette: ShareImagePalette.maroon,
      brightness: Brightness.light,
      background: Color(0xfff6efe2),
      text: Color(0xff2b1d16),
      accent: Color(0xff6b2a22),
      patternOpacity: .08,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xff2b1d16),
        hadithTextColor: Color(0xff8a4b0f),
        quranTextColor: Color(0xff2f6b3a),
        squareBracketsColor: Color(0xff1f5f73),
        roundBracketsColor: Color(0xff9a2f2f),
        startingNumberColor: Color(0xff6a3d8c),
      ),
    ),

    // Emerald
    ShareImageTheme(
      palette: ShareImagePalette.emerald,
      brightness: Brightness.dark,
      background: Color(0xff0f2a22),
      text: Color(0xffeaf2ec),
      accent: Color(0xffd4b26a),
      patternOpacity: .07,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xffeaf2ec),
        hadithTextColor: Color(0xffe8c77a),
        quranTextColor: Color(0xff9fe0b5),
        squareBracketsColor: Color(0xff8fcbe0),
        roundBracketsColor: Color(0xfff0a8a0),
        startingNumberColor: Color(0xffc9b3f0),
      ),
    ),
    ShareImageTheme(
      palette: ShareImagePalette.emerald,
      brightness: Brightness.light,
      background: Color(0xffeef3ec),
      text: Color(0xff16302a),
      accent: Color(0xff1f4d3a),
      patternOpacity: .08,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xff16302a),
        hadithTextColor: Color(0xff8a5a12),
        quranTextColor: Color(0xff1f6b45),
        squareBracketsColor: Color(0xff1d5c7a),
        roundBracketsColor: Color(0xff9c3b2f),
        startingNumberColor: Color(0xff5b3f8a),
      ),
    ),

    // Indigo
    ShareImageTheme(
      palette: ShareImagePalette.indigo,
      brightness: Brightness.dark,
      background: Color(0xff111827),
      text: Color(0xffe7eaf3),
      accent: Color(0xffe9dfc7),
      patternOpacity: .06,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xffe7eaf3),
        hadithTextColor: Color(0xfff2c879),
        quranTextColor: Color(0xff9bd8b0),
        squareBracketsColor: Color(0xff8cc8ea),
        roundBracketsColor: Color(0xfff0a3b0),
        startingNumberColor: Color(0xffc3b1f5),
      ),
    ),
    ShareImageTheme(
      palette: ShareImagePalette.indigo,
      brightness: Brightness.light,
      background: Color(0xfff4f5fa),
      text: Color(0xff1a2033),
      accent: Color(0xff2e3a6b),
      patternOpacity: .07,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xff1a2033),
        hadithTextColor: Color(0xff8c5a0a),
        quranTextColor: Color(0xff24693f),
        squareBracketsColor: Color(0xff1e5e86),
        roundBracketsColor: Color(0xffa2333f),
        startingNumberColor: Color(0xff5a3e99),
      ),
    ),

    // Sand
    ShareImageTheme(
      palette: ShareImagePalette.sand,
      brightness: Brightness.dark,
      background: Color(0xff2a2318),
      text: Color(0xfff1e8d6),
      accent: Color(0xffe0a85a),
      patternOpacity: .07,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xfff1e8d6),
        hadithTextColor: Color(0xfff3cf86),
        quranTextColor: Color(0xffb5d99a),
        squareBracketsColor: Color(0xff9ccfd6),
        roundBracketsColor: Color(0xffefa58f),
        startingNumberColor: Color(0xffd0b6e8),
      ),
    ),
    ShareImageTheme(
      palette: ShareImagePalette.sand,
      brightness: Brightness.light,
      background: Color(0xffefe4cf),
      text: Color(0xff2e2a1c),
      accent: Color(0xff5a5a2a),
      patternOpacity: .09,
      formatterColors: TextFormatterColorSettings(
        defaultColor: Color(0xff2e2a1c),
        hadithTextColor: Color(0xff8b4f0e),
        quranTextColor: Color(0xff3d6b2a),
        squareBracketsColor: Color(0xff2a5e6e),
        roundBracketsColor: Color(0xff993a2a),
        startingNumberColor: Color(0xff6a4a7a),
      ),
    ),
  ];
}
