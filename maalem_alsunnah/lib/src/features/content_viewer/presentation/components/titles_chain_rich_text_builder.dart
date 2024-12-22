// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class TitlesChainRichTextBuilder extends StatelessWidget {
  final List<TitleModel> titlesChains;
  final Function(int index, TitleModel title)? onPressed;
  final TextStyle? textStyle;

  const TitlesChainRichTextBuilder({
    super.key,
    required this.titlesChains,
    this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultTextStyle = TextStyle(
      fontSize: 15,
      color: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.bold,
    );
    final List<InlineSpan> spans = titlesChains.map((title) {
      return TextSpan(
        text: title.name,
        style: textStyle ?? defaultTextStyle,
        recognizer: onPressed == null
            ? null
            : (TapGestureRecognizer()
              ..onTap =
                  () => onPressed?.call(titlesChains.indexOf(title), title)),
      );
    }).toList();

    // The item to insert between the spans
    final InlineSpan separator = WidgetSpan(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text("/", style: textStyle ?? defaultTextStyle),
    ));

// Interleave the separator between the spans
    final List<InlineSpan> interleavedSpans = spans.expand((span) sync* {
      yield span;
      if (span != spans.last) {
        yield separator;
      }
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text.rich(
        TextSpan(children: interleavedSpans),
        style: const TextStyle(fontSize: 15, height: 2),
      ),
    );
  }
}
