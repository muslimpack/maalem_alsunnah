import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/utils/rich_text_controller.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_button.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/note_dialog.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/hadith_parts.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/chapter_header.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_card_popup_menu.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

/// A row of the hadith list: a [ChapterHeader] for chapter rows (no id),
/// otherwise a structured hadith card:
///
/// ```text
/// [40] [متفق عليه]                    🔖 ⋮
/// عن أنس ... «لا يؤمن أحدكم ...»
/// 📝 note preview
/// [خ 15] [م 44]               صحيح  ✓ قرأته
/// ```
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
    final showDiacritics = context.select((SettingsCubit c) => c.state.showDiacritics);
    final text = showDiacritics ? hadith.text : hadith.searchText;

    if (hadith.id.isEmpty) {
      return ChapterHeader(
        text: text,
        hadithCount: hadith.count,
        textFormatterSettings: textFormatterSettings,
      );
    }

    final theme = Theme.of(context);
    final parts = HadithParts.parse(text);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 6, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showTitleChain)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 6, end: 10),
                child: TitlesChainBreadCrumb(titleId: hadith.titleId, showLastOnly: true),
              ),
            _Header(hadith: hadith, parts: parts),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: FormattedText(text: parts.body, settings: textFormatterSettings),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: _Footer(hadith: hadith, parts: parts),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.hadith, required this.parts});

  final HadithModel hadith;
  final HadithParts parts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final s = S.of(context);

    final sourceLabel = switch (parts.source) {
      HadithSource.agreedUpon => s.agreedUpon,
      HadithSource.bukhari => s.sahihBukhari,
      HadithSource.muslim => s.sahihMuslim,
      null => null,
    };

    return IconButtonTheme(
      data: IconButtonThemeData(style: IconButton.styleFrom(visualDensity: VisualDensity.compact)),
      child: Row(
        spacing: 8,
        children: [
          if (parts.number != null)
            _Pill(
              label: parts.number!,
              background: colors.primaryContainer,
              foreground: colors.onPrimaryContainer,
            ),
          if (sourceLabel != null)
            _Pill(
              label: sourceLabel,
              background: colors.surfaceContainerHighest,
              foreground: colors.onSurface,
            ),
          const Spacer(),
          BookmarkButton(itemId: hadith.id, type: BookmarkType.hadith),
          HadithCardPopupMenu(hadith: hadith),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.hadith, required this.parts});

  final HadithModel hadith;
  final HadithParts parts;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final s = S.of(context);

    final (isRead, note) = context.select((BookmarksBloc bloc) {
      final state = bloc.state;
      if (state is! BookmarksLoadedState) return (false, '');
      final bookmark = state.bookmarks
          .where((b) => b.itemId == hadith.id && b.type == BookmarkType.hadith)
          .firstOrNull;
      return (bookmark?.isRead ?? false, bookmark?.note ?? '');
    });

    final hasMeta = parts.references.isNotEmpty || parts.grade != null || isRead;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (note.isNotEmpty) _NotePreview(hadith: hadith, note: note),
        if (hasMeta)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [for (final ref in parts.references) _ReferenceChip(reference: ref)],
                  ),
                ),
                if (parts.grade != null) _GradeChip(grade: parts.grade!, level: parts.gradeLevel),
                if (isRead)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 2,
                    children: [
                      Icon(Icons.done_all, size: 16, color: colors.primary),
                      Text(
                        s.read,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.primary),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NotePreview extends StatelessWidget {
  const _NotePreview({required this.hadith, required this.note});

  final HadithModel hadith;
  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => showNoteDialog(context, itemId: hadith.id, type: BookmarkType.hadith),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Icon(Icons.edit_note_rounded, size: 18, color: colors.primary),
                Expanded(
                  child: Text(
                    RichTextController.plainTextOf(note),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurface, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReferenceChip extends StatelessWidget {
  const _ReferenceChip({required this.reference});

  final HadithReference reference;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bookName = reference.bookName;
    final label = Text(
      reference.label,
      style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
    );
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: label,
    );
    if (bookName == null) return chip;
    return Tooltip(
      message: '$bookName ${reference.detail}',
      triggerMode: TooltipTriggerMode.tap,
      child: chip,
    );
  }
}

class _GradeChip extends StatelessWidget {
  const _GradeChip({required this.grade, required this.level});

  final String grade;
  final HadithGradeLevel level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final (Color background, Color foreground) = switch (level) {
      HadithGradeLevel.accepted => isDark
          ? (const Color(0xFF1F3326), const Color(0xFF8FD1A3))
          : (const Color(0xFFE3F0E6), const Color(0xFF2F6B45)),
      HadithGradeLevel.weak => (colors.errorContainer, colors.onErrorContainer),
      HadithGradeLevel.neutral => (colors.surfaceContainerHighest, colors.onSurfaceVariant),
    };

    return Flexible(
      child: _Pill(label: grade, background: background, foreground: foreground),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.background, required this.foreground});

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 32),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
      ),
    );
  }
}
