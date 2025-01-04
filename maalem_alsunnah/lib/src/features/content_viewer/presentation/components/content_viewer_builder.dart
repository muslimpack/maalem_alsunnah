// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_hadith_card.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_format_text_style.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class ContentViewerBuilder extends StatefulWidget {
  final int contentOrderId;
  const ContentViewerBuilder({
    super.key,
    required this.contentOrderId,
  });

  @override
  State<ContentViewerBuilder> createState() => _ContentViewerBuilderState();
}

class _ContentViewerBuilderState extends State<ContentViewerBuilder> {
  late Future<(ContentModel content, List<HadithModel>)> data;
  @override
  void initState() {
    super.initState();
    data = _updateAndGetList();
  }

  void refreshList() {
    setState(() {
      data = _updateAndGetList();
    });
  }

  Future<(ContentModel, List<HadithModel>)> _updateAndGetList() async {
    final content =
        await sl<HadithDbHelper>().getContentById(widget.contentOrderId);
    final hadithList =
        await sl<HadithDbHelper>().getHadithListByContentId(content.id);
    return (content, hadithList);
  }

  @override
  void didUpdateWidget(covariant ContentViewerBuilder oldWidget) {
    if (oldWidget.contentOrderId != widget.contentOrderId) {
      refreshList();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          final TextFormatterSettings textFormatterSettings =
              hadithTextFormatterSettings(context);
          final List<HadithModel> hadithList = snapshot.data!.$2;
          final ContentModel content = snapshot.data!.$1;

          final Widget contentViewer;
          if (hadithList.isEmpty) {
            contentViewer = ListView(
              controller: context.read<ContentViewerCubit>().scrollController,
              padding: EdgeInsets.all(15),
              children: [
                FormattedText(
                  text: context.watch<SettingsCubit>().state.showDiacritics
                      ? content.text
                      : content.searchText,
                  settings: textFormatterSettings,
                ),
              ],
            );
          } else {
            contentViewer = ListView.builder(
              controller: context.read<ContentViewerCubit>().scrollController,
              padding: EdgeInsets.all(15),
              itemCount: hadithList.length,
              itemBuilder: (context, index) {
                final hadith = hadithList[index];
                return ContentHadithCard(
                  hadith: hadith,
                  textFormatterSettings: textFormatterSettings,
                );
              },
            );
          }
          return Column(
            children: [
              TitlesChainBreadCrumb(titleId: content.titleId),
              ListTile(
                leading: Icon(Icons.timer_outlined),
                title: Text(
                    content.text.getArabicTextReadingTimeAsString(context)),
              ),
              Expanded(
                child: contentViewer,
              )
            ],
          );
        }
      },
    );
  }
}
