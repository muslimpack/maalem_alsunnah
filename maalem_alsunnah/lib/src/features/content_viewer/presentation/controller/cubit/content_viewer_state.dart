// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'content_viewer_cubit.dart';

sealed class ContentViewerState extends Equatable {
  const ContentViewerState();

  @override
  List<Object> get props => [];
}

final class ContentViewerLoadingState extends ContentViewerState {
  @override
  List<Object> get props => [];
}

class ContentViewerLoadedState extends ContentViewerState {
  final ContentModel content;
  final int contentCount;

  double get progress => content.id / contentCount;
  bool get hasPrevious => content.id > 2;
  bool get hasNext => content.id < contentCount - 1;

  const ContentViewerLoadedState({
    required this.content,
    required this.contentCount,
  });

  @override
  List<Object> get props => [content];

  ContentViewerLoadedState copyWith({
    ContentModel? content,
    int? contentCount,
  }) {
    return ContentViewerLoadedState(
      content: content ?? this.content,
      contentCount: contentCount ?? this.contentCount,
    );
  }
}
