import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:flutter/material.dart';

enum SearchType {
  typical,
  allWords,
  anyWords;

  static SearchType fromString(String map) {
    return SearchType.values.where((e) => e.toString() == map).firstOrNull ??
        SearchType.typical;
  }
}

extension SearchTypeExtension on SearchType {
  String localeName(BuildContext context) {
    switch (this) {
      case SearchType.typical:
        return S.of(context).SearchTypeTypical;
      case SearchType.allWords:
        return S.of(context).searchTypeAllWords;
      case SearchType.anyWords:
        return S.of(context).searchTypeAnyWords;
    }
  }
}
