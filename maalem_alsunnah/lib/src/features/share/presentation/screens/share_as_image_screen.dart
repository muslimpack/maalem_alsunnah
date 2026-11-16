import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/core/functions/show_toast.dart';
import 'package:maalem_alsunnah/src/core/utils/arabic_number.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/dot_bar.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/share_image_card.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/share_image_controls.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/controller/cubit/share_image_cubit.dart';

class ShareAsImageScreen extends StatelessWidget {
  final String itemId;
  final ShareType shareType;

  static const String routeName = "/shareAsImage";

  static Route route({required String itemId, required ShareType shareType}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
        arguments: {"itemId": itemId, "shareType": shareType},
      ),
      builder: (_) => ShareAsImageScreen(itemId: itemId, shareType: shareType),
    );
  }

  const ShareAsImageScreen({
    super.key,
    required this.itemId,
    required this.shareType,
  });

  @override
  Widget build(BuildContext context) {
    // Read here: a provider's create callback can't depend on the theme.
    final appBrightness = Theme.of(context).brightness;
    return BlocProvider(
      create: (_) => sl<ShareImageCubit>()
        ..start(
          itemId: itemId,
          shareType: shareType,
          appBrightness: appBrightness,
        ),
      child: const _ShareAsImageView(),
    );
  }
}

class _ShareAsImageView extends StatelessWidget {
  const _ShareAsImageView();

  /// Side-by-side preview and controls from this width.
  static const double _wideLayout = 840;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareImageCubit, ShareImageState>(
      builder: (context, state) {
        final appBar = AppBar(
          title: Text(S.of(context).shareAsImage),
          centerTitle: true,
        );

        if (state is! ShareImageLoadedState) {
          return Scaffold(
            appBar: appBar,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final colorScheme = Theme.of(context).colorScheme;
        final controls = ShareImageControls(
          state: state,
          onExport: ({required all, origin}) => _export(context, all: all, origin: origin),
        );

        return Scaffold(
          appBar: appBar,
          backgroundColor: colorScheme.surfaceContainerLowest,
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= _wideLayout) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _Preview(state: state)),
                      Material(
                        color: colorScheme.surfaceContainerLow,
                        child: SizedBox(
                          width: 400,
                          child: SingleChildScrollView(child: controls),
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Expanded(child: _Preview(state: state)),
                    Material(
                      color: colorScheme.surfaceContainerLow,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: controls,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _export(BuildContext context, {required bool all, Rect? origin}) async {
    final cubit = context.read<ShareImageCubit>();
    final state = cubit.state;
    if (state is! ShareImageLoadedState) return;

    // Off-screen pages can't wait for images to load, so load them first.
    await Future.wait([
      for (final asset in ShareImageCard.assetImages) precacheImage(AssetImage(asset), context),
    ]);
    if (!context.mounted) return;

    // Strings are resolved here, while there is a context; the off-screen
    // tree has no localizations.
    final pages = [
      for (var i = 0; i < state.pageCount; i++) shareImageCardData(context, state, i),
    ];
    final s = S.of(context);

    final result = await cubit.export(
      all: all,
      pageBuilder: (index) => ShareImageCard(data: pages[index]),
      shareOrigin: origin,
    );

    switch (result) {
      case ShareImageExportResult.saved:
        showToast(msg: s.shareImageSaved, type: ToastType.success);
      case ShareImageExportResult.failed:
        showToast(msg: s.shareImageFailed, type: ToastType.error);
      case ShareImageExportResult.shared || ShareImageExportResult.cancelled:
        break;
    }
  }
}

/// Everything the card of page [index] shows, resolved for the current
/// language.
ShareImageCardData shareImageCardData(
  BuildContext context,
  ShareImageLoadedState state,
  int index,
) {
  final s = S.of(context);
  final pagination = state.pagination;
  final count = state.pageCount;
  final isArabic = Localizations.localeOf(context).languageCode == "ar";

  String number(int n) => isArabic ? ArabicNumbers.convert("$n") : "$n";

  final readingTime = state.text.getArabicTextReadingTimeAsString(context);

  return ShareImageCardData(
    theme: state.theme,
    size: pagination.canvasSize,
    body: pagination.source.page(pagination.pages[index]),
    // One page reads best centred; split pages read as a block.
    textAlign: count == 1 ? TextAlign.center : TextAlign.justify,
    titleChain: state.showsTitleChain ? state.titleChain.map((t) => t.name).join(" » ") : null,
    pageIndex: index,
    pageCount: count,
    readingTime: readingTime == null ? null : "${s.readingTime}: $readingTime",
    appName: s.appTitle,
    hashtag: s.appHashtag,
    pageLabel: "${number(index + 1)} / ${number(count)}",
    continuedLabel: s.shareImageContinued,
  );
}

class _Preview extends StatelessWidget {
  final ShareImageLoadedState state;

  const _Preview({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareImageCubit>();
    final size = state.pagination.canvasSize;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: cubit.pageController,
            itemCount: state.pageCount,
            onPageChanged: cubit.onPageChanged,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: AspectRatio(
                      // Re-animate when the size changes.
                      key: ValueKey(size),
                      aspectRatio: size.width / size.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .18),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FittedBox(
                            child: ShareImageCard(
                              data: shareImageCardData(context, state, index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Page dots, and the size the image comes out at (useful with Auto).
        SizedBox(
          height: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.pageCount > 1) ...[
                DotBar(
                  length: state.pageCount,
                  activeIndex: state.activeIndex,
                  dotColor: colorScheme.primary,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                state.pagination.aspect.ratioLabel,
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
