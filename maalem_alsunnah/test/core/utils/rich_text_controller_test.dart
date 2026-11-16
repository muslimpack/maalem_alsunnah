import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/core/utils/rich_text_controller.dart';

/// Simulates the platform typing [inserted] at [offset] (replacing
/// [replaceLength] chars), leaving the caret after the inserted text.
void type(RichTextController c, String inserted, {int? offset, int replaceLength = 0}) {
  final at = offset ?? c.selection.baseOffset;
  final text = c.text.replaceRange(at, at + replaceLength, inserted);
  c.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: at + inserted.length),
  );
}

void moveCaret(RichTextController c, int offset) {
  c.selection = TextSelection.collapsed(offset: offset);
}

void main() {
  group('HTML', () {
    test('round-trips styles', () {
      const html = 'a<b>bold</b> <i>it<u>al</u></i> <s>x</s>';
      final c = RichTextController(html: html);
      expect(c.text, 'abold ital x');
      expect(c.toHtml(), 'a<b>bold</b> <i>it</i><i><u>al</u></i> <s>x</s>');
      expect(RichTextController(html: c.toHtml()).toHtml(), c.toHtml());
    });

    test('escapes markup-like text so it survives a round-trip', () {
      final c = RichTextController()..text = 'x<b>y & a < b';
      final html = c.toHtml();
      expect(html, 'x&lt;b&gt;y &amp; a &lt; b');
      final reloaded = RichTextController(html: html);
      expect(reloaded.text, 'x<b>y & a < b');
      expect(reloaded.ranges, isEmpty);
    });

    test('legacy plain-text note loads as-is', () {
      final c = RichTextController(html: 'just a note\nline 2');
      expect(c.text, 'just a note\nline 2');
      expect(c.ranges, isEmpty);
    });

    test('unclosed tag runs to the end; aliases are understood', () {
      final c = RichTextController(html: '<strong>a</strong><em>b');
      expect(c.ranges, containsAll(const [
        StyleRange(start: 0, end: 1, type: TextStyleType.bold),
        StyleRange(start: 1, end: 2, type: TextStyleType.italic),
      ]));
    });
  });

  group('typing', () {
    test('typing at the end of a bold range continues bold', () {
      final c = RichTextController(html: '<b>ab</b>');
      type(c, 'c');
      expect(c.toHtml(), '<b>abc</b>');
    });

    test('toggling bold off with a collapsed caret stops bold', () {
      final c = RichTextController(html: '<b>ab</b>');
      c.toggleStyle(TextStyleType.bold);
      type(c, 'c');
      expect(c.toHtml(), '<b>ab</b>c');
    });

    test('moving the caret into plain text clears pending bold', () {
      final c = RichTextController(html: 'xx<b>ab</b>');
      moveCaret(c, 1);
      expect(c.isStyleActive(TextStyleType.bold), isFalse);
      type(c, 'y');
      expect(c.toHtml(), 'xyx<b>ab</b>');
    });

    test('typing before a range shifts it', () {
      final c = RichTextController(html: 'x<b>ab</b>');
      moveCaret(c, 0);
      type(c, 'zz');
      expect(c.toHtml(), 'zzx<b>ab</b>');
    });

    test('repeated characters: insert is placed at the caret, not the diff end', () {
      // "ab" with a bold, caret at 1, plain pending: typing "b" gives a·b·b
      // where only the first char is bold.
      final c = RichTextController(html: '<b>a</b>b');
      moveCaret(c, 1);
      c.toggleStyle(TextStyleType.bold); // turn bold off
      type(c, 'b');
      expect(c.toHtml(), '<b>a</b>bb');

      final d = RichTextController(html: '<b>a</b>b');
      moveCaret(d, 1); // bold pending (char before caret is bold)
      type(d, 'b');
      expect(d.toHtml(), '<b>ab</b>b');
    });

    test('autocorrect-style word replacement keeps the style', () {
      final c = RichTextController(html: 'say <b>helo</b> now');
      moveCaret(c, 8);
      type(c, 'hello', offset: 4, replaceLength: 4);
      expect(c.text, 'say hello now');
      expect(c.toHtml(), 'say <b>hello</b> now');
    });

    test('deleting across a boundary trims the range', () {
      final c = RichTextController(html: 'ab<b>cd</b>ef');
      c.value = const TextEditingValue(
        text: 'abef',
        selection: TextSelection.collapsed(offset: 2),
      );
      expect(c.ranges, isEmpty);

      final d = RichTextController(html: 'a<b>bcd</b>e');
      d.value = const TextEditingValue(
        text: 'ade',
        selection: TextSelection.collapsed(offset: 1),
      );
      expect(d.toHtml(), 'a<b>d</b>e');
    });

    test('clear() drops all ranges', () {
      final c = RichTextController(html: '<b>ab</b>')..clear();
      expect(c.ranges, isEmpty);
      expect(c.toHtml(), '');
    });
  });

  group('toggleStyle on a selection', () {
    test('applies and removes a style', () {
      final c = RichTextController(html: 'hello world');
      c.selection = const TextSelection(baseOffset: 0, extentOffset: 5);
      c.toggleStyle(TextStyleType.bold);
      expect(c.toHtml(), '<b>hello</b> world');
      expect(c.isStyleActive(TextStyleType.bold), isTrue);

      c.selection = const TextSelection(baseOffset: 1, extentOffset: 3);
      c.toggleStyle(TextStyleType.bold);
      expect(c.toHtml(), '<b>h</b>el<b>lo</b> world');
    });

    test('typing over a bold selection stays bold', () {
      final c = RichTextController(html: 'a<b>bcd</b>e');
      c.selection = const TextSelection(baseOffset: 1, extentOffset: 4);
      c.value = const TextEditingValue(
        text: 'axe',
        selection: TextSelection.collapsed(offset: 2),
      );
      expect(c.toHtml(), 'a<b>x</b>e');
    });
  });
}
