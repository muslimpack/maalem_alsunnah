import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';

class FormattedText extends StatelessWidget {
  final String text;
  final TextFormatterSettings settings;

  const FormattedText({
    super.key,
    required this.text,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(_buildTextSpan());
  }

  TextSpan _buildTextSpan() {
    final RegExp regex = RegExp(r'(«(.*?)»)|(﴿(.*?)﴾)|(\[(.*?)\])|(\((.*?)\))');
    final matches = regex.allMatches(text);

    List<InlineSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      // Add any plain text before the current match
      if (currentIndex < match.start) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: settings.deafaultStyle,
        ));
      }

      // Determine which formatting group matched
      if (match.group(1) != null) {
        // Bold text
        spans.add(TextSpan(
          text: "«${match.group(2)}»",
          style: settings.hadithTextStyle,
        ));
      } else if (match.group(3) != null) {
        // Different font family text
        spans.add(TextSpan(
          text: "﴿${match.group(4)}﴾",
          style: settings.quranTextStyle,
        ));
      } else if (match.group(5) != null) {
        // Different color text (square brackets)
        spans.add(TextSpan(
          text: "[${match.group(6)}]",
          style: settings.squareBracketsStyle,
        ));
      } else if (match.group(7) != null) {
        // Different color text (round brackets)
        spans.add(TextSpan(
          text: "(${match.group(8)})",
          style: settings.roundBracketsStyle,
        ));
      }

      // Update the current index
      currentIndex = match.end;
    }

    // Add any remaining plain text after the last match
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
      ));
    }

    return TextSpan(children: spans);
  }
}
