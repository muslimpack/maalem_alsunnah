// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/add_note_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/mark_as_read_button.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_nav_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/share_dialog.dart';

class ContentViewerBottomBar extends StatelessWidget {
  const ContentViewerBottomBar({
    super.key,
    required this.state,
  });

  final ContentViewerLoadedState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContentNavBar(state: state),
        BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: S.of(context).share,
              onPressed: () {
                showShareDialog(
                  context,
                  itemId: state.content.id.toString(),
                  shareType: ShareType.content,
                );
              },
              icon: Icon(Icons.share),
            ),
            BookmarkButton(
              itemId: state.content.titleId,
              type: BookmarkType.title,
            ),
            MarkAsReadButton(
              itemId: state.content.titleId,
              type: BookmarkType.title,
            ),
            AddNoteButton(
              itemId: state.content.titleId,
              type: BookmarkType.title,
            ),
          ],
        )),
      ],
    );
  }
}
