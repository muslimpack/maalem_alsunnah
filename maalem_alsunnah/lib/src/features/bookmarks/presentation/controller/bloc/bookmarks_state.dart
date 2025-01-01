// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bookmarks_bloc.dart';

sealed class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object> get props => [];
}

final class BookmarksLoadingState extends BookmarksState {}

class BookmarksLoadedState extends BookmarksState {
  final List<BookmarkModel> bookmarks;
  final List<TitleModel> bookmarkedTitle;
  final List<HadithModel> bookmarkedHadithList;
  final BookmarkViewEnum bookmarkView;

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

  List<HadithModel> get favoriteHadithList {
    final favorites = bookmarks
        .where(
          (e) => e.isBookmarked && e.type == BookmarkType.hadith,
        )
        .toList();

    return favorites
        .map(
          (e) => bookmarkedHadithList.firstWhere(
            (element) {
              return element.id.toString() == e.itemId;
            },
          ),
        )
        .toList();
  }

  List<HadithModel> get hadithListWithNotes {
    final notes = bookmarks
        .where(
          (e) => e.note.isNotEmpty && e.type == BookmarkType.hadith,
        )
        .toList();
    return notes
        .map(
          (e) => bookmarkedHadithList.firstWhere((element) =>
              element.id.toString() == e.itemId &&
              e.type == BookmarkType.hadith),
        )
        .toList();
  }

  const BookmarksLoadedState({
    required this.bookmarks,
    required this.bookmarkedTitle,
    required this.bookmarkedHadithList,
    required this.bookmarkView,
  });

  @override
  List<Object> get props => [
        bookmarks,
        bookmarkView,
        bookmarkedTitle,
        bookmarkedHadithList,
      ];

  BookmarksLoadedState copyWith({
    List<BookmarkModel>? bookmarks,
    List<TitleModel>? bookmarkedTitle,
    List<HadithModel>? bookmarkedHadithList,
    BookmarkViewEnum? bookmarkView,
  }) {
    return BookmarksLoadedState(
      bookmarks: bookmarks ?? this.bookmarks,
      bookmarkedTitle: bookmarkedTitle ?? this.bookmarkedTitle,
      bookmarkedHadithList: bookmarkedHadithList ?? this.bookmarkedHadithList,
      bookmarkView: bookmarkView ?? this.bookmarkView,
    );
  }
}
