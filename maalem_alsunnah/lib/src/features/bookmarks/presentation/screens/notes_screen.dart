import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/screens/list_view.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        if (state is! BookmarksLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }

        return BookmarkListView(
          titles: state.titlesWithNotes,
          hadithList: state.hadithListWithNotes,
          bookmarkView: state.bookmarkView,
        );
      },
    );
  }
}
