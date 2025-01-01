// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_action_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_nav_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';

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
          child: BookmarkActionBar(
            itemId: state.content.id.toString(),
            bookmarkType: BookmarkType.title,
            shareType: ShareType.content,
          ),
        ),
      ],
    );
  }
}
