// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/add_note_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/mark_as_read_button.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/share_dialog.dart';

class BookmarkActionBar extends StatelessWidget {
  final String itemId;
  final BookmarkType bookmarkType;
  final ShareType shareType;
  const BookmarkActionBar({
    super.key,
    required this.itemId,
    required this.bookmarkType,
    required this.shareType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: S.of(context).share,
          onPressed: () {
            showShareDialog(
              context,
              itemId: itemId,
              shareType: shareType,
            );
          },
          icon: Icon(Icons.share),
        ),
        BookmarkButton(
          itemId: itemId,
          type: bookmarkType,
        ),
        MarkAsReadButton(
          itemId: itemId,
          type: bookmarkType,
        ),
        AddNoteButton(
          itemId: itemId,
          type: bookmarkType,
        ),
      ],
    );
  }
}
