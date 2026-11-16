import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_aspect.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_theme.dart';
import 'package:maalem_alsunnah/src/features/share/domain/share_image_layout.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final theme = ShareImageTheme.resolve(ShareImagePalette.maroon, Brightness.dark);
  const fontSize = 46.0;

  SharePageText source(String text) => SharePageText.format(text, theme, fontSize);

  String words(int count, {String word = "كلمة"}) => List.filled(count, word).join(" ");

  void expectCovers(String text, List<TextRange> pages) {
    expect(pages.first.start, 0);
    expect(pages.last.end, text.length);
    for (var i = 1; i < pages.length; i++) {
      final gap = text.substring(pages[i - 1].end, pages[i].start);
      expect(gap.trim(), isEmpty, reason: "no text is dropped between pages $i-1 and $i");
      expect(pages[i].start, greaterThan(pages[i - 1].end - 1));
    }
  }

  test('a short text is one page and Auto picks the square', () {
    final result = TextPaginator.layout(
      source: source(words(8)),
      aspect: ShareImageAspect.auto,
      showTitleChain: true,
    );
    expect(result.aspect, ShareImageAspect.square);
    expect(result.canvasSize, const Size(1080, 1080));
    expect(result.pages, hasLength(1));
  });

  test('a long text uses 2:3 pages that cover it and each fit', () {
    final text = words(900);
    final page = source(text);
    final result = TextPaginator.layout(
      source: page,
      aspect: ShareImageAspect.auto,
      showTitleChain: true,
    );
    expect(result.aspect, ShareImageAspect.tall);
    expect(result.pages.length, greaterThan(1));
    expectCovers(page.text, result.pages);

    final box = ShareImageLayout.bodySize(result.canvasSize, showTitleChain: true);
    final paginator = TextPaginator(page, box);
    for (final range in result.pages) {
      expect(paginator.fits(range.start, range.end), isTrue);
    }
  });

  test('no size is taller than 2:3', () {
    for (final aspect in ShareImageAspect.fixed) {
      final size = aspect.size!;
      expect(size.height / size.width, lessThanOrEqualTo(1.5));
    }
  });

  test('pages are evened out instead of leaving a short last page', () {
    final text = words(900);
    final page = source(text);
    final pages = TextPaginator.layout(
      source: page,
      aspect: ShareImageAspect.tall,
      showTitleChain: true,
    ).pages;
    final lengths = pages.map((r) => r.end - r.start).toList();
    final longest = lengths.reduce((a, b) => a > b ? a : b);
    expect(lengths.last, greaterThan(longest * .6));
  });

  test('a page prefers to end after punctuation', () {
    // Sentences of 7 words, each ending with a full stop.
    final sentence = "${words(6)} نهاية.";
    final text = List.filled(120, sentence).join(" ");
    final page = source(text);
    final pages = TextPaginator.layout(
      source: page,
      aspect: ShareImageAspect.tall,
      showTitleChain: true,
    ).pages;
    expect(pages.length, greaterThan(1));
    for (final range in pages) {
      expect(page.text[range.end - 1], ".");
    }
  });

  test('continuation marks are added between pages only', () {
    final page = source(words(20));
    final middle = page.page(const TextRange(start: 5, end: 30)).toPlainText();
    expect(middle.startsWith(SharePageText.ellipsis), isTrue);
    expect(middle.endsWith(SharePageText.ellipsis), isTrue);

    final whole = page.page(TextRange(start: 0, end: page.text.length)).toPlainText();
    expect(whole, page.text);
  });

  test('formatting survives a page break inside a Quran quote', () {
    const text = "قال تعالى: ﴿إن الله مع الصابرين﴾ والحمد لله";
    final page = source(text);
    final start = page.text.indexOf("مع");
    final span = page.page(TextRange(start: start, end: page.text.length));
    final quran = span.children!.whereType<TextSpan>().firstWhere((s) => s.text!.contains("الصابرين"));
    expect(quran.style?.color, theme.formatterColors.quranTextColor);
  });
}
