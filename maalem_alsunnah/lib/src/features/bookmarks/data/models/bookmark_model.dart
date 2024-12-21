// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/src/features/bookmarks/domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.id,
    required super.titleId,
    required super.hadithId,
    required super.isBookmarked,
    required super.note,
    required super.addedDate,
    required super.updateDate,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'] as int,
      titleId: map['titleId'] as int?,
      hadithId: map['hadithId'] as int?,
      isBookmarked: map['isBookmarked'] as bool,
      note: map['note'] as String,
      addedDate: DateTime.parse(map['addedDate'] as String),
      updateDate: DateTime.parse(map['updateDate'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'titleId': titleId,
      'hadithId': hadithId,
      'isBookmarked': isBookmarked,
      'note': note,
      'addedDate': addedDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
    };
  }
}
