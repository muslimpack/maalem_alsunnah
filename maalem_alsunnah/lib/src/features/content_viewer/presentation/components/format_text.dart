// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/format_type_enum.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_item.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';

class FormattedText extends StatelessWidget {
  final String text;
  final TextFormatterSettings settings;
  final bool isSelectable;
  final TextRange? textRange;
  final String textSeparator;
  const FormattedText({
    super.key,
    required this.text,
    required this.settings,
    this.isSelectable = true,
    this.textRange,
    this.textSeparator = "...",
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

  TextSpan textSpan() {
    final textSpansChildren = _getTextSpans(text, settings);
    return TextSpan(
      children: textSpansChildren,
    );
  }

  List<TextSpan> _getTextSpans(
    String text,
    TextFormatterSettings settings,
  ) {
    final List<TextSpan> spans = [];

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

    appPrint(exp);

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
      appPrint(matchedText);
      for (var item in items) {
        if (item.predicate.call(matchedText)) {
          if (item.formatType == FormatTypeEnum.roundBrackets) {
            if (matchedText.length > 3) {
              final lastWord = spans.lastOrNull?.text ?? "";
              if (lastWord.contains("قال تعالى") ||
                  lastWord.contains("عزوجل")) {
                spans.add(
                  TextSpan(
                    text: matchedText,
                    style: settings.quranTextStyle,
                  ),
                );
                break;
              } else {
                spans.add(
                  TextSpan(
                    text: matchedText,
                    style: settings.hadithTextStyle,
                  ),
                );
                break;
              }
            }
          }
          spans.add(
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
