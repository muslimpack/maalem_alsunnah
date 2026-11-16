// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/core/utils/dummy_data.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_hadith_card.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_format_text_style.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
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
    final theme = Theme.of(context);
    final mutedColor = theme.textTheme.bodySmall?.color;

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
          return ContentHadithCard(
            hadith: hadith,
            textFormatterSettings: textFormatterSettings,
            chapterHadithCount: chapterCounts[index],
          );
        },
      );
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TitlesChainBreadCrumb(titleId: content.titleId),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 14,
                        color: mutedColor?.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        content.text.getArabicTextReadingTimeAsString(context) ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: mutedColor?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          sliver: contentViewer,
        )
      ],
    );
  }
}
