// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class TextFormatterItem {
  final String name;
  final RegExp regExp;
  final TextStyle textStyle;
  final bool Function(String text) predicate;

  TextFormatterItem({
    required this.name,
    required this.regExp,
    required this.textStyle,
    bool Function(String text)? predicate,
  }) : predicate = predicate ?? ((text) => regExp.hasMatch(text));
}
