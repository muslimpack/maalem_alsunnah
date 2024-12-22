// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'bookmarks_bloc.dart';

sealed class BookmarksEvent extends Equatable {
  const BookmarksEvent();

  @override
  List<Object?> get props => [];
}

class BookmarksStartEvent extends BookmarksEvent {
  const BookmarksStartEvent();

  @override
  List<Object?> get props => [];
}

class BookmarksBookmarkItemEvent extends BookmarksEvent {
  final int? titleId;
  final int? hadithId;
  final bool isBookmarked;
  const BookmarksBookmarkItemEvent({
    this.titleId,
    this.hadithId,
    required this.isBookmarked,
  });

  @override
  List<Object?> get props => [titleId, hadithId, isBookmarked];
}

class BookmarksMarkItemAsReadEvent extends BookmarksEvent {
  final int? titleId;
  final int? hadithId;
  final bool isRead;
  const BookmarksMarkItemAsReadEvent({
    this.titleId,
    this.hadithId,
    required this.isRead,
  });

  @override
  List<Object?> get props => [titleId, hadithId, isRead];
}

class BookmarksNoteEvent extends BookmarksEvent {
  final int? titleId;
  final int? hadithId;
  final String note;
  const BookmarksNoteEvent({
    this.titleId,
    this.hadithId,
    required this.note,
  });

  @override
  List<Object?> get props => [titleId, hadithId, note];
}
