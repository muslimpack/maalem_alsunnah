// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/add_note_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/mark_as_read_button.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';

class ContentViewerBottomBar extends StatelessWidget {
  const ContentViewerBottomBar({
    super.key,
    required this.state,
  });

  final ContentViewerLoadedState state;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: S.of(context).previous,
          onPressed: !state.hasPrevious
              ? null
              : () {
                  context.read<ContentViewerCubit>().previousContent();
                },
          icon: Icon(Icons.arrow_back_ios),
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
        IconButton(
          tooltip: S.of(context).next,
          onPressed: !state.hasNext
              ? null
              : () {
                  context.read<ContentViewerCubit>().nextContent();
                },
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ],
    ));
  }
}
