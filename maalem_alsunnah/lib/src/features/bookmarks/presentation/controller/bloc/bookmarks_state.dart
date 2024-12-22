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
  List<BookmarkModel> get favorites =>
      bookmarks.where((element) => element.isBookmarked).toList();
  List<BookmarkModel> get notes =>
      bookmarks.where((element) => element.note.isNotEmpty).toList();
  const BookmarksLoadedState({required this.bookmarks});

  @override
  List<Object> get props => [bookmarks];

  BookmarksLoadedState copyWith({
    List<BookmarkModel>? bookmarks,
  }) {
    return BookmarksLoadedState(
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }
}
