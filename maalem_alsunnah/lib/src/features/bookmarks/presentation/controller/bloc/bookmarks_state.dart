part of 'bookmarks_bloc.dart';

sealed class BookmarksState extends Equatable {
  const BookmarksState();
  
  @override
  List<Object> get props => [];
}

final class BookmarksInitial extends BookmarksState {}
