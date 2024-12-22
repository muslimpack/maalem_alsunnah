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
  List<TitleModel> get favorites {
    final favorites =
        bookmarks.where((element) => element.isBookmarked).toList();

    return favorites
        .map((e) =>
            bookmarkedTitle.firstWhere((element) => element.id == e.itemId))
        .toList();
  }

  List<TitleModel> get notes {
    final notes =
        bookmarks.where((element) => element.note.isNotEmpty).toList();
    return notes
        .map((e) =>
            bookmarkedTitle.firstWhere((element) => element.id == e.itemId))
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
