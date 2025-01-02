// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_view_enum.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_view_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_hadith_card.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_format_text_style.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/title_card.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class BookmarkListView extends StatelessWidget {
  final List<TitleModel> titles;
  final List<HadithModel> hadithList;
  final BookmarkViewEnum bookmarkView;
  const BookmarkListView({
    super.key,
    required this.titles,
    required this.hadithList,
    required this.bookmarkView,
  });

  @override
  Widget build(BuildContext context) {
    const double padding = 15;
    final TextFormatterSettings textFormatterSettings =
        hadithTextFormatterSettings(context);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(top: padding),
          sliver: SliverToBoxAdapter(
            child: BookmarkViewBar(),
          ),
        ),
        if (bookmarkView != BookmarkViewEnum.hadith) ...[
          if (titles.isNotEmpty && bookmarkView == BookmarkViewEnum.all)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  spacing: padding,
                  children: [
                    Text(
                      S.of(context).titles,
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverList.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                final title = titles[index];
                return TitleCard(title: title);
              },
            ),
          )
        ],
        if (bookmarkView != BookmarkViewEnum.titles) ...[
          if (hadithList.isNotEmpty && bookmarkView == BookmarkViewEnum.all)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                child: Row(
                  spacing: padding,
                  children: [
                    Text(
                      S.of(context).hadith,
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverList.builder(
              itemCount: hadithList.length,
              itemBuilder: (context, index) {
                final hadith = hadithList[index];
                return ContentHadithCard(
                  showTitleChain: true,
                  hadith: hadith,
                  textFormatterSettings: textFormatterSettings,
                );
              },
            ),
          )
        ],
      ],
    );
  }
}
