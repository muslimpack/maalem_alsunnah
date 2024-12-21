// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class BookmarkEntity extends Equatable {
  final int id;
  final int? titleId;
  final int? hadithId;
  final bool isBookmarked;
  final String? note;

  const BookmarkEntity({
    required this.id,
    this.titleId,
    this.hadithId,
    required this.isBookmarked,
    required this.note,
  });

  @override
  List<Object?> get props => [id, titleId, hadithId, isBookmarked, note];
}
