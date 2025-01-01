// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';

class BookmarkEntity extends Equatable {
  final int id;
  final String itemId;
  final BookmarkType type;
  final bool isBookmarked;
  final bool isRead;
  final String note;
  final DateTime addedDate;
  final DateTime updateDate;

  const BookmarkEntity({
    required this.id,
    required this.itemId,
    required this.type,
    required this.isBookmarked,
    required this.isRead,
    required this.note,
    required this.addedDate,
    required this.updateDate,
  });

  @override
  List<Object> get props {
    return [
      id,
      itemId,
      type,
      isBookmarked,
      isRead,
      note,
      addedDate,
      updateDate,
    ];
  }
}
