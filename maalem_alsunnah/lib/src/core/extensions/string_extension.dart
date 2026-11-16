import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';

/// Silent reading speed used for reading-time estimates (words per minute).
const int arabicWordsPerMinute = 138;

enum ReadingTimeUnit { none, seconds, minutes }

final _tokenRegExp = RegExp(r'\S+');
final _letterRegExp = RegExp('[ء-يٱ-ۓa-zA-Z]');

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

  /// Words a reader actually reads: whitespace-separated tokens that contain
  /// at least one letter. Separators such as `-`, `:`, `·`, `،` and bare
  /// numbers (6% of tokens in book.db) are not counted.
  int get readableWordCount =>
      _tokenRegExp.allMatches(this).where((m) => _letterRegExp.hasMatch(m[0]!)).length;

  /// Estimated reading time.
  ///
  /// Uses 138 words per minute, the adult silent-reading speed reported for
  /// Arabic in the IReST standardized texts; vowelled classical text is read
  /// no faster, so this errs on the short side rather than the long one.
  Duration get readingTime =>
      Duration(seconds: (readableWordCount * 60 / arabicWordsPerMinute).round());

  /// [readingTime] as shown to the reader, or null when there is nothing to
  /// read. See [formatReadingTime].
  String? getArabicTextReadingTimeAsString(BuildContext context) {
    if (readableWordCount == 0) return null;
    return formatReadingTime(context, readingTime);
  }

  /// The unit and rounded value used by [getArabicTextReadingTimeAsString].
  (ReadingTimeUnit, int) get readingTimeDisplay {
    if (readableWordCount == 0) return (ReadingTimeUnit.none, 0);
    return readingTimeDisplayOf(readingTime);
  }
}

/// How a reading duration is shown: under a minute in seconds rounded to 5
/// (at least 5), otherwise in whole minutes. The estimate isn't precise
/// enough for more.
(ReadingTimeUnit, int) readingTimeDisplayOf(Duration duration) {
  final seconds = duration.inSeconds;
  final roundedSeconds = math.max(5, (seconds / 5).round() * 5);
  if (roundedSeconds < 60) return (ReadingTimeUnit.seconds, roundedSeconds);
  return (ReadingTimeUnit.minutes, math.max(1, (seconds / 60).round()));
}

/// "٢٠ ثانية", "دقيقتان", "٣ دقائق" for [duration].
String formatReadingTime(BuildContext context, Duration duration) {
  final (unit, value) = readingTimeDisplayOf(duration);
  return unit == ReadingTimeUnit.minutes
      ? S.of(context).readingTimeMinutes(value)
      : S.of(context).readingTimeSeconds(value);
}
