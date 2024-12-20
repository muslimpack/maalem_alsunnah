// https://stackoverflow.com/a/59280491/11318150

import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final String textToHighlight;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final bool ignoreCase;
  final bool ignoreArabicTashkel;

  const HighlightText({
    super.key,
    required this.text,
    required this.textToHighlight,
    this.style,
    this.highlightStyle,
    this.ignoreCase = true,
    this.ignoreArabicTashkel = true,
  });

  HighlightText.byColor({
    super.key,
    required this.text,
    required this.textToHighlight,
    this.style,
    required Color highlightColor,
    this.ignoreCase = true,
    this.ignoreArabicTashkel = true,
  }) : highlightStyle = style?.copyWith(color: highlightColor);

  List<TextSpan> _highlightOccurrences({
    required String source,
    required String query,
  }) {
    if (query.isEmpty) {
      return [TextSpan(text: source)];
    }

    // Split the query into words and remove any empty strings.
    final queryWords =
        query.split(' ').where((word) => word.isNotEmpty).toList();
    if (queryWords.isEmpty) {
      return [TextSpan(text: source)];
    }

    // Build a regex that matches any word from the query.
    final pattern =
        RegExp(queryWords.map((word) => RegExp.escape(word)).join('|'));

    final matches = pattern.allMatches(source);

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];

    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      // Add text before the match
      if (match.start != lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(lastMatchEnd, match.start),
          ),
        );
      }

      // Add the matched word with the highlight style
      children.add(
        TextSpan(
          text: source.substring(match.start, match.end),
          style: highlightStyle,
        ),
      );

      // Add text after the last match if this is the final match
      if (i == matches.length - 1 && match.end != source.length) {
        children.add(
          TextSpan(
            text: source.substring(match.end, source.length),
          ),
        );
      }

      lastMatchEnd = match.end;
    }

    // If no matches, return the source text as-is
    if (children.isEmpty) {
      return [TextSpan(text: source)];
    }

    return children;
  }

  List<TextSpan> spans() {
    return _highlightOccurrences(
      source: text,
      query: textToHighlight,
    );
  }

  TextSpan textSpan() {
    return TextSpan(
      children: _highlightOccurrences(
        source: text,
        query: textToHighlight,
      ),
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: _highlightOccurrences(
          source: text,
          query: textToHighlight,
        ),
        style: style,
      ),
    );
  }
}
