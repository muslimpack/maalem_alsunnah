// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/add_note_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_button.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/components/font_settings_widgets.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class ContentViewerScreen extends StatefulWidget {
  final TitleModel title;

  static const String routeName = "/viewer";

  static Route route(TitleModel title) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName, arguments: title),
      builder: (_) => ContentViewerScreen(title: title),
    );
  }

  const ContentViewerScreen({
    super.key,
    required this.title,
  });

  @override
  State<ContentViewerScreen> createState() => _ContentViewerScreenState();
}

class _ContentViewerScreenState extends State<ContentViewerScreen> {
  bool isLoading = true;
  late final ContentModel content;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    content = await sl<HadithDbHelper>().getContentByTitleId(widget.title.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.name),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TitlesChainBreadCrumb(titleId: widget.title.id),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(15),
                    children: [
                      SelectableText(
                        context.watch<SettingsCubit>().state.showDiacritics
                            ? content.text
                            : content.searchText,
                        style: TextStyle(
                          fontSize:
                              context.watch<SettingsCubit>().state.fontSize *
                                  10,
                          fontFamily: 'kitab',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: isLoading
          ? const SizedBox()
          : BottomAppBar(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FontSettingsIconButton(),
                BookmarkButton(
                  itemId: content.titleId,
                  type: BookmarkType.title,
                ),
                AddNoteButton(
                  itemId: content.titleId,
                  type: BookmarkType.title,
                )
              ],
            )),
    );
  }
}
