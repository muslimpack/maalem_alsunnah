// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:maalem_alsunnah/src/core/shared/text_highlighter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResponsiveText extends StatefulWidget {
  final String text;
  final String? searchedText;
  final TextStyle? style;
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.searchedText,
  });

  @override
  State<ResponsiveText> createState() => _ResponsiveTextState();
}

class _ResponsiveTextState extends State<ResponsiveText> {
  late bool expanded;
  bool isLong = true;
  final int length = 280;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    isLong = widget.text.length > length;
    expanded = !isLong;
  }

  @override
  void didUpdateWidget(covariant ResponsiveText oldWidget) {
    if (oldWidget.searchedText != widget.searchedText ||
        oldWidget.text != widget.text) {
      setState(() {
        init();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    /// bodyText
    final bodyText = expanded
        ? widget.text
        : widget.text.substring(0, min(widget.text.length, length));

    final bodyTextSpan = HighlightText(
      text: bodyText,
      textToHighlight: widget.searchedText ?? "",
      highlightStyle: widget.style?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      style: widget.style,
    ).textSpan();

    /// show more
    final bool showMoreText = !expanded && widget.text.length > length;

    final moreTextSpan = TextSpan(
      text:
          " ...المزيد (${widget.text.split(" ").length - bodyText.split(" ").length})",
      style: const TextStyle(color: Colors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          setState(() {
            expanded = true;
          });
        },
    );

    ///
    final textWidget = Text.rich(
      TextSpan(
        children: [
          bodyTextSpan,
          if (showMoreText) moreTextSpan,
        ],
      ),
    );

    if (isLong) {
      return GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },
        child: textWidget,
      );
    }

    return textWidget;
  }
}
