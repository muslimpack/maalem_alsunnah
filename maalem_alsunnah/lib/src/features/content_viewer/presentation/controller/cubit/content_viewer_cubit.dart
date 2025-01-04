// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

part 'content_viewer_state.dart';

class ContentViewerCubit extends Cubit<ContentViewerState> {
  final HadithDbHelper hadithDbHelper;
  final HomeCubit homeCubit;
  final ScrollController scrollController = ScrollController();
  final PageController pageController = PageController();
  Timer? _timer;
  ContentViewerCubit(
    this.hadithDbHelper,
    this.homeCubit,
  ) : super(ContentViewerLoadingState()) {
    pageController.addListener(_onPageChanged);
  }

  void _timePassed(Timer timer, int titleId) async {
    final state = this.state;
    if (state is! ContentViewerLoadedState) return;
    await homeCubit.updateLastReadTitle(titleId);
    _timer?.cancel();
  }

  Future<void> _onPageChanged() async {
    if (pageController.page!.toInt() != pageController.page!) {
      return;
    }

    appPrint("page changed: ${pageController.page}");

    final state = this.state;
    if (state is! ContentViewerLoadedState) return;
    final orderId = pageController.page!.toInt() + 1;
    if (orderId == state.content.orderId) return;

    final content = await hadithDbHelper.getContentByOrderId(orderId);
    startByContent(content.id);
  }

  Future<void> start(int titleId, {bool? isContent}) async {
    final tempTitle = await hadithDbHelper.getTitleById(titleId);

    if (tempTitle == null) {
      final state = this.state;
      if (state is ContentViewerLoadedState) {
        start(state.content.titleId, isContent: isContent);
      }
      return;
    }

    final title = tempTitle;
    if (title.subTitlesCount == 0 || isContent == true) {
      _startContent(title);
    } else {
      _startTitle(title);
    }
  }

  Future<void> startByContent(int contentId) async {
    final content = await hadithDbHelper.getContentById(contentId);
    final tempTitle = await hadithDbHelper.getTitleById(content.titleId);

    if (tempTitle == null) {
      return;
    }

    final title = tempTitle;
    _startContent(title);
  }

  Future _startContent(TitleModel title) async {
    _timer?.cancel();
    _timer = Timer.periodic(
        const Duration(seconds: 5), (t) => _timePassed(t, title.id));

    final content = await hadithDbHelper.getContentByTitleId(title.id);
    final contentRange = await hadithDbHelper.getContentRange();

    emit(
      ContentViewerLoadedState(
        title: title,
        content: content,
        contentRange: contentRange,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 100));

    if (pageController.hasClients) {
      await pageController.animateToPage(
        content.orderId - 1,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future _startTitle(TitleModel title) async {
    final titles = await hadithDbHelper.getSubTitlesByTitleId(title.id);
    emit(
      ContentSubListViewerLoadedState(
        title: title,
        titles: titles,
      ),
    );
  }

  Future<void> nextContent() async {
    pageController.nextPage(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> previousContent() async {
    pageController.previousPage(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> goToContent(int orderId) async {
    final state = this.state;
    if (state is! ContentViewerLoadedState) return;

    if (pageController.hasClients) {
      pageController.animateToPage(
        orderId - 1,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    scrollController.dispose();
    pageController.dispose();
    return super.close();
  }
}
