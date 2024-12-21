import 'package:maalem_alsunnah/src/features/bookmarks/domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.id,
    required super.titleId,
    required super.hadithId,
    required super.isBookmarked,
    required super.note,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'] as int,
      titleId: map['titleId'] as int?,
      hadithId: map['hadithId'] as int?,
      isBookmarked: map['isBookmarked'] as bool,
      note: map['note'] as String,
    );
  }
}
