import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  BookmarksBloc() : super(BookmarksInitial()) {
    on<BookmarksEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
