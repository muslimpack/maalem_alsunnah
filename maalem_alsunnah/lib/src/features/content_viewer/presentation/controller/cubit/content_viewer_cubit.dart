// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

part 'content_viewer_state.dart';

class ContentViewerCubit extends Cubit<ContentViewerState> {
  final HadithDbHelper hadithDbHelper;
  final HomeCubit homeCubit;
  Timer? _timer;
  ContentViewerCubit(
    this.hadithDbHelper,
    this.homeCubit,
  ) : super(ContentViewerLoadingState());

  void _timePassed(Timer timer) {
    final state = this.state;
    if (state is! ContentViewerLoadedState) return;
    homeCubit.updateLastReadTitle(state.content.titleId);
  }

  Future<void> start(int titleId) async {
    _timer?.cancel();

    final title = (await hadithDbHelper.getTitleById(titleId))!;
    if (title.subTitlesCount == 0) {
      _timer = Timer.periodic(const Duration(seconds: 5), _timePassed);
      final content = await hadithDbHelper.getContentByTitleId(titleId);
      final contentCount = await hadithDbHelper.getContentCount();

      emit(
        ContentViewerLoadedState(
          title: title,
          content: content,
          contentCount: contentCount,
        ),
      );
    } else {
      final titles = await hadithDbHelper.getSubTitlesByTitleId(titleId);
      emit(
        ContentSubListViewerLoadedState(
          title: title,
          titles: titles,
        ),
      );
    }
  }

  Future<void> nextContent() async {
    goToContent(1);
  }

  Future<void> previousContent() async {
    goToContent(-1);
  }

  Future<void> goToContent(int by) async {
    final state = this.state;
    if (state is! ContentViewerLoadedState) return;

    final contentId = state.content.id;
    if (contentId > 1 && contentId < state.contentCount) {
      final ContentModel nextContent =
          await hadithDbHelper.getContentById(contentId + by);
      start(nextContent.titleId);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
