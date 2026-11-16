import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_platform.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_aspect.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_settings.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_theme.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/controller/cubit/share_image_cubit.dart';

/// The style controls and export buttons under (or beside) the preview.
class ShareImageControls extends StatelessWidget {
  final ShareImageLoadedState state;

  /// Exports the current page, or all pages; [origin] anchors the share
  /// sheet on tablets.
  final void Function({required bool all, Rect? origin}) onExport;

  const ShareImageControls({super.key, required this.state, required this.onExport});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareImageCubit>();
    final s = S.of(context);
    final enabled = !state.isExporting;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Colours: palette swatches, and light / dark.
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    for (final palette in ShareImagePalette.values)
                      _PaletteSwatch(
                        theme: ShareImageTheme.resolve(palette, state.theme.brightness),
                        label: _paletteName(s, palette),
                        selected: palette == state.settings.palette,
                        onTap: enabled ? () => cubit.setPalette(palette) : null,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SegmentedButton<Brightness>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: Brightness.light,
                    icon: const Icon(Icons.light_mode_outlined),
                    tooltip: s.shareImageLight,
                  ),
                  ButtonSegment(
                    value: Brightness.dark,
                    icon: const Icon(Icons.dark_mode_outlined),
                    tooltip: s.shareImageDark,
                  ),
                ],
                selected: {state.theme.brightness},
                onSelectionChanged: enabled ? (value) => cubit.setBrightness(value.first) : null,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Size.
          SegmentedButton<ShareImageAspect>(
            showSelectedIcon: false,
            segments: [
              for (final aspect in ShareImageAspect.values)
                ButtonSegment(
                  value: aspect,
                  icon: aspect == ShareImageAspect.auto
                      ? const Icon(Icons.auto_awesome_outlined)
                      : _RatioIcon(size: aspect.size!),
                  label: Text(
                    aspect == ShareImageAspect.auto ? s.shareImageAuto : aspect.ratioLabel,
                    maxLines: 1,
                  ),
                ),
            ],
            selected: {state.settings.aspect},
            onSelectionChanged: enabled ? (value) => cubit.setAspect(value.first) : null,
          ),
          const SizedBox(height: 8),

          // Text size and titles.
          Row(
            children: [
              Icon(Icons.format_size, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              IconButton(
                tooltip: s.fontDecreaseSize,
                onPressed: enabled && state.settings.fontSize > ShareImageSettings.minFontSize
                    ? cubit.decreaseFontSize
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  state.settings.fontSize.round().toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                  semanticsLabel: s.shareImageTextSize,
                ),
              ),
              IconButton(
                tooltip: s.fontIncreaseSize,
                onPressed: enabled && state.settings.fontSize < ShareImageSettings.maxFontSize
                    ? cubit.increaseFontSize
                    : null,
                icon: const Icon(Icons.add),
              ),
              const Spacer(),
              if (state.titleChain.isNotEmpty)
                FilterChip(
                  label: Text(s.shareImageShowTitles),
                  selected: state.settings.showTitleChain,
                  onSelected: enabled ? (_) => cubit.toggleTitleChain() : null,
                ),
            ],
          ),
          const SizedBox(height: 8),

          _ExportButtons(state: state, onExport: onExport),
        ],
      ),
    );
  }

  static String _paletteName(S s, ShareImagePalette palette) => switch (palette) {
        ShareImagePalette.maroon => s.shareImagePaletteMaroon,
        ShareImagePalette.emerald => s.shareImagePaletteEmerald,
        ShareImagePalette.indigo => s.shareImagePaletteIndigo,
        ShareImagePalette.sand => s.shareImagePaletteSand,
      };
}

class _ExportButtons extends StatelessWidget {
  final ShareImageLoadedState state;
  final void Function({required bool all, Rect? origin}) onExport;

  const _ExportButtons({required this.state, required this.onExport});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (state.progress case final progress?) {
      return SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: progress.current / progress.total,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              s.shareImagePreparing(progress.current, progress.total),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    final desktop = PlatformExtension.isDesktop;
    final icon = Icon(desktop ? Icons.download_outlined : Icons.share_outlined);
    final pageLabel = desktop ? s.shareImageSavePage : s.shareImageSharePage;

    // The rect of the pressed button, for the iPad share sheet.
    void export(BuildContext buttonContext, {required bool all}) {
      final box = buttonContext.findRenderObject() as RenderBox?;
      final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
      onExport(all: all, origin: origin);
    }

    if (state.pageCount < 2) {
      return Builder(
        builder: (buttonContext) => FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: () => export(buttonContext, all: false),
          icon: icon,
          label: Text(desktop ? s.shareImageSavePage : s.share),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Builder(
            builder: (buttonContext) => FilledButton.tonalIcon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: () => export(buttonContext, all: false),
              icon: icon,
              label: Text(pageLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Builder(
            builder: (buttonContext) => FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: () => export(buttonContext, all: true),
              icon: const Icon(Icons.collections_outlined),
              label: Text(
                desktop ? s.shareImageSaveAll(state.pageCount) : s.shareImageShareAll(state.pageCount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A round swatch split between a preset's background and accent.
class _PaletteSwatch extends StatelessWidget {
  final ShareImageTheme theme;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _PaletteSwatch({
    required this.theme,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? colorScheme.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.outlineVariant),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, .55, .55, 1],
                  colors: [theme.background, theme.background, theme.accent, theme.accent],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An outlined rectangle in the shape of a canvas size.
class _RatioIcon extends StatelessWidget {
  final Size size;

  const _RatioIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    const height = 16.0;
    final color = IconTheme.of(context).color;
    return Container(
      width: height * size.width / size.height,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color ?? Colors.grey, width: 1.6),
      ),
    );
  }
}
