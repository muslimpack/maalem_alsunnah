import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/hadith_parts.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';

/// A chapter row (باب) shown as a section heading rather than a card:
/// "باب 15" label with a rule, the chapter title, the number of hadith in it,
/// and any intro text (verses, commentary) that precedes the first hadith.
class ChapterHeader extends StatelessWidget {
  final String text;
  final int hadithCount;
  final TextFormatterSettings textFormatterSettings;

  const ChapterHeader({
    super.key,
    required this.text,
    required this.hadithCount,
    required this.textFormatterSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final chapter = ChapterParts.parse(text);
    final base = textFormatterSettings.deafaultStyle;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          if (chapter.number != null)
            Row(
              spacing: 8,
              children: [
                Text(
                  S.of(context).chapterNumber(chapter.number!),
                  style: theme.textTheme.labelLarge?.copyWith(color: colors.primary),
                ),
                Expanded(child: Divider(color: colors.outlineVariant)),
              ],
            ),
          Text(
            chapter.heading,
            style: base.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: (base.fontSize ?? 20) * 1.15,
              color: colors.onSurface,
            ),
          ),
          if (hadithCount > 0)
            Text(
              S.of(context).hadithCount(hadithCount),
              style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          if (chapter.intro != null) ...[
            const SizedBox(height: 4),
            FormattedText(text: chapter.intro!, settings: textFormatterSettings),
          ],
        ],
      ),
    );
  }
}
