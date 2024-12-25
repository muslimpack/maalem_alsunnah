import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';

class FormattedText extends StatelessWidget {
  final String text;
  final TextFormatterSettings settings;
  final bool isSelectable;
  const FormattedText({
    super.key,
    required this.text,
    required this.settings,
    this.isSelectable = true,
  });

  @override
  Widget build(BuildContext context) {
    final textSpansChildren = _getTextSpans(text, settings);
    final textSpan = TextSpan(
      style: DefaultTextStyle.of(context).style,
      children: textSpansChildren,
    );

    return isSelectable
        ? SelectableText.rich(textSpan)
        : RichText(text: textSpan);
  }

  List<TextSpan> _getTextSpans(
    String text,
    TextFormatterSettings settings,
  ) {
    final List<TextSpan> spans = [];
    final RegExp exp =
        RegExp(r'\((.*?)\)|\«[\s\S]*?»|\﴿(.*?)﴾|\[(.*?)\]|(\d+)');

    final Iterable<RegExpMatch> matches = exp.allMatches(text);

    int start = 0;

    for (final RegExpMatch match in matches) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: settings.deafaultStyle,
          ),
        );
      }

      final String matchedText = match.group(0) ?? "";
      appPrint(matchedText.toString());

      if (matchedText.startsWith('«') || matchedText.endsWith('»')) {
        // Text between double quotes
        spans.add(
          TextSpan(
            text: matchedText,
            style: settings.hadithTextStyle,
          ),
        );
      } else if (matchedText.startsWith("[") && matchedText.endsWith("]")) {
        // Text between double square brackets
        spans.add(
          TextSpan(
            text: matchedText,
            style: settings.squareBracketsStyle,
          ),
        );
      } else if (matchedText.startsWith("(") && matchedText.endsWith(")")) {
        // Text between double square brackets
        spans.add(
          TextSpan(
            text: matchedText,
            style: settings.roundBracketsStyle,
          ),
        );
      } else if (matchedText.startsWith("﴿") && matchedText.endsWith("﴾")) {
        // Text between double angle brackets
        spans.add(
          TextSpan(
            text: matchedText,
            style: settings.quranTextStyle,
          ),
        );
      } else if (num.tryParse(matchedText) != null) {
        // Starting number
        spans.add(
          TextSpan(
            text: matchedText,
            style: settings.startingNumberStyle,
          ),
        );
      } else {
        // Normal text
        spans.add(
          TextSpan(
            text: matchedText,
            style: settings.deafaultStyle,
          ),
        );
      }

      start = match.end;
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: settings.deafaultStyle,
        ),
      );
    }

    return spans;
  }
}
