// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/add_note_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/mark_as_read_button.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/components/font_settings_widgets.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class ContentScreen extends StatelessWidget {
  final ContentViewerLoadedState state;
  const ContentScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TitlesChainBreadCrumb(titleId: state.content.titleId),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                SelectableText(
                  context.watch<SettingsCubit>().state.showDiacritics
                      ? state.content.text
                      : state.content.searchText,
                  style: TextStyle(
                    fontSize:
                        context.watch<SettingsCubit>().state.fontSize * 10,
                    fontFamily: 'kitab',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: !state.hasPrevious
                ? null
                : () {
                    context.read<ContentViewerCubit>().previousContent();
                  },
            icon: Icon(Icons.arrow_back_ios),
          ),
          FontSettingsIconButton(),
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
            onPressed: !state.hasNext
                ? null
                : () {
                    context.read<ContentViewerCubit>().nextContent();
                  },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      )),
    );
  }
}
