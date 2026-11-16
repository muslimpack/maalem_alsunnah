// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_action_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/hadith_card_popup_menu.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';

class ContentHadithCard extends StatelessWidget {
  final bool showTitleChain;
  final HadithModel hadith;
  final TextFormatterSettings textFormatterSettings;
  const ContentHadithCard({
    super.key,
    required this.hadith,
    required this.textFormatterSettings,
    this.showTitleChain = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTitle = hadith.text.startsWith('باب') || hadith.id.isEmpty;
    final String text =
        context.watch<SettingsCubit>().state.showDiacritics ? hadith.text : hadith.searchText;
    final String formattedText = text;
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Accent on the reading-start side (right in Arabic, left in English).
          border: isTitle
              ? null
              : BorderDirectional(
                  start: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    width: 4,
                  ),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showTitleChain)
              TitlesChainBreadCrumb(
                titleId: hadith.titleId,
                showLastOnly: true,
              ),
            FormattedText(
              text: formattedText,
              settings: textFormatterSettings,
              textLeadingWidget: isTitle ? null : HadithCardPopupMenu(hadith: hadith),
            ),
            if (!isTitle) ...[
              const SizedBox(height: 8),
              Divider(
                height: 1,
                thickness: 0.5,
                color: theme.dividerColor.withValues(alpha: 0.12),
              ),
              const SizedBox(height: 2),
              BookmarkActionBar(
                itemId: hadith.id,
                bookmarkType: BookmarkType.hadith,
                shareType: ShareType.hadith,
              )
            ]
          ],
        ),
      ),
    );
  }
}
