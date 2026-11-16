import 'package:flutter/painting.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_format_text_style.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_aspect.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_theme.dart';

/// Fixed measurements of the share card, in logical pixels of the 1080-wide
/// canvas. The card and the paginator both read them, so a page measured here
/// is exactly the page the card draws.
abstract final class ShareImageLayout {
  static const double paddingHorizontal = 96;
  static const double paddingTop = 92;
  static const double paddingBottom = 76;

  static const double titleHeight = 104;
  static const double titleGap = 12;
  static const double dividerHeight = 32;
  static const double headerGap = 28;

  static const double footerGap = 28;
  static const double footerHeight = 96;

  static const double bodyLineHeight = 1.85;
  static const String bodyFontFamily = 'adwaa';

  static double headerHeight({required bool showTitleChain}) {
    return (showTitleChain ? titleHeight + titleGap : 0) + dividerHeight + headerGap;
  }

  /// The box the text of one page must fit in.
  static Size bodySize(Size canvas, {required bool showTitleChain}) {
    return Size(
      canvas.width - paddingHorizontal * 2,
      canvas.height -
          paddingTop -
          paddingBottom -
          headerHeight(showTitleChain: showTitleChain) -
          footerGap -
          footerHeight,
    );
  }

  /// Fully specified (`inherit: false`) so the ambient text style of the
  /// screen can't change how the text measures.
  static TextStyle bodyStyle(ShareImageTheme theme, double fontSize) {
    return TextStyle(
      inherit: false,
      fontFamily: bodyFontFamily,
      fontSize: fontSize,
      height: bodyLineHeight,
      color: theme.text,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
      wordSpacing: 0,
      textBaseline: TextBaseline.alphabetic,
    );
  }
}

/// A text formatted once (hadith, Quran, brackets, numbers) and cut into
/// pages by character ranges of [text].
class SharePageText {
  static const String ellipsis = "...";

  final List<TextSpan> _spans;
  final TextStyle style;

  /// The concatenated text of the formatted spans. Page ranges index into
  /// this string.
  final String text;

  SharePageText._(this._spans, this.style) : text = _spans.map((s) => s.text ?? "").join();

  factory SharePageText.format(String text, ShareImageTheme theme, double fontSize) {
    final style = ShareImageLayout.bodyStyle(theme, fontSize);
    final settings = textFormatterSettingsFromColors(style, theme.formatterColors);
    final root = FormattedText(text: text, settings: settings).textSpan();
    final spans = (root.children ?? const []).whereType<TextSpan>().toList();
    return SharePageText._(spans, style);
  }

  /// The styled text of [range], with an ellipsis where the text continues
  /// from the previous page or onto the next one.
  TextSpan page(TextRange range) {
    final children = <InlineSpan>[];
    if (range.start > 0) children.add(const TextSpan(text: "$ellipsis "));

    int offset = 0;
    for (final span in _spans) {
      final spanText = span.text ?? "";
      final spanStart = offset;
      final spanEnd = offset + spanText.length;
      offset = spanEnd;

      if (spanEnd <= range.start) continue;
      if (spanStart >= range.end) break;

      final from = (range.start - spanStart).clamp(0, spanText.length);
      final to = (range.end - spanStart).clamp(0, spanText.length);
      if (from < to) {
        children.add(TextSpan(text: spanText.substring(from, to), style: span.style));
      }
    }

    if (range.end < text.length) children.add(const TextSpan(text: " $ellipsis"));

    return TextSpan(style: style, children: children);
  }
}

/// The result of laying a text out on the share card.
class ShareImagePagination {
  final ShareImageAspect aspect;
  final Size canvasSize;
  final List<TextRange> pages;

  /// The formatted text the [pages] index into, at its final font size.
  final SharePageText source;

  const ShareImagePagination({
    required this.aspect,
    required this.canvasSize,
    required this.pages,
    required this.source,
  });
}

/// Splits a text into pages that fit the card at one fixed font size.
///
/// Pages break between words, preferably after punctuation, and are evened
/// out so the last page isn't a short leftover.
class TextPaginator {
  /// How far back from the fullest break a page may end to land on
  /// punctuation, as a share of the page.
  static const double _punctuationReach = .2;
  static const String _breakChars = ".،؛:؟?!»)]﴾";

  final SharePageText source;
  final Size box;

  late final List<int> _ends = _wordEnds(source.text);

  TextPaginator(this.source, this.box);

  String get _text => source.text;

  /// How much a text that fits on one page may grow to fill the card.
  static const double maxSinglePageGrowth = 1.4;

  /// Lays [text] out on [aspect] at [fontSize], resolving
  /// [ShareImageAspect.auto] to the smallest size that holds the whole text
  /// on one page.
  ///
  /// When the text fits on one page its font grows (up to
  /// [maxSinglePageGrowth]) to fill the card; split pages keep [fontSize].
  static ShareImagePagination layout({
    required String text,
    required ShareImageTheme theme,
    required double fontSize,
    required ShareImageAspect aspect,
    required bool showTitleChain,
  }) {
    final source = SharePageText.format(text, theme, fontSize);
    Size boxFor(ShareImageAspect a) => ShareImageLayout.bodySize(a.size!, showTitleChain: showTitleChain);
    bool onePage(SharePageText s, ShareImageAspect a) => TextPaginator(s, boxFor(a)).fits(0, s.text.length);

    ShareImageAspect resolved = aspect;
    if (aspect == ShareImageAspect.auto) {
      resolved = ShareImageAspect.fixed.firstWhere(
        (candidate) => onePage(source, candidate),
        orElse: () => ShareImageAspect.tall,
      );
    }

    final pages = TextPaginator(source, boxFor(resolved)).paginate();
    if (pages.length > 1) {
      return ShareImagePagination(
        aspect: resolved,
        canvasSize: resolved.size!,
        pages: pages,
        source: source,
      );
    }

    // One page: grow the font in 2px steps while it still fits.
    SharePageText best = source;
    for (var size = fontSize + 2; size <= fontSize * maxSinglePageGrowth; size += 2) {
      final bigger = SharePageText.format(text, theme, size);
      if (!onePage(bigger, resolved)) break;
      best = bigger;
    }
    return ShareImagePagination(
      aspect: resolved,
      canvasSize: resolved.size!,
      pages: [TextRange(start: 0, end: best.text.length)],
      source: best,
    );
  }

  bool fits(int start, int end, {double? maxHeight}) {
    final painter = TextPainter(
      text: source.page(TextRange(start: start, end: end)),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      textScaler: TextScaler.noScaling,
    )..layout(maxWidth: box.width);
    final height = painter.height;
    painter.dispose();
    return height <= (maxHeight ?? box.height);
  }

  List<TextRange> paginate() {
    if (_text.trim().isEmpty) return [TextRange(start: 0, end: _text.length)];

    final pages = _paginate(box.height);
    if (pages.length < 2) return pages;

    // Even the pages out: find the shortest box that still needs no more
    // pages, so the text is spread instead of leaving a short last page.
    double low = box.height * .5;
    double high = box.height;
    List<TextRange> best = pages;
    for (var i = 0; i < 7; i++) {
      final mid = (low + high) / 2;
      final trial = _paginate(mid);
      if (trial.length <= pages.length) {
        best = trial;
        high = mid;
      } else {
        low = mid;
      }
    }
    return best;
  }

  List<TextRange> _paginate(double maxHeight) {
    final pages = <TextRange>[];
    int start = _skipSpace(0);
    int first = 0; // index in _ends of the first end after start

    while (start < _text.length) {
      while (first < _ends.length && _ends[first] <= start) {
        first++;
      }

      int best = first;
      if (fits(start, _ends.last, maxHeight: maxHeight)) {
        best = _ends.length - 1;
      } else {
        int low = first;
        int high = _ends.length - 2;
        while (low <= high) {
          final mid = (low + high) >> 1;
          if (fits(start, _ends[mid], maxHeight: maxHeight)) {
            best = mid;
            low = mid + 1;
          } else {
            high = mid - 1;
          }
        }
        best = _preferPunctuation(start, first, best);
      }

      final end = _ends[best];
      pages.add(TextRange(start: start, end: end));
      start = _skipSpace(end);
    }
    return pages;
  }

  int _preferPunctuation(int start, int first, int best) {
    final limit = start + (_ends[best] - start) * (1 - _punctuationReach);
    for (var k = best; k >= first && _ends[k] >= limit; k--) {
      if (_breakChars.contains(_text[_ends[k] - 1])) return k;
    }
    return best;
  }

  int _skipSpace(int index) {
    var i = index;
    while (i < _text.length && _isSpace(_text.codeUnitAt(i))) {
      i++;
    }
    return i;
  }

  static bool _isSpace(int c) => c == 0x20 || c == 0x0A || c == 0x0D || c == 0x09 || c == 0xA0;

  /// Every index where a word ends, plus the end of the text.
  static List<int> _wordEnds(String text) {
    final ends = <int>[];
    for (var i = 1; i < text.length; i++) {
      if (_isSpace(text.codeUnitAt(i)) && !_isSpace(text.codeUnitAt(i - 1))) ends.add(i);
    }
    if (ends.isEmpty || ends.last != text.length) ends.add(text.length);
    return ends;
  }
}
