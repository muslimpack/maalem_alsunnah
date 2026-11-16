import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_theme.dart';
import 'package:maalem_alsunnah/src/features/share/domain/share_image_layout.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/share_image_ornaments.dart';

/// Everything one page of the shared image shows, already resolved: the card
/// reads no app state, so it renders the same on screen and off screen.
class ShareImageCardData {
  final ShareImageTheme theme;
  final Size size;

  /// The page text, styled, as cut by [SharePageText.page].
  final TextSpan body;
  final TextAlign textAlign;

  /// The title chain joined into one line, or `null` to leave it out.
  final String? titleChain;

  final int pageIndex;
  final int pageCount;

  /// Shown on the last page only.
  final String? readingTime;

  final String appName;
  final String hashtag;
  final String pageLabel;
  final String continuedLabel;

  const ShareImageCardData({
    required this.theme,
    required this.size,
    required this.body,
    required this.textAlign,
    required this.titleChain,
    required this.pageIndex,
    required this.pageCount,
    required this.readingTime,
    required this.appName,
    required this.hashtag,
    required this.pageLabel,
    required this.continuedLabel,
  });

  bool get isLastPage => pageIndex == pageCount - 1;
}

/// One page of the shared image, drawn at its full canvas size.
class ShareImageCard extends StatelessWidget {
  final ShareImageCardData data;

  const ShareImageCard({super.key, required this.data});

  static const String _appIcon = "assets/images/app_icon.png";
  static const String _pattern = "assets/images/grid.png";

  /// The images the card draws, for precaching before an off-screen render.
  static const List<String> assetImages = [_appIcon, _pattern];

  @override
  Widget build(BuildContext context) {
    final theme = data.theme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTextStyle(
        style: TextStyle(
          inherit: false,
          fontFamily: ShareImageLayout.bodyFontFamily,
          fontSize: 28,
          height: 1.3,
          color: theme.text,
          letterSpacing: 0,
          textBaseline: TextBaseline.alphabetic,
        ),
        child: SizedBox.fromSize(
          size: data.size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: theme.background),
              Image.asset(
                _pattern,
                repeat: ImageRepeat.repeat,
                color: theme.text.withValues(alpha: theme.patternOpacity),
                colorBlendMode: BlendMode.srcIn,
              ),
              // Keep the pattern to the edges, clear behind the text.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: .95,
                    stops: const [.35, 1],
                    colors: [
                      theme.background,
                      theme.background.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                painter: OrnamentFramePainter(
                  color: theme.ornament,
                  background: theme.background,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ShareImageLayout.paddingHorizontal,
                  ShareImageLayout.paddingTop,
                  ShareImageLayout.paddingHorizontal,
                  ShareImageLayout.paddingBottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (data.titleChain case final titleChain?) ...[
                      SizedBox(
                        height: ShareImageLayout.titleHeight,
                        child: Center(
                          child: Text(
                            titleChain,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.noScaling,
                            style: TextStyle(
                              fontSize: 32,
                              height: 1.5,
                              color: theme.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: ShareImageLayout.titleGap),
                    ],
                    SizedBox(
                      height: ShareImageLayout.dividerHeight,
                      child: OrnamentDivider(
                        color: theme.ornament,
                        background: theme.background,
                      ),
                    ),
                    const SizedBox(height: ShareImageLayout.headerGap),
                    // Stretched, so the text gets the same fixed width the
                    // paginator measured it at.
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RichText(
                            text: data.body,
                            textAlign: data.textAlign,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: ShareImageLayout.footerGap),
                    SizedBox(
                      height: ShareImageLayout.footerHeight,
                      child: _Footer(data: data),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final ShareImageCardData data;

  const _Footer({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = data.theme;
    final mutedStyle = TextStyle(fontSize: 26, color: theme.mutedText);

    Widget? status;
    if (data.isLastPage && data.readingTime != null) {
      status = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 30, color: theme.accent),
          const SizedBox(width: 8),
          Text(data.readingTime!, style: mutedStyle, textScaler: TextScaler.noScaling),
        ],
      );
    } else if (!data.isLastPage) {
      status = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(data.continuedLabel, style: mutedStyle, textScaler: TextScaler.noScaling),
          const SizedBox(width: 8),
          // Mirrors under RTL, so it points to the next page on the left.
          Icon(Icons.arrow_forward, size: 26, color: theme.accent),
        ],
      );
    }

    return Row(
      children: [
        Image.asset(ShareImageCard._appIcon, height: 76),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.appName,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: theme.accent,
              ),
            ),
            Text(
              data.hashtag,
              textScaler: TextScaler.noScaling,
              // The book font has no underscore, which hashtags are made of.
              style: TextStyle(fontFamily: 'kitab', fontSize: 22, color: theme.mutedText),
            ),
          ],
        ),
        const Spacer(),
        if (status != null) status,
        if (data.pageCount > 1) ...[
          const SizedBox(width: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: theme.ornament, width: 1.5),
            ),
            child: Text(
              data.pageLabel,
              textScaler: TextScaler.noScaling,
              style: TextStyle(fontSize: 26, color: theme.accent),
            ),
          ),
        ],
      ],
    );
  }
}
