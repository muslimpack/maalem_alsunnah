import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

enum SearchForType {
  title,
  content,
  hadith;

  static SearchForType fromString(String map) {
    return SearchForType.values.where((e) => e.toString() == map).firstOrNull ??
        SearchForType.title;
  }
}

extension SearchTypeExtension on SearchForType {
  String localeName(BuildContext context) {
    switch (this) {
      case SearchForType.title:
        return S.of(context).searchForTitle;
      case SearchForType.content:
        return S.of(context).searchForContent;
      case SearchForType.hadith:
        return S.of(context).searchForHadith;
    }
  }
}
