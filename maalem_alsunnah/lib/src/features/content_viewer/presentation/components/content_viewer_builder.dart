// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/core/utils/dummy_data.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/chapter_header.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_hadith_card.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_format_text_style.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    final content = await sl<HadithDbHelper>().getContentByOrderId(widget.contentOrderId);
    final hadithList = await sl<HadithDbHelper>().getHadithListByContentId(content.id);
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
          return Skeletonizer(
            child: _ContentViewerBuilderBody(
              hadithList: hadithModelDummyData,
              content: contentModelDummyData[1],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          final List<HadithModel> hadithList = snapshot.data!.$2;
          final ContentModel content = snapshot.data!.$1;
          return _ContentViewerBuilderBody(hadithList: hadithList, content: content);
        }
      },
    );
  }
}

class _ContentViewerBuilderBody extends StatelessWidget {
  final List<HadithModel> hadithList;
  final ContentModel content;
  const _ContentViewerBuilderBody({
    required this.hadithList,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final TextFormatterSettings textFormatterSettings = hadithTextFormatterSettings(context);

    final Widget? readingTime = content.text.readableWordCount == 0
        ? null
        : ReadingTimeLabel(total: content.text.readingTime);

    // Path and reading time go in the first chapter's opening; a page that
    // doesn't start with a chapter gets a small opening of its own.
    final startsWithChapter =
        hadithList.isNotEmpty && ContentHadithCard.isChapter(hadithList.first);

    final Widget contentViewer;
    if (hadithList.isEmpty) {
      contentViewer = SliverList(
        delegate: SliverChildListDelegate([
          FormattedText(
            text: context.watch<SettingsCubit>().state.showDiacritics
                ? content.text
                : content.searchText,
            settings: textFormatterSettings,
          )
        ]),
      );
    } else {
      final chapterCounts = ContentHadithCard.chapterHadithCounts(hadithList);
      contentViewer = SliverList.builder(
        itemCount: hadithList.length,
        itemBuilder: (context, index) {
          final hadith = hadithList[index];
          final isOpening = index == 0 && startsWithChapter;
          return ContentHadithCard(
            hadith: hadith,
            textFormatterSettings: textFormatterSettings,
            chapterHadithCount: chapterCounts[index],
            showChapterPath: isOpening,
            chapterReadingTime: isOpening ? readingTime : null,
          );
        },
      );
    }

    return CustomScrollView(
      slivers: [
        if (!startsWithChapter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: PageOpening(titleId: content.titleId, readingTime: readingTime),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          sliver: contentViewer,
        ),
      ],
    );
  }
}
