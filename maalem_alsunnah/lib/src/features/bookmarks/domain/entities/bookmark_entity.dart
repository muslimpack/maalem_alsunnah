// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class BookmarkEntity extends Equatable {
  final int id;
  final int? titleId;
  final int? hadithId;
  final bool isBookmarked;
  final bool isRead;
  final String? note;
  final DateTime addedDate;
  final DateTime updateDate;

  const BookmarkEntity({
    required this.id,
    this.titleId,
    this.hadithId,
    required this.isBookmarked,
    required this.isRead,
    required this.note,
    required this.addedDate,
    required this.updateDate,
  });

  @override
  List<Object?> get props {
    return [
      id,
      titleId,
      hadithId,
      isBookmarked,
      isRead,
      note,
      addedDate,
      updateDate,
    ];
  }
}
