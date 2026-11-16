import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_action_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_jump_sheet.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';

/// `[‹] [12 / 340] [›]  share · bookmark · read · note`
class ContentViewerBottomBar extends StatelessWidget {
  const ContentViewerBottomBar({super.key, required this.state});

  final ContentViewerLoadedState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<ContentViewerCubit>();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.12))),
      ),
      child: SafeArea(
        top: false,
        child: IconButtonTheme(
          data: IconButtonThemeData(
            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              children: [
                // Icons.chevron_left/right mirror in RTL, matching the PageView.
                IconButton(
                  tooltip: S.of(context).previous,
                  onPressed: state.hasPrevious ? cubit.previousContent : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(child: _PositionChip(state: state)),
                IconButton(
                  tooltip: S.of(context).next,
                  onPressed: state.hasNext ? cubit.nextContent : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
                const SizedBox(width: 4),
                BookmarkActionBar(
                  itemId: state.content.id.toString(),
                  bookmarkType: BookmarkType.title,
                  shareType: ShareType.content,
                  mainAxisSize: MainAxisSize.min,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the current position; tapping opens [ContentJumpSheet].
class _PositionChip extends StatelessWidget {
  const _PositionChip({required this.state});

  final ContentViewerLoadedState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Tooltip(
      message: S.of(context).goTo,
      child: Material(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => ContentJumpSheet.show(context, state),
          child: SizedBox(
            height: 36,
            child: Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '${state.content.orderId} / ${state.contentRange.end.toInt()}',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
