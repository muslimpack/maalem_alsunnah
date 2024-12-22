// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'share_image_cubit.dart';

sealed class ShareImageState extends Equatable {
  const ShareImageState();

  @override
  List<Object> get props => [];
}

final class ShareImageLoadingState extends ShareImageState {}

class ShareImageLoadedState extends ShareImageState {
  final int itemId;
  final ShareType shareType;
  final bool showLoadingIndicator;
  final List<TextRange> splittedMatn;
  final HadithImageCardSettings settings;
  final int activeIndex;
  final List imageCardArgs;
  const ShareImageLoadedState({
    required this.itemId,
    required this.shareType,
    required this.showLoadingIndicator,
    required this.splittedMatn,
    required this.settings,
    required this.activeIndex,
    required this.imageCardArgs,
  });

  @override
  List<Object> get props => [
        showLoadingIndicator,
        shareType,
        itemId,
        settings,
        splittedMatn,
        activeIndex,
        imageCardArgs,
      ];

  ShareImageLoadedState copyWith({
    int? itemId,
    ShareType? shareType,
    bool? showLoadingIndicator,
    List<TextRange>? splittedMatn,
    HadithImageCardSettings? settings,
    int? activeIndex,
    List? imageCardArgs,
  }) {
    return ShareImageLoadedState(
      itemId: itemId ?? this.itemId,
      shareType: shareType ?? this.shareType,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      splittedMatn: splittedMatn ?? this.splittedMatn,
      settings: settings ?? this.settings,
      activeIndex: activeIndex ?? this.activeIndex,
      imageCardArgs: imageCardArgs ?? this.imageCardArgs,
    );
  }
}
