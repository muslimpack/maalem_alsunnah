// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'share_image_cubit.dart';

sealed class ShareImageState extends Equatable {
  const ShareImageState();

  @override
  List<Object> get props => [];
}

final class ShareImageLoadingState extends ShareImageState {}

class ShareImageLoadedState extends ShareImageState {
  final Hadith hadith;
  final bool showLoadingIndicator;
  final List<TextRange> splittedMatn;
  final HadithImageCardSettings settings;
  final int activeIndex;
  const ShareImageLoadedState({
    required this.hadith,
    required this.showLoadingIndicator,
    required this.splittedMatn,
    required this.settings,
    required this.activeIndex,
  });

  @override
  List<Object> get props => [
        showLoadingIndicator,
        hadith,
        settings,
        splittedMatn,
        activeIndex,
      ];

  ShareImageLoadedState copyWith({
    Hadith? hadith,
    bool? showLoadingIndicator,
    List<TextRange>? splittedMatn,
    HadithImageCardSettings? settings,
    int? activeIndex,
  }) {
    return ShareImageLoadedState(
      hadith: hadith ?? this.hadith,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      splittedMatn: splittedMatn ?? this.splittedMatn,
      settings: settings ?? this.settings,
      activeIndex: activeIndex ?? this.activeIndex,
    );
  }
}
