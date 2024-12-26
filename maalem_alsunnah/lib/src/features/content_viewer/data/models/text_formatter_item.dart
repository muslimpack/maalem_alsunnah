// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/format_type_enum.dart';

class TextFormatterItem {
  final FormatTypeEnum formatType;
  final RegExp regExp;
  final TextStyle textStyle;
  final bool Function(String text) predicate;

  TextFormatterItem({
    required this.formatType,
    required this.regExp,
    required this.textStyle,
    bool Function(String text)? predicate,
  }) : predicate = predicate ?? ((text) => regExp.hasMatch(text));
}
