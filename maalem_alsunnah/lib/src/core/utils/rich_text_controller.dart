import 'dart:math' as math;

import 'package:flutter/material.dart';

enum TextStyleType { bold, italic, underline, strikethrough }

/// A half-open `[start, end)` span of text carrying one [TextStyleType].
@immutable
class StyleRange {
  final int start;
  final int end;
  final TextStyleType type;

  const StyleRange({required this.start, required this.end, required this.type});

  bool covers(int from, int to) => start <= from && end >= to;

  @override
  bool operator ==(Object other) =>
      other is StyleRange && other.start == start && other.end == end && other.type == type;

  @override
  int get hashCode => Object.hash(start, end, type);

  @override
  String toString() => 'StyleRange($type, $start-$end)';
}

/// A [TextEditingController] that keeps simple inline styles (bold, italic,
/// underline, strikethrough) and serializes them to a tiny HTML subset.
///
/// Edits are located by diffing the old and new text (not by the old
/// selection), so IME composing, autocorrect and programmatic changes keep
/// styles in the right place.
class RichTextController extends TextEditingController {
  RichTextController({String? html}) {
    if (html != null) loadHtml(html);
  }

  List<StyleRange> _ranges = const [];
  List<StyleRange> get ranges => _ranges;

  /// Styles applied to the next typed text when the selection is collapsed.
  final Set<TextStyleType> _pending = {};

  @override
  set value(TextEditingValue newValue) {
    final old = value;
    if (old.text != newValue.text) {
      _ranges = _rangesAfterEdit(old.text, newValue);
    }
    if (old.text != newValue.text || old.selection != newValue.selection) {
      _syncPending(newValue);
    }
    super.value = newValue;
  }

  bool isStyleActive(TextStyleType type) {
    final sel = selection;
    if (!sel.isValid || sel.isCollapsed) return _pending.contains(type);
    return _ranges.any((r) => r.type == type && r.covers(sel.start, sel.end));
  }

  void toggleStyle(TextStyleType type) {
    final sel = selection;
    if (!sel.isValid || sel.isCollapsed) {
      if (!_pending.remove(type)) _pending.add(type);
    } else if (isStyleActive(type)) {
      _ranges = _subtract(_ranges, sel.start, sel.end, {type});
    } else {
      _ranges = _merge([..._ranges, StyleRange(start: sel.start, end: sel.end, type: type)]);
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Editing
  // ---------------------------------------------------------------------------

  List<StyleRange> _rangesAfterEdit(String oldText, TextEditingValue newValue) {
    final newText = newValue.text;
    final delta = newText.length - oldText.length;
    final minLen = math.min(oldText.length, newText.length);

    var prefix = 0;
    while (prefix < minLen && oldText.codeUnitAt(prefix) == newText.codeUnitAt(prefix)) {
      prefix++;
    }
    // With repeated characters the diff is ambiguous ("ab" -> "abb"); the
    // caret tells us where the edit really happened.
    final sel = newValue.selection;
    if (sel.isValid && sel.isCollapsed) {
      prefix = math.min(prefix, math.max(0, sel.baseOffset - math.max(0, delta)));
    }
    var suffix = 0;
    while (suffix < minLen - prefix &&
        oldText.codeUnitAt(oldText.length - 1 - suffix) ==
            newText.codeUnitAt(newText.length - 1 - suffix)) {
      suffix++;
    }

    final removedEnd = oldText.length - suffix; // old [prefix, removedEnd) ...
    final insertedEnd = newText.length - suffix; // ... became new [prefix, insertedEnd)

    int mapStart(int x) => x < prefix ? x : (x >= removedEnd ? x + delta : insertedEnd);
    int mapEnd(int x) => x <= prefix ? x : (x >= removedEnd ? x + delta : prefix);

    var next = <StyleRange>[
      for (final r in _ranges)
        if (mapEnd(r.end) > mapStart(r.start))
          StyleRange(start: mapStart(r.start), end: mapEnd(r.end), type: r.type),
    ];

    if (insertedEnd > prefix) {
      // Inserted text gets exactly the pending styles, nothing inherited.
      next = _subtract(next, prefix, insertedEnd, TextStyleType.values.toSet());
      next.addAll([
        for (final type in _pending) StyleRange(start: prefix, end: insertedEnd, type: type),
      ]);
    }
    return _merge(next);
  }

  /// Pending styles follow the character before the caret, or the styles
  /// shared by the whole selection (so typing over it keeps them).
  void _syncPending(TextEditingValue v) {
    final sel = v.selection;
    if (!sel.isValid) return;
    if (!sel.isCollapsed) {
      _pending
        ..clear()
        ..addAll(_ranges.where((r) => r.covers(sel.start, sel.end)).map((r) => r.type));
      return;
    }
    final offset = sel.baseOffset;
    final charIndex = offset > 0 ? offset - 1 : 0;
    _pending
      ..clear()
      ..addAll(_ranges.where((r) => r.start <= charIndex && r.end > charIndex).map((r) => r.type));
  }

  static List<StyleRange> _subtract(
    List<StyleRange> input,
    int from,
    int to,
    Set<TextStyleType> types,
  ) {
    final out = <StyleRange>[];
    for (final r in input) {
      if (!types.contains(r.type) || r.end <= from || r.start >= to) {
        out.add(r);
        continue;
      }
      if (r.start < from) out.add(StyleRange(start: r.start, end: from, type: r.type));
      if (r.end > to) out.add(StyleRange(start: to, end: r.end, type: r.type));
    }
    return out;
  }

  static List<StyleRange> _merge(List<StyleRange> input) {
    final result = <StyleRange>[];
    for (final type in TextStyleType.values) {
      final typed = input.where((r) => r.type == type && r.end > r.start).toList()
        ..sort((a, b) => a.start.compareTo(b.start));
      StyleRange? current;
      for (final r in typed) {
        if (current != null && r.start <= current.end) {
          current = StyleRange(start: current.start, end: math.max(current.end, r.end), type: type);
        } else {
          if (current != null) result.add(current);
          current = r;
        }
      }
      if (current != null) result.add(current);
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Rendering
  // ---------------------------------------------------------------------------

  /// Splits [text] into segments where the set of active styles is constant.
  Iterable<(int, int, Set<TextStyleType>)> _segments([List<int> extraBoundaries = const []]) sync* {
    final len = text.length;
    final boundaries = <int>{
      0,
      len,
      for (final r in _ranges) ...[r.start.clamp(0, len), r.end.clamp(0, len)],
      for (final b in extraBoundaries) b.clamp(0, len),
    }.toList()
      ..sort();
    for (var i = 0; i < boundaries.length - 1; i++) {
      final s = boundaries[i];
      final e = boundaries[i + 1];
      yield (s, e, {for (final r in _ranges) if (r.covers(s, e)) r.type});
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_ranges.isEmpty || text.isEmpty) {
      return super.buildTextSpan(context: context, style: style, withComposing: withComposing);
    }

    final composing = value.composing;
    final showComposing = withComposing && value.isComposingRangeValid;
    final extra = showComposing ? [composing.start, composing.end] : const <int>[];

    return TextSpan(
      style: style,
      children: [
        for (final (s, e, types) in _segments(extra))
          TextSpan(
            text: text.substring(s, e),
            style: _styleFor(
              types,
              underlineForComposing: showComposing && s >= composing.start && e <= composing.end,
            ),
          ),
      ],
    );
  }

  static TextStyle _styleFor(Set<TextStyleType> types, {bool underlineForComposing = false}) {
    final decorations = [
      if (types.contains(TextStyleType.underline) || underlineForComposing) TextDecoration.underline,
      if (types.contains(TextStyleType.strikethrough)) TextDecoration.lineThrough,
    ];
    return TextStyle(
      fontWeight: types.contains(TextStyleType.bold) ? FontWeight.bold : null,
      fontStyle: types.contains(TextStyleType.italic) ? FontStyle.italic : null,
      decoration: decorations.isEmpty ? null : TextDecoration.combine(decorations),
    );
  }

  // ---------------------------------------------------------------------------
  // HTML (b / i / u / s only; text is escaped)
  // ---------------------------------------------------------------------------

  static const _tags = {
    TextStyleType.bold: 'b',
    TextStyleType.italic: 'i',
    TextStyleType.underline: 'u',
    TextStyleType.strikethrough: 's',
  };

  static const _tagAliases = {
    'b': TextStyleType.bold,
    'strong': TextStyleType.bold,
    'i': TextStyleType.italic,
    'em': TextStyleType.italic,
    'u': TextStyleType.underline,
    's': TextStyleType.strikethrough,
    'strike': TextStyleType.strikethrough,
    'del': TextStyleType.strikethrough,
  };

  static final _tagRegex = RegExp('<(/?)(b|strong|i|em|u|s|strike|del)>', caseSensitive: false);

  String toHtml() {
    final sb = StringBuffer();
    for (final (s, e, types) in _segments()) {
      final ordered = TextStyleType.values.where(types.contains).toList();
      for (final t in ordered) {
        sb.write('<${_tags[t]}>');
      }
      sb.write(_escape(text.substring(s, e)));
      for (final t in ordered.reversed) {
        sb.write('</${_tags[t]}>');
      }
    }
    return sb.toString();
  }

  /// Replaces the content with [html]. Plain text (legacy notes) works too.
  void loadHtml(String html) {
    final plain = StringBuffer();
    final parsed = <StyleRange>[];
    final open = <TextStyleType, int>{};

    var last = 0;
    for (final m in _tagRegex.allMatches(html)) {
      plain.write(_unescape(html.substring(last, m.start)));
      last = m.end;
      final type = _tagAliases[m.group(2)!.toLowerCase()]!;
      if (m.group(1)!.isEmpty) {
        open.putIfAbsent(type, () => plain.length);
      } else if (open.containsKey(type)) {
        parsed.add(StyleRange(start: open.remove(type)!, end: plain.length, type: type));
      }
    }
    plain.write(_unescape(html.substring(last)));
    open.forEach((type, start) => parsed.add(StyleRange(start: start, end: plain.length, type: type)));

    final newText = plain.toString();
    _ranges = _merge(parsed);
    _pending.clear();
    // Bypass the diffing setter: ranges already match the new text.
    super.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
    _syncPending(value);
  }

  static String _escape(String s) =>
      s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

  static String _unescape(String s) => s
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&');
}
