enum BookmarkType {
  title,
  hadith;

  static BookmarkType fromString(String map) {
    return BookmarkType.values.where((e) => e.name == map).firstOrNull ??
        BookmarkType.title;
  }
}
