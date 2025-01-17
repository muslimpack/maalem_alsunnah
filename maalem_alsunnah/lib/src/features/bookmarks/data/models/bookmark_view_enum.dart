import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

enum BookmarkViewEnum {
  all,
  titles,
  hadith;

  static BookmarkViewEnum fromString(String map) {
    return BookmarkViewEnum.values.where((e) => e.name == map).firstOrNull ??
        BookmarkViewEnum.all;
  }
}

extension BookmarkViewEnumExtension on BookmarkViewEnum {
  String localeName(BuildContext context) {
    switch (this) {
      case BookmarkViewEnum.titles:
        return S.of(context).titles;
      case BookmarkViewEnum.hadith:
        return S.of(context).hadith;
      case BookmarkViewEnum.all:
        return S.of(context).all;
    }
  }
}
