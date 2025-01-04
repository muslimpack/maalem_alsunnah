import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';

extension StringExtension on String {
  String get removeDiacritics {
    return replaceAll(
      RegExp(String.fromCharCodes(arabicDiacriticsChar)),
      "",
    );
  }

  String removeBrackets() {
    return replaceAll(RegExp('[()]'), '');
  }

  Duration getArabicTextReadingTime() {
    const int averageWordsPerMinute = 150;

    final wordCount = split(RegExp(r'\s+')).length;

    final totalReadingTimeInSeconds = (wordCount / averageWordsPerMinute) * 60;

    return Duration(seconds: totalReadingTimeInSeconds.round());
  }

  String getArabicTextReadingTimeAsString(BuildContext context) {
    final totalReadingTimeInSeconds = getArabicTextReadingTime().inSeconds;

    final minutes = totalReadingTimeInSeconds ~/ 60;
    final seconds = totalReadingTimeInSeconds % 60;

    if (minutes > 0) {
      return '$minutes ${S.of(context).minutes} ${seconds.toStringAsFixed(0)} ${S.of(context).seconds}';
    } else {
      return '${seconds.toStringAsFixed(0)} ${S.of(context).seconds}';
    }
  }
}
