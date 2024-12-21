import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

enum SearchFor {
  title,
  content,
  hadith;

  static SearchFor fromString(String map) {
    return SearchFor.values.where((e) => e.toString() == map).firstOrNull ??
        SearchFor.title;
  }
}

extension SearchForExtension on SearchFor {
  String localeName(BuildContext context) {
    switch (this) {
      case SearchFor.title:
        return S.of(context).searchForTitle;
      case SearchFor.content:
        return S.of(context).searchForContent;
      case SearchFor.hadith:
        return S.of(context).searchForHadith;
    }
  }
}
