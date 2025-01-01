// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/data_source/bookmark_repository.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_model.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final BookmarkRepository bookmarkRepository;
  final HadithDbHelper hadithDbHelper;
  BookmarksBloc(
    this.bookmarkRepository,
    this.hadithDbHelper,
  ) : super(BookmarksLoadingState()) {
    on<BookmarksStartEvent>(_start);
    on<BookmarksLoadDataEvent>(_loadData);
    on<BookmarksBookmarkItemEvent>(_bookmarkItem);
    on<BookmarksMarkItemAsReadEvent>(_markItemAsRead);
    on<BookmarksNoteEvent>(_note);
  }

  FutureOr<void> _start(
    BookmarksStartEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    add(BookmarksLoadDataEvent());
  }

  FutureOr<void> _loadData(
    BookmarksLoadDataEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    final bookmarks = await bookmarkRepository.getBookmarks();
    final List<TitleModel> titles = [];
    for (var item in bookmarks) {
      switch (item.type) {
        case BookmarkType.hadith:

          ///TODO
          break;

        case BookmarkType.title:
          int titleId = int.parse(item.itemId);
          final title = await hadithDbHelper.getTitleById(titleId);
          if (title != null) {
            titles.add(title);
          }
          break;
      }
    }
    emit(BookmarksLoadedState(
      bookmarks: bookmarks,
      bookmarkedTitle: titles,
    ));
  }

  FutureOr<void> _handleBookmarkEvent({
    required String itemId,
    required BookmarkType type,
    required Emitter<BookmarksState> emit,
    bool? isBookmarked,
    bool? isRead,
    String? note,
  }) async {
    final state = this.state;
    if (state is! BookmarksLoadedState) return;

    // Find existing bookmark or create a new one
    BookmarkModel? bookmark = state.bookmarks
        .where(
          (element) => element.itemId == itemId && element.type == type,
        )
        .firstOrNull;

    final timeStamp = DateTime.now();
    bookmark ??= BookmarkModel(
      itemId: itemId,
      type: type,
      isBookmarked: isBookmarked ?? false,
      isRead: isRead ?? false,
      note: note ?? "",
      addedDate: timeStamp,
      updateDate: timeStamp,
    );

    // Update fields based on provided parameters
    final updatedBookmark = bookmark.copyWith(
      isBookmarked: isBookmarked ?? bookmark.isBookmarked,
      isRead: isRead ?? bookmark.isRead,
      note: note ?? bookmark.note,
    );

    try {
      await bookmarkRepository.addOrUpdateBookmark(
        bookmark: updatedBookmark,
      );
    } catch (e) {
      appPrint(e);
    }

    // Emit updated state
    add(BookmarksLoadDataEvent());
  }

  FutureOr<void> _bookmarkItem(
    BookmarksBookmarkItemEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    await _handleBookmarkEvent(
      itemId: event.itemId,
      type: event.type,
      emit: emit,
      isBookmarked: event.isBookmarked,
    );
  }

  FutureOr<void> _markItemAsRead(
    BookmarksMarkItemAsReadEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    await _handleBookmarkEvent(
      itemId: event.itemId,
      type: event.type,
      emit: emit,
      isRead: event.isRead,
    );
  }

  FutureOr<void> _note(
    BookmarksNoteEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    await _handleBookmarkEvent(
      itemId: event.itemId,
      type: event.type,
      emit: emit,
      note: event.note,
    );
  }
}
