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
  final TitleModel title;
  final ContentModel content;
  final RangeValues contentRange;

  int get contentCount => (contentRange.end - contentRange.start + 1).toInt();
  double get progress => content.id / contentCount;
  bool get hasPrevious => content.id > 1;
  bool get hasNext => content.id < contentCount - 1;

  const ContentViewerLoadedState({
    required this.title,
    required this.content,
    required this.contentRange,
  });

  @override
  List<Object> get props => [content, title, contentCount];

  ContentViewerLoadedState copyWith({
    TitleModel? title,
    ContentModel? content,
    RangeValues? contentRange,
  }) {
    return ContentViewerLoadedState(
      title: title ?? this.title,
      content: content ?? this.content,
      contentRange: contentRange ?? this.contentRange,
    );
  }
}

class ContentSubListViewerLoadedState extends ContentViewerState {
  final TitleModel title;
  final List<TitleModel> titles;

  const ContentSubListViewerLoadedState({
    required this.title,
    required this.titles,
  });

  @override
  List<Object> get props => [title, titles];

  ContentSubListViewerLoadedState copyWith({
    TitleModel? title,
    List<TitleModel>? titles,
  }) {
    return ContentSubListViewerLoadedState(
      title: title ?? this.title,
      titles: titles ?? this.titles,
    );
  }
}
