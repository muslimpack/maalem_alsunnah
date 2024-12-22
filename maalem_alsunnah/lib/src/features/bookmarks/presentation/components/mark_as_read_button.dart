// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';

class MarkAsReadButton extends StatelessWidget {
  final int itemId;
  final BookmarkType type;
  const MarkAsReadButton({
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
            .where(
                (element) => element.itemId == itemId && element.type == type)
            .firstOrNull;

        final isRead = bookmark?.isRead ?? false;
        return IconButton(
          tooltip:
              isRead ? S.of(context).markAsUnread : S.of(context).markAsRead,
          onPressed: () {
            sl<BookmarksBloc>().add(BookmarksMarkItemAsReadEvent(
              itemId: itemId,
              type: type,
              isRead: !isRead,
            ));
          },
          icon: isRead ? Icon(Icons.done_all) : Icon(Icons.done),
        );
      },
    );
  }
}
