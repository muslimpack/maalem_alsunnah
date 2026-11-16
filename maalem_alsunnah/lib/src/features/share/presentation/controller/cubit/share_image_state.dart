part of 'share_image_cubit.dart';

sealed class ShareImageState extends Equatable {
  const ShareImageState();

  @override
  List<Object?> get props => [];
}

final class ShareImageLoadingState extends ShareImageState {}

typedef ShareImageProgress = ({int current, int total});

class ShareImageLoadedState extends ShareImageState {
  final String itemId;
  final ShareType shareType;

  /// The whole text being shared, and the titles it sits under.
  final String text;
  final List<TitleModel> titleChain;

  final ShareImageSettings settings;
  final ShareImageTheme theme;
  final ShareImagePagination pagination;
  final int activeIndex;

  /// Set while images are being rendered and saved.
  final ShareImageProgress? progress;

  const ShareImageLoadedState({
    required this.itemId,
    required this.shareType,
    required this.text,
    required this.titleChain,
    required this.settings,
    required this.theme,
    required this.pagination,
    required this.activeIndex,
    required this.progress,
  });

  int get pageCount => pagination.pages.length;
  bool get isExporting => progress != null;

  /// Whether the card has a title line: wanted, and there is one to show.
  bool get showsTitleChain => settings.showTitleChain && titleChain.isNotEmpty;

  @override
  List<Object?> get props => [
        itemId,
        shareType,
        text,
        titleChain,
        settings,
        theme,
        pagination,
        activeIndex,
        progress,
      ];

  ShareImageLoadedState copyWith({
    ShareImageSettings? settings,
    ShareImageTheme? theme,
    ShareImagePagination? pagination,
    int? activeIndex,
    Wrapped<ShareImageProgress?>? progress,
  }) {
    return ShareImageLoadedState(
      itemId: itemId,
      shareType: shareType,
      text: text,
      titleChain: titleChain,
      settings: settings ?? this.settings,
      theme: theme ?? this.theme,
      pagination: pagination ?? this.pagination,
      activeIndex: activeIndex ?? this.activeIndex,
      progress: progress != null ? progress.value : this.progress,
    );
  }
}
