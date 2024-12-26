// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HadithImageCardSettings extends Equatable {
  ///Image size
  final Size imageSize;
  final int charLengthPerSize;

  ///Text style
  final String mainFontFamily;
  final String secondaryFontFamily;

  const HadithImageCardSettings({
    required this.imageSize,
    required this.charLengthPerSize,
    required this.mainFontFamily,
    required this.secondaryFontFamily,
  });

  const HadithImageCardSettings.defaultSettings()
      : this(
          imageSize: const Size(1080, 1080),
          charLengthPerSize: 1500,
          mainFontFamily: "adwaa",
          secondaryFontFamily: "adwaa",
        );

  @override
  List<Object> get props => [
        imageSize,
        charLengthPerSize,
        mainFontFamily,
        secondaryFontFamily,
      ];

  HadithImageCardSettings copyWith({
    Size? imageSize,
    int? charLengthPerSize,
    String? mainFontFamily,
    String? secondaryFontFamily,
  }) {
    return HadithImageCardSettings(
      imageSize: imageSize ?? this.imageSize,
      charLengthPerSize: charLengthPerSize ?? this.charLengthPerSize,
      mainFontFamily: mainFontFamily ?? this.mainFontFamily,
      secondaryFontFamily: secondaryFontFamily ?? this.secondaryFontFamily,
    );
  }
}
