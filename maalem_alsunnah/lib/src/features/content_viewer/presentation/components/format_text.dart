import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/format_type_enum.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_item.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';

class FormattedText extends StatelessWidget {
  final String text;
  final TextFormatterSettings settings;
  final bool isSelectable;
  final TextRange? textRange;
  final String textSeparator;
  final Widget? textLeadingWidget;

  const FormattedText({
    super.key,
    required this.text,
    required this.settings,
    this.isSelectable = true,
    this.textRange,
    this.textSeparator = "...",
    this.textLeadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final text = textSpan(style: DefaultTextStyle.of(context).style);

    return isSelectable ? SelectableText.rich(text) : RichText(text: text);
  }

  TextSpan textSpan({TextStyle? style}) {
    final List<InlineSpan> textSpansChildren =
        List<InlineSpan>.from(_applyTextRange(_getTextSpans(text, settings)));
    if (textLeadingWidget != null) {
      textSpansChildren.insert(
        0,
        WidgetSpan(
          child: textLeadingWidget!,
          alignment: PlaceholderAlignment.middle,
        ),
      );
    }
    return TextSpan(
      style: style,
      children: textSpansChildren,
    );
  }

  List<TextSpan> _getTextSpans(
    String text,
    TextFormatterSettings settings,
  ) {
    final List<TextSpan> textSpans = [];

    final List<TextFormatterItem> items = [
      TextFormatterItem(
        formatType: FormatTypeEnum.hadith,
        regExp: RegExp(r'\«[\s\S]*?»'),
        textStyle: settings.hadithTextStyle,
        predicate: (text) => text.startsWith('«') || text.endsWith('»'),
      ),
      TextFormatterItem(
        formatType: FormatTypeEnum.quran,
        regExp: RegExp(r'\﴿(.*?)﴾'),
        textStyle: settings.quranTextStyle,
      ),
      TextFormatterItem(
        formatType: FormatTypeEnum.squareBrackets,
        regExp: RegExp(r'\[(.*?)\]'),
        textStyle: settings.squareBracketsStyle,
      ),
      TextFormatterItem(
        formatType: FormatTypeEnum.roundBrackets,
        regExp: RegExp(r'\([\s\S]*?\)'),
        textStyle: settings.roundBracketsStyle,
      ),
      TextFormatterItem(
        formatType: FormatTypeEnum.number,
        regExp: RegExp(r'(\d+)'),
        textStyle: settings.startingNumberStyle,
      ),
    ];

    final RegExp exp = RegExp(
      items.map((item) => item.regExp.pattern).join("|"),
    );

    final Iterable<RegExpMatch> matches = exp.allMatches(text);

    int start = 0;

    for (final RegExpMatch match in matches) {
      if (match.start > start) {
        textSpans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: settings.deafaultStyle,
          ),
        );
      }

      final String matchedText = match.group(0) ?? "";

      for (var item in items) {
        if (item.predicate.call(matchedText)) {
          if (item.formatType == FormatTypeEnum.roundBrackets) {
            if (matchedText.length > 3) {
              final lastWord =
                  textSpans.isNotEmpty ? textSpans.last.text ?? "" : "";
              if (lastWord.contains("قال تعالى") ||
                  lastWord.contains("عزوجل")) {
                textSpans.add(
                  TextSpan(
                    text: matchedText,
                    style: settings.quranTextStyle,
                  ),
                );
                break;
              } else {
                textSpans.add(
                  TextSpan(
                    text: matchedText,
                    style: settings.hadithTextStyle,
                  ),
                );
                break;
              }
            }
          }
          textSpans.add(
            TextSpan(
              text: matchedText,
              style: item.textStyle,
            ),
          );
          break;
        }
      }

      start = match.end;
    }

    if (start < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(start),
          style: settings.deafaultStyle,
        ),
      );
    }

    return textSpans;
  }

  List<InlineSpan> _applyTextRange(List<TextSpan> textSpans) {
    if (textRange == null) return textSpans;

    final int rangeStart = textRange!.start;
    final int rangeEnd = textRange!.end;

    final List<TextSpan> filteredSpans = [];
    int currentLength = 0;

    for (final span in textSpans) {
      final spanText = span.text ?? "";
      final spanLength = spanText.length;

      if (currentLength + spanLength < rangeStart) {
        currentLength += spanLength;
        continue;
      }

      final int spanStart = max(0, rangeStart - currentLength);
      final int spanEnd = min(spanLength, rangeEnd - currentLength);

      if (spanStart < spanEnd) {
        filteredSpans.add(
          TextSpan(
            text: spanText.substring(spanStart, spanEnd),
            style: span.style,
          ),
        );
      }

      currentLength += spanLength;

      if (currentLength >= rangeEnd) break;
    }

    if (rangeEnd < text.length) {
      filteredSpans.add(
        TextSpan(text: textSeparator),
      );
    }

    return filteredSpans;
  }
}
