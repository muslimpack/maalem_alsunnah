/// Structure extracted from a hadith row of `book.db`.
///
/// A hadith text looks like:
/// `40 - (ق) عَنْ أَنَسٍ ... «...»[خ15/م44]\n\nصحيح.`
/// i.e. number, optional source code, body, optional trailing reference in
/// square brackets, optional grading line. Anything that doesn't fit stays in
/// [body] untouched, so parsing never loses text.
library;

/// The source code at the start of a hadith: (ق), (خ), (م), or (خـ) for the
/// mu'allaq (unconnected) reports of al-Bukhari.
enum HadithSource { agreedUpon, bukhari, bukhariMuallaq, muslim }

enum HadithGradeLevel { accepted, weak, neutral }

class HadithReference {
  /// Collection code such as `خ`, `م`, `ت`, `جه`; null if it couldn't be read.
  final String? code;

  /// What follows the code, usually the hadith number (`15`).
  final String detail;

  const HadithReference({required this.code, required this.detail});

  factory HadithReference.parse(String raw) {
    final m = RegExp(r'^([ء-ي]{1,3})(?![ء-ي])\.?\s*(.*)$').firstMatch(raw.trim());
    if (m == null) return HadithReference(code: null, detail: raw.trim());
    // "خــ" and "خـ" are the same code (معلقات البخاري): keep one tatweel.
    final code = m.group(1)!.replaceAll(RegExp('ـ+'), 'ـ');
    return HadithReference(code: code, detail: m.group(2)!.trim());
  }

  /// What [code] stands for, as given in the book's own table of codes
  /// (المقدمة › المبحث الثالث › ثالثاً: المصطلحات).
  String? get bookName => _bookNames[code];

  String get label => code == null ? detail : '$code $detail'.trim();

  /// The book's table of codes, in its order and wording. (In the table `ت`
  /// also marks the author's footnotes, but inside a reference it is always
  /// the Sunan of al-Tirmidhi.)
  static const _bookNames = {
    'خ': 'البخاري',
    'م': 'مسلم',
    'ق': 'متفق عليه',
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
    'ع': 'من رواية عبدالله بن الإمام أحمد أو وجاداته',
  };

  @override
  bool operator ==(Object other) =>
      other is HadithReference && other.code == code && other.detail == detail;

  @override
  int get hashCode => Object.hash(code, detail);

  @override
  String toString() => 'HadithReference($label)';
}

class HadithParts {
  final String? number;
  final HadithSource? source;
  final String body;
  final List<HadithReference> references;
  final String? grade;

  const HadithParts({
    required this.body,
    this.number,
    this.source,
    this.references = const [],
    this.grade,
  });

  HadithGradeLevel get gradeLevel {
    final g = grade;
    if (g == null) return HadithGradeLevel.neutral;
    if (RegExp('ضعيف|منكر|موضوع|لا يصح').hasMatch(g)) return HadithGradeLevel.weak;
    if (RegExp('صحيح|حسن|جيد|على شرط').hasMatch(g)) return HadithGradeLevel.accepted;
    return HadithGradeLevel.neutral;
  }

  static final _head = RegExp(r'^\s*(\d+)\s*-\s*(?:\(\s*(ق|خ|م)(ـ*)\s*\)\s*)?');
  static final _lastBracket = RegExp(r'\[([^\[\]]*)\]');
  static final _refStart = RegExp(r'^\s*[ء-ي]{1,3}\.?\s*\d');

  factory HadithParts.parse(String text) {
    var rest = text.trim();
    String? number;
    HadithSource? source;

    final head = _head.firstMatch(rest);
    if (head != null) {
      number = head.group(1);
      final muallaq = head.group(3)?.isNotEmpty ?? false;
      source = switch (head.group(2)) {
        'ق' => HadithSource.agreedUpon,
        'خ' when muallaq => HadithSource.bukhariMuallaq,
        'خ' => HadithSource.bukhari,
        'م' => HadithSource.muslim,
        _ => null,
      };
      rest = rest.substring(head.end);
    }

    // Only the LAST bracket can be the reference, and only when nothing but a
    // short grading line follows it. Brackets mid-text (Quran citations such
    // as [السجدة:16], cross references) stay in the body.
    final brackets = _lastBracket.allMatches(rest);
    if (brackets.isNotEmpty) {
      final last = brackets.last;
      final inner = last.group(1)!;
      final tail = rest.substring(last.end).trim();
      final tailIsGrade =
          tail.isEmpty || (tail.length <= 60 && !tail.contains('\n') && !tail.contains('«'));
      if (tailIsGrade && _refStart.hasMatch(inner)) {
        return HadithParts(
          number: number,
          source: source,
          body: rest.substring(0, last.start).trim(),
          references: _parseReferences(inner),
          grade: _cleanGrade(tail),
        );
      }
    }

    return HadithParts(number: number, source: source, body: rest);
  }

  /// Splits `خ15/م44` into references. A part without its own code continues
  /// the one before it: `مخ5/1773` is volume 5, number 1773 of the same book
  /// (likewise `هق10/123`), so it stays one reference, `مخ 5/1773`.
  static List<HadithReference> _parseReferences(String inner) {
    final references = <HadithReference>[];
    for (final part in inner.split('/')) {
      if (part.trim().isEmpty) continue;
      final reference = HadithReference.parse(part);
      if (reference.code == null && references.isNotEmpty) {
        final previous = references.removeLast();
        references.add(HadithReference(
          code: previous.code,
          detail: '${previous.detail}/${reference.detail}',
        ));
      } else {
        references.add(reference);
      }
    }
    return references;
  }

  static String? _cleanGrade(String tail) {
    final g = tail.replaceFirst(RegExp(r'^[·\s]+'), '').replaceFirst(RegExp(r'[.\s]+$'), '');
    return g.isEmpty ? null : g;
  }
}

/// Structure of a chapter row (a hadith row without an id):
/// `15 - باب: حبِّ النبيِّ ...` optionally followed by intro paragraphs
/// (verses, commentary). Rows like `المقصد الأول: العقيدة` have no number.
class ChapterParts {
  final String? number;
  final String heading;
  final String? intro;

  const ChapterParts({required this.heading, this.number, this.intro});

  static final _numbered = RegExp(r'^\s*(\d+)\s*-\s*(?:بابٌ?\s*:?\s*)?(.*)$');

  factory ChapterParts.parse(String text) {
    final trimmed = text.trim();
    final newline = trimmed.indexOf('\n');
    final firstLine = (newline == -1 ? trimmed : trimmed.substring(0, newline)).trim();
    final intro = newline == -1 ? null : trimmed.substring(newline).trim();

    final m = _numbered.firstMatch(firstLine);
    final heading = m != null && m.group(2)!.trim().isNotEmpty ? m.group(2)!.trim() : firstLine;
    return ChapterParts(
      number: m?.group(1),
      heading: heading,
      intro: intro == null || intro.isEmpty ? null : intro,
    );
  }
}
