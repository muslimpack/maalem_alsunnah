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
}
