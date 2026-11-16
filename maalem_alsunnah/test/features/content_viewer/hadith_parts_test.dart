import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/hadith_parts.dart';

// Samples are real rows from assets/db/book.db (shortened where marked).
void main() {
  group('HadithParts', () {
    test('number, agreed-upon source and two references', () {
      final p = HadithParts.parse(
        '40 - (ق) عَنْ أَنَسٍ: قَالَ: «لاَ يُؤْمِنُ أَحَدُكُمْ»[خ15/م44]',
      );
      expect(p.number, '40');
      expect(p.source, HadithSource.agreedUpon);
      expect(p.body, 'عَنْ أَنَسٍ: قَالَ: «لاَ يُؤْمِنُ أَحَدُكُمْ»');
      expect(p.references, const [
        HadithReference(code: 'خ', detail: '15'),
        HadithReference(code: 'م', detail: '44'),
      ]);
      expect(p.references.first.bookName, 'البخاري');
      expect(p.grade, isNull);
    });

    test("(خ) is al-Bukhari; (خــ) with tatweel is his mu'allaq reports", () {
      expect(HadithParts.parse('7 - (خ) عن ...[خ1]').source, HadithSource.bukhari);
      expect(HadithParts.parse('7 - (خــ) عن ...[خ1]').source, HadithSource.bukhariMuallaq);
      expect(HadithParts.parse('7 - (خـ) عن ...[خ1]').source, HadithSource.bukhariMuallaq);
    });

    test("every code in the book's table has a meaning", () {
      const table = {
        'خ': 'البخاري',
        'م': 'مسلم',
        'خـ': 'معلقات البخاري',
        'د': 'سنن أبي داود',
        'ت': 'سنن الترمذي',
        'ن': 'سنن النسائي',
        'جه': 'سنن ابن ماجه',
        'مي': 'سنن الدارمي',
        'حم': 'المسند',
        'ط': 'الموطأ',
        'مه': 'ابن خزيمة',
        'حب': 'ابن حبان',
        'ك': 'المستدرك',
        'هق': 'سنن البيهقي',
        'مخ': 'الأحاديث المختارة',
      };
      table.forEach((code, name) {
        expect(HadithReference.parse('${code}12').bookName, name, reason: code);
      });
      // Repeated tatweel is the same code.
      expect(HadithReference.parse('خــ12').code, 'خـ');
    });

    test('no source code; reference followed by a grading line', () {
      final p = HadithParts.parse(
        '2 - عَنْ مُعَاذِ بْنِ جَبَلٍ ... تَلَا﴿تَتَجَافَى﴾[السجدة:16، ١٧].\n\n'
        'ثُمَّ قَالَ: «إِلَّا حَصَائِدُ أَلْسِنَتِهِمْ»[ت2616/جه3973]\n\nصحيح.',
      );
      expect(p.number, '2');
      expect(p.source, isNull);
      expect(p.references.map((r) => r.label), ['ت 2616', 'جه 3973']);
      expect(p.grade, 'صحيح');
      expect(p.gradeLevel, HadithGradeLevel.accepted);
      // The Quran citation mid-text stays in the body.
      expect(p.body, contains('[السجدة:16، ١٧]'));
      expect(p.body, endsWith('أَلْسِنَتِهِمْ»'));
    });

    test('grade with a leading middle dot', () {
      final p = HadithParts.parse('9 - عن ... «...»[د123]\n\n· إسناده صحيح.');
      expect(p.grade, 'إسناده صحيح');
    });

    test('a long paragraph after the last bracket means it is not a reference', () {
      const text =
          '5 - عن ... [خ1]\n\nوفي رواية: «...» طويلة جدا جدا جدا جدا جدا جدا جدا جدا جدا جدا جدا جدا';
      final p = HadithParts.parse(text);
      expect(p.references, isEmpty);
      expect(p.body, text.substring('5 - '.length));
    });

    test('a bracket that is not a collection reference stays in the body', () {
      final p = HadithParts.parse('6 - عن ... [وانظر: 3560 في أركان الإيمان].');
      expect(p.references, isEmpty);
      expect(p.body, 'عن ... [وانظر: 3560 في أركان الإيمان].');
    });

    test('a part without its own code continues the previous reference', () {
      final p = HadithParts.parse(
        '11 - عن أنس ... «ذلك»[مخ5/1773/حب354/هق10/123]\n\nإسناده صحيح.',
      );
      expect(p.references.map((r) => r.label), ['مخ 5/1773', 'حب 354', 'هق 10/123']);
      expect(p.references.first.bookName, 'الأحاديث المختارة');
    });

    test('a word is not mistaken for a collection code', () {
      expect(
          HadithReference.parse('العلم 11'), const HadithReference(code: null, detail: 'العلم 11'));
      expect(HadithReference.parse('جه3973'), const HadithReference(code: 'جه', detail: '3973'));
    });

    test('text without a number is kept whole', () {
      final p = HadithParts.parse('نص بلا رقم');
      expect(p.number, isNull);
      expect(p.body, 'نص بلا رقم');
    });

    test('weak grades are recognised', () {
      expect(HadithParts.parse('1 - x[ت1]\n\nضعيف.').gradeLevel, HadithGradeLevel.weak);
      expect(HadithParts.parse('1 - x[ت1]\n\nرجاله ثقات.').gradeLevel, HadithGradeLevel.neutral);
    });
  });

  group('ChapterParts', () {
    test('numbered باب with intro paragraphs', () {
      final c = ChapterParts.parse(
        '1 - باب: أركان الإسلام والإيمان\n\nقال تعالى: ﴿يَاأَيُّهَا الَّذِينَ آمَنُوا﴾[النساء: 136]',
      );
      expect(c.number, '1');
      expect(c.heading, 'أركان الإسلام والإيمان');
      expect(c.intro, 'قال تعالى: ﴿يَاأَيُّهَا الَّذِينَ آمَنُوا﴾[النساء: 136]');
    });

    test('بابٌ with tanween and no intro', () {
      final c = ChapterParts.parse('15 - بابٌ: حبِّ النبيِّ صلى الله عليه وسلم');
      expect(c.number, '15');
      expect(c.heading, 'حبِّ النبيِّ صلى الله عليه وسلم');
      expect(c.intro, isNull);
    });

    test('unnumbered heading', () {
      final c = ChapterParts.parse('المقصد الأول: العقيدة');
      expect(c.number, isNull);
      expect(c.heading, 'المقصد الأول: العقيدة');
    });
  });
}
