// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/note_dialog.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';

class AddNoteButton extends StatelessWidget {
  final int itemId;
  final BookmarkType type;
  const AddNoteButton({
    super.key,
    required this.itemId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        if (state is! BookmarksLoadedState) {
          return SizedBox();
        }
        final bookmark = state.bookmarks
            .where((element) =>
                element.itemId == itemId &&
                element.type == type &&
                element.note.isNotEmpty)
            .firstOrNull;

        return IconButton(
          tooltip: S.of(context).addNotes,
          onPressed: () {
            showNoteDialog(context, itemId: itemId, type: type);
          },
          icon: bookmark != null
              ? Badge(
                  label: Text(""),
                  child: Icon(Icons.library_books_outlined),
                )
              : Icon(Icons.library_books_outlined),
        );
      },
    );
  }
}
