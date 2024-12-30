// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

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
  final Widget? textLeadingWidget;
  FormattedText({
    super.key,
    required this.text,
    required this.settings,
    this.isSelectable = true,
    this.textRange,
    this.textSeparator = "...",
    this.textLeadingWidget,
  }) : textSpans = [];

  @override
  Widget build(BuildContext context) {
    final text = textSpan(style: DefaultTextStyle.of(context).style);

    return isSelectable ? SelectableText.rich(text) : RichText(text: text);
  }

  TextSpan textSpan({TextStyle? style}) {
    final List<InlineSpan> textSpansChildren =
        List<InlineSpan>.from(_getTextSpans(text, settings));
    if (textLeadingWidget != null) {
      textSpansChildren.insert(
        0,
        WidgetSpan(
          child: textLeadingWidget!,
          alignment: PlaceholderAlignment.middle,
        ),
      );
    }
    final textSpan = TextSpan(
      style: style,
      children: textSpansChildren,
    );

    return textSpan;
  }

  final List<TextSpan> textSpans;

  String get _textSpansString => textSpans.map((e) => e.text).join("");
  int get _textSpansLength => _textSpansString.length;
  int skipepdChar = 0;
  void addTextSpan(TextSpan textSpan) {
    final textSpansLength = _textSpansString.length;
    final textRangeWidth = ((textRange?.end) ?? 0) - ((textRange?.start) ?? 0);
    final bool applySplit = textRange != null && text.length > textRangeWidth;

    if (applySplit) {
      if (textSpansLength > textRangeWidth) {
        return;
      } else {
        if (textRange!.start != 0 && textSpans.isEmpty) {
          textSpans.add(TextSpan(text: textSeparator, style: textSpan.style));
        }

        if (skipepdChar + textSpan.text!.length >= textRange!.start) {
          final remaning = textRangeWidth - textSpansLength + 1;
          final lastSub = min(textSpan.text!.length, remaning);
          final firstSub = textSpans.length == 1 && skipepdChar > 0
              ? max(
                  0,
                  min(
                    textSpan.text!.length,
                    textRange!.start - skipepdChar,
                  ),
                )
              : 0;
          appPrint(firstSub);
          textSpans.add(TextSpan(
              text: textSpan.text!.substring(firstSub, lastSub),
              style: textSpan.style));

          skipepdChar += firstSub;

          if (textRange!.end != text.length &&
              _textSpansLength >= textRangeWidth) {
            textSpans.add(TextSpan(text: textSeparator, style: textSpan.style));
          }
        } else {
          skipepdChar += textSpan.text!.length;
        }
      }
    } else {
      textSpans.add(textSpan);
    }
  }

  List<TextSpan> _getTextSpans(
    String text,
    TextFormatterSettings settings,
  ) {
    textSpans.clear();

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
        addTextSpan(
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
              final lastWord = textSpans.lastOrNull?.text ?? "";
              if (lastWord.contains("قال تعالى") ||
                  lastWord.contains("عزوجل")) {
                addTextSpan(
                  TextSpan(
                    text: matchedText,
                    style: settings.quranTextStyle,
                  ),
                );
                break;
              } else {
                addTextSpan(
                  TextSpan(
                    text: matchedText,
                    style: settings.hadithTextStyle,
                  ),
                );
                break;
              }
            }
          }
          addTextSpan(
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
      addTextSpan(
        TextSpan(
          text: text.substring(start),
          style: settings.deafaultStyle,
        ),
      );
    }

    return textSpans;
  }
}
