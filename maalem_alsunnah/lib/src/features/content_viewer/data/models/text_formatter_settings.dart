import 'package:flutter/material.dart';

class TextFormatterSettings {
  final TextStyle deafaultStyle;
  final TextStyle hadithTextStyle;
  final TextStyle quranTextStyle;
  final TextStyle squareBracketsStyle;
  final TextStyle roundBracketsStyle;

  const TextFormatterSettings({
    required this.deafaultStyle,
    required this.hadithTextStyle,
    required this.quranTextStyle,
    required this.squareBracketsStyle,
    required this.roundBracketsStyle,
  });
}
