// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/data_source/bookmark_repository.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_model.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final BookmarkRepository bookmarkRepository;
  BookmarksBloc(
    this.bookmarkRepository,
  ) : super(BookmarksLoadingState()) {
    on<BookmarksStartEvent>(_start);
    on<BookmarksBookmarkItemEvent>(_bookmarkItem);
    on<BookmarksMarkItemAsReadEvent>(_markItemAsRead);
    on<BookmarksNoteEvent>(_note);
  }

  FutureOr<void> _start(
    BookmarksStartEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    final bookmarks = await bookmarkRepository.getBookmarks();
    emit(BookmarksLoadedState(bookmarks: bookmarks));
  }

  FutureOr<void> _bookmarkItem(
    BookmarksBookmarkItemEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    final state = this.state;
    if (state is! BookmarksLoadedState) return;

    BookmarkModel? bookmark = state.bookmarks.where(
      (element) {
        return element.itemId == event.itemId && element.type == event.type;
      },
    ).firstOrNull;
    final timeStamp = DateTime.now();
    bookmark ??= BookmarkModel(
      itemId: event.itemId,
      type: event.type,
      isBookmarked: event.isBookmarked,
      isRead: false,
      note: "",
      addedDate: timeStamp,
      updateDate: timeStamp,
    );

    try {
      final result =
          await bookmarkRepository.addOrUpdateBookmark(bookmark: bookmark);
      appPrint(result);
    } catch (e) {
      appPrint(e);
    }

    final bookmarks = await bookmarkRepository.getBookmarks();
    emit(BookmarksLoadedState(bookmarks: bookmarks));
  }

  FutureOr<void> _markItemAsRead(
    BookmarksMarkItemAsReadEvent event,
    Emitter<BookmarksState> emit,
  ) async {}
  FutureOr<void> _note(
    BookmarksNoteEvent event,
    Emitter<BookmarksState> emit,
  ) async {}
}
