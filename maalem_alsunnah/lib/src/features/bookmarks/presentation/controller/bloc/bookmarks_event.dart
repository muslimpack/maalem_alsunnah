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

class BookmarksLoadDataEvent extends BookmarksEvent {
  const BookmarksLoadDataEvent();

  @override
  List<Object?> get props => [];
}

class BookmarksBookmarkItemEvent extends BookmarksEvent {
  final String itemId;
  final BookmarkType type;
  final bool isBookmarked;
  const BookmarksBookmarkItemEvent({
    required this.itemId,
    required this.type,
    required this.isBookmarked,
  });

  @override
  List<Object?> get props => [itemId, type, isBookmarked];
}

class BookmarksMarkItemAsReadEvent extends BookmarksEvent {
  final String itemId;
  final BookmarkType type;
  final bool isRead;
  const BookmarksMarkItemAsReadEvent({
    required this.itemId,
    required this.type,
    required this.isRead,
  });

  @override
  List<Object?> get props => [itemId, type, isRead];
}

class BookmarksNoteEvent extends BookmarksEvent {
  final String itemId;
  final BookmarkType type;
  final String note;
  const BookmarksNoteEvent({
    required this.itemId,
    required this.type,
    required this.note,
  });

  @override
  List<Object?> get props => [itemId, type, note];
}
