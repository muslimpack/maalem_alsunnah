// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_color.dart';
import 'package:maalem_alsunnah/src/core/models/wrapped.dart';

class TextFormatterColorSettings {
  final Color? defaultColor;
  final Color? hadithTextColor;
  final Color? quranTextColor;
  final Color? squareBracketsColor;
  final Color? roundBracketsColor;
  final Color? startingNumberColor;

  const TextFormatterColorSettings({
    required this.defaultColor,
    required this.hadithTextColor,
    required this.quranTextColor,
    required this.squareBracketsColor,
    required this.roundBracketsColor,
    required this.startingNumberColor,
  });

  factory TextFormatterColorSettings.normal() {
    return TextFormatterColorSettings(
      defaultColor: Colors.black,
      hadithTextColor: Colors.yellow[700],
      quranTextColor: Colors.lightGreen[300],
      squareBracketsColor: Colors.cyan[300],
      roundBracketsColor: Colors.red[300],
      startingNumberColor: Colors.purple[300],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deafaultColor': defaultColor?.toARGB32,
      'hadithTextColor': hadithTextColor?.toARGB32,
      'quranTextColor': quranTextColor?.toARGB32,
      'squareBracketsColor': squareBracketsColor?.toARGB32,
      'roundBracketsColor': roundBracketsColor?.toARGB32,
      'startingNumberColor': startingNumberColor?.toARGB32,
    };
  }

  factory TextFormatterColorSettings.fromMap(Map<String, dynamic> map) {
    return TextFormatterColorSettings(
      defaultColor: map['deafaultColor'] == null
          ? null
          : Color(map['deafaultColor'] as int),
      hadithTextColor: map['hadithTextColor'] == null
          ? null
          : Color(map['hadithTextColor'] as int),
      quranTextColor: map['quranTextColor'] == null
          ? null
          : Color(map['quranTextColor'] as int),
      squareBracketsColor: map['squareBracketsColor'] == null
          ? null
          : Color(map['squareBracketsColor'] as int),
      roundBracketsColor: map['roundBracketsColor'] == null
          ? null
          : Color(map['roundBracketsColor'] as int),
      startingNumberColor: map['startingNumberColor'] == null
          ? null
          : Color(map['startingNumberColor'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TextFormatterColorSettings.fromJson(String source) =>
      TextFormatterColorSettings.fromMap(
          json.decode(source) as Map<String, dynamic>);

  TextFormatterColorSettings copyWith({
    Wrapped<Color?>? defaultColor,
    Wrapped<Color?>? hadithTextColor,
    Wrapped<Color?>? quranTextColor,
    Wrapped<Color?>? squareBracketsColor,
    Wrapped<Color?>? roundBracketsColor,
    Wrapped<Color?>? startingNumberColor,
  }) {
    return TextFormatterColorSettings(
      defaultColor:
          defaultColor != null ? defaultColor.value : this.defaultColor,
      hadithTextColor: hadithTextColor != null
          ? hadithTextColor.value
          : this.hadithTextColor,
      quranTextColor:
          quranTextColor != null ? quranTextColor.value : this.quranTextColor,
      squareBracketsColor: squareBracketsColor != null
          ? squareBracketsColor.value
          : this.squareBracketsColor,
      roundBracketsColor: roundBracketsColor != null
          ? roundBracketsColor.value
          : this.roundBracketsColor,
      startingNumberColor: startingNumberColor != null
          ? startingNumberColor.value
          : this.startingNumberColor,
    );
  }
}
