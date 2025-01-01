// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bookmarks_bloc.dart';

sealed class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object> get props => [];
}

final class BookmarksLoadingState extends BookmarksState {}

final class BookmarksLoadedState extends BookmarksState {
  final List<BookmarkModel> bookmarks;
  final List<TitleModel> bookmarkedTitle;
  List<TitleModel> get favoriteTitles {
    final favorites = bookmarks
        .where(
          (e) => e.isBookmarked && e.type == BookmarkType.title,
        )
        .toList();

    return favorites
        .map(
          (e) => bookmarkedTitle.firstWhere(
            (element) {
              return element.id.toString() == e.itemId;
            },
          ),
        )
        .toList();
  }

  List<TitleModel> get titlesWithNotes {
    final notes = bookmarks
        .where(
          (e) => e.note.isNotEmpty && e.type == BookmarkType.title,
        )
        .toList();
    return notes
        .map(
          (e) => bookmarkedTitle.firstWhere((element) =>
              element.id.toString() == e.itemId &&
              e.type == BookmarkType.title),
        )
        .toList();
  }

  const BookmarksLoadedState({
    required this.bookmarks,
    required this.bookmarkedTitle,
  });

  @override
  List<Object> get props => [bookmarks];

  BookmarksLoadedState copyWith({
    List<BookmarkModel>? bookmarks,
    List<TitleModel>? bookmarkedTitle,
  }) {
    return BookmarksLoadedState(
      bookmarks: bookmarks ?? this.bookmarks,
      bookmarkedTitle: bookmarkedTitle ?? this.bookmarkedTitle,
    );
  }
}
