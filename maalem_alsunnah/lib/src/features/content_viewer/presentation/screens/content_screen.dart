// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_hadith_card.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_viewer_bottom_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
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
    final defaultStyle = TextStyle(
      fontSize: context.watch<SettingsCubit>().state.fontSize * 10,
      fontFamily: 'adwaa',
      height: 1.5,
    );
    final TextFormatterSettings textFormatterSettings =
        state.textFormatterSettings(defaultStyle);
    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.name),
        centerTitle: true,
        actions: [
          FontSettingsIconButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TitlesChainBreadCrumb(titleId: state.content.titleId),
          // Expanded(
          //   child: ListView(
          //     padding: EdgeInsets.all(15),
          //     children: [
          //       FormattedText(
          //         text: context.watch<SettingsCubit>().state.showDiacritics
          //             ? state.content.text
          //             : state.content.searchText,
          //         settings: textFormatterSettings,
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView(
              controller: context.read<ContentViewerCubit>().scrollController,
              padding: EdgeInsets.all(15),
              children: [
                ...state.hadithList.map(
                  (hadith) {
                    return ContentHadithCard(
                      hadith: hadith,
                      textFormatterSettings: textFormatterSettings,
                    );
                  },
                ),
                if (state.hadithList.isEmpty)
                  FormattedText(
                    text: context.watch<SettingsCubit>().state.showDiacritics
                        ? state.content.text
                        : state.content.searchText,
                    settings: textFormatterSettings,
                  ),
                Container(
                  margin: EdgeInsets.all(50),
                  height: 10,
                  color: Colors.amber,
                ),
                FormattedText(
                  text: context.watch<SettingsCubit>().state.showDiacritics
                      ? state.content.text
                      : state.content.searchText,
                  settings: textFormatterSettings,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ContentViewerBottomBar(state: state),
    );
  }
}
