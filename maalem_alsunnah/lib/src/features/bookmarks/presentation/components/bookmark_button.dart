// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';

class BookmarkButton extends StatelessWidget {
  final int itemId;
  final BookmarkType type;
  const BookmarkButton({
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
        final isBookmarked = state.bookmarks.any((element) =>
            element.itemId == itemId &&
            element.type == type &&
            element.isBookmarked);
        if (isBookmarked) {
          return IconButton(
            tooltip: S.of(context).removeBookmark,
            onPressed: () {
              context.read<BookmarksBloc>().add(
                    BookmarksBookmarkItemEvent(
                      itemId: itemId,
                      type: type,
                      isBookmarked: false,
                    ),
                  );
            },
            icon: Icon(Icons.bookmark_outlined),
          );
        }
        return IconButton(
          tooltip: S.of(context).addBookmark,
          onPressed: () {
            context.read<BookmarksBloc>().add(
                  BookmarksBookmarkItemEvent(
                    itemId: itemId,
                    type: type,
                    isBookmarked: true,
                  ),
                );
          },
          icon: Icon(Icons.bookmark_border_outlined),
        );
      },
    );
  }
}
