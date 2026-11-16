import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/hadith_parts.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/manuscript_ornament.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

/// A chapter row (باب) shown as the illuminated opening of a manuscript page:
///
/// ```text
///        المقصد الأول • الكتاب الأول        <- path ([showPath])
///   ──────────────── ✦ ────────────────
///              باب ١ من ٣٩
///         أركان الإسلام والإيمان
///        📖 ٣ أحاديث  ✦  ⏳ دقيقتان        <- count, [readingTime]
/// intro text (verses, commentary)…
/// ```
class ChapterHeader extends StatelessWidget {
  final String text;
  final int titleId;
  final int hadithCount;
  final TextFormatterSettings textFormatterSettings;

  /// Show the parent levels above the ornament. Only the first chapter of a
  /// page does; the path is the same for the rest.
  final bool showPath;

  /// Usually a [ReadingTimeLabel] for the page; null hides it.
  final Widget? readingTime;

  const ChapterHeader({
    super.key,
    required this.text,
    required this.titleId,
    required this.hadithCount,
    required this.textFormatterSettings,
    this.showPath = false,
    this.readingTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final chapter = ChapterParts.parse(text);
    final base = textFormatterSettings.deafaultStyle;

    return Padding(
      // Room above (away from the app bar) and below (away from the first
      // card) so the opening reads as its own block.
      padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Opening(
            titleId: titleId,
            showPath: showPath,
            label: chapter.number == null
                ? null
                : _ChapterPosition(titleId: titleId, number: chapter.number!),
            title: Text(
              chapter.heading,
              textAlign: TextAlign.center,
              style: base.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: (base.fontSize ?? 20) * 1.1,
                height: 1.5,
                color: colors.onSurface,
              ),
            ),
            meta: [
              if (hadithCount > 0)
                _MetaItem(
                  icon: Icons.menu_book_outlined,
                  label: S.of(context).hadithCount(hadithCount),
                ),
              if (readingTime != null) readingTime!,
            ],
          ),
          if (chapter.intro != null) ...[
            const SizedBox(height: 16),
            FormattedText(text: chapter.intro!, settings: textFormatterSettings),
          ],
        ],
      ),
    );
  }
}

/// Opening for a page that doesn't start with a chapter row: path, ornament
/// and reading time only.
class PageOpening extends StatelessWidget {
  const PageOpening({super.key, required this.titleId, this.readingTime});

  final int titleId;
  final Widget? readingTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 12),
      child: _Opening(
        titleId: titleId,
        showPath: true,
        meta: [if (readingTime != null) readingTime!],
      ),
    );
  }
}

/// Layout of the opening, in three groups with clear gaps between them:
///   path + ornament  |  label + title  |  meta
class _Opening extends StatelessWidget {
  const _Opening({
    required this.titleId,
    required this.showPath,
    this.label,
    this.title,
    this.meta = const [],
  });

  final int titleId;
  final bool showPath;
  final Widget? label;
  final Widget? title;
  final List<Widget> meta;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showPath) ...[
          TitlesChainBreadCrumb(titleId: titleId, mode: BreadcrumbMode.opening),
          const SizedBox(height: 10),
        ],
        // Narrow, so it reads as an ornament rather than a page divider.
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: const ManuscriptOrnament(),
        ),
        if (label != null || title != null) const SizedBox(height: 16),
        if (label != null) label!,
        if (label != null && title != null) const SizedBox(height: 4),
        if (title != null) title!,
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 12),
          _MetaRow(items: meta),
        ],
      ],
    );
  }
}

/// "باب ١ من ٣٩": the printed chapter number out of the highest number among
/// its siblings (some sections skip numbers or start with an unnumbered
/// تمهيد, so the sibling count would be wrong). Shows "باب ١" until known.
class _ChapterPosition extends StatefulWidget {
  const _ChapterPosition({required this.titleId, required this.number});

  final int titleId;
  final String number;

  @override
  State<_ChapterPosition> createState() => _ChapterPositionState();
}

class _ChapterPositionState extends State<_ChapterPosition> {
  late Future<int?> _total = _loadTotal();

  @override
  void didUpdateWidget(covariant _ChapterPosition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.titleId != widget.titleId) _total = _loadTotal();
  }

  Future<int?> _loadTotal() async {
    final db = sl<HadithDbHelper>();
    final title = await db.getTitleById(widget.titleId);
    if (title == null || title.parentId == -1) return null;
    final siblings = await db.getSubTitlesByTitleId(title.parentId);
    int? highest;
    for (final sibling in siblings) {
      final n = int.tryParse(ChapterParts.parse(sibling.name).number ?? '');
      if (n != null && (highest == null || n > highest)) highest = n;
    }
    return highest;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary);
    return FutureBuilder(
      future: _total,
      builder: (context, snapshot) {
        final total = snapshot.data;
        final number = int.tryParse(widget.number);
        final label = total != null && number != null && number <= total
            ? S.of(context).chapterOfTotal(widget.number, total)
            : S.of(context).chapterNumber(widget.number);
        return Text(label, style: style);
      },
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.items});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final gold = manuscriptGold(context);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 4,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) Text('✦', style: TextStyle(color: gold, fontSize: 11)),
          items[i],
        ],
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Icon(icon, size: 15, color: c),
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: c)),
      ],
    );
  }
}

/// The page's estimated reading time ("٢٠ ثانية", "دقيقتان").
class ReadingTimeLabel extends StatelessWidget {
  const ReadingTimeLabel({super.key, required this.total});

  final Duration total;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: S.of(context).readingTime,
      child: _MetaItem(icon: Icons.hourglass_empty_rounded, label: formatReadingTime(context, total)),
    );
  }
}
