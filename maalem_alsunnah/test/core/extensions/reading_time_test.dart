import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';

void main() {
  group('readableWordCount', () {
    test('counts Arabic words, with or without diacritics', () {
      expect('عَنْ أَنَسٍ قَالَ'.readableWordCount, 3);
      expect('عن أنس قال'.readableWordCount, 3);
    });

    test('ignores separators, punctuation and bare numbers', () {
      // "40 - (ق) عن أنس: قال · صحيح ." -> (ق) عن أنس: قال صحيح
      expect('40 - (ق) عن أنس: قال · صحيح .'.readableWordCount, 5);
      expect('- : · ، . □ 12'.readableWordCount, 0);
    });

    test('a reference token counts once', () {
      expect('«قال»[خ15/م44]'.readableWordCount, 1);
    });

    test('empty and whitespace-only text', () {
      expect(''.readableWordCount, 0);
      expect('  \n\t '.readableWordCount, 0);
    });
  });

  group('readingTimeDisplay', () {
    String words(int n) => List.filled(n, 'كلمة').join(' ');

    test('nothing to read shows nothing', () {
      expect(''.readingTimeDisplay.$1, ReadingTimeUnit.none);
      expect('- : 12'.readingTimeDisplay.$1, ReadingTimeUnit.none);
    });

    test('under a minute is shown in seconds, rounded to 5 (min 5)', () {
      expect(words(1).readingTimeDisplay, (ReadingTimeUnit.seconds, 5)); // 0.4 s
      expect(words(23).readingTimeDisplay, (ReadingTimeUnit.seconds, 10)); // 10 s
      expect(words(46).readingTimeDisplay, (ReadingTimeUnit.seconds, 20)); // 20 s
      expect(words(126).readingTimeDisplay, (ReadingTimeUnit.seconds, 55)); // 54.8 s
    });

    test('from about a minute it switches to whole minutes', () {
      expect(words(131).readingTimeDisplay, (ReadingTimeUnit.seconds, 55)); // 57 s
      expect(words(133).readingTimeDisplay, (ReadingTimeUnit.minutes, 1)); // 58 s rounds to 60
      expect(words(138).readingTimeDisplay, (ReadingTimeUnit.minutes, 1));
      expect(words(207).readingTimeDisplay, (ReadingTimeUnit.minutes, 2)); // 1.5 min
      expect(words(1380).readingTimeDisplay, (ReadingTimeUnit.minutes, 10));
    });

    test('separators do not add time', () {
      final padded = '${words(138)} ${List.filled(100, '-').join(' ')}';
      expect(padded.readingTimeDisplay, (ReadingTimeUnit.minutes, 1));
    });
  });
}
