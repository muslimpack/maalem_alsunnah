// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/components/font_settings_widgets.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class ContentViewerScreen extends StatefulWidget {
  final TitleModel title;
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
        actions: [FontSettingsIconButton()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(15),
              children: [
                SelectableText(
                  context.watch<SettingsCubit>().state.showDiacritics
                      ? content.text
                      : content.searchText,
                  style: TextStyle(
                    fontSize:
                        context.watch<SettingsCubit>().state.fontSize * 10,
                    fontFamily: 'kitab',
                  ),
                ),
              ],
            ),
    );
  }
}
