import 'package:hive/hive.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_view_enum.dart';

class BookmarkRepo {
  final Box box;

  BookmarkRepo(this.box);

  /// Search Type
  static const String bookmarkViewTypeKey = "bookmarkView";
  BookmarkViewEnum get bookmarkView {
    final data = box.get(bookmarkViewTypeKey) as String?;
    if (data == null) return BookmarkViewEnum.titles;
    return BookmarkViewEnum.fromString(data);
  }

  Future setBookmarkView(BookmarkViewEnum bookmarkView) async {
    return box.put(bookmarkViewTypeKey, bookmarkView.name);
  }
}
