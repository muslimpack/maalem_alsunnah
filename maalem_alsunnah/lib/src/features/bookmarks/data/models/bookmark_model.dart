// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    super.id = -1,
    required super.itemId,
    required super.type,
    required super.isBookmarked,
    required super.isRead,
    required super.note,
    required super.addedDate,
    required super.updateDate,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'] as int,
      itemId: map['itemId'] as int,
      type: BookmarkType.fromString(map['type'] as String),
      isBookmarked: (map['isBookmarked'] as int) == 1,
      isRead: (map['isRead'] as int) == 1,
      note: map['note'] as String,
      addedDate: DateTime.parse(map['addedDate'] as String),
      updateDate: DateTime.parse(map['updateDate'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'type': type.name,
      'isBookmarked': isBookmarked ? 1 : 0,
      'isRead': isRead ? 1 : 0,
      'note': note,
      'addedDate': addedDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
    };
  }

  BookmarkModel copyWith({
    int? id,
    int? itemId,
    BookmarkType? type,
    bool? isBookmarked,
    bool? isRead,
    String? note,
    DateTime? addedDate,
    DateTime? updateDate,
  }) {
    return BookmarkModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
      note: note ?? this.note,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }
}
