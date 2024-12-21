// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_for.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_type.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/search/domain/repository/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TextEditingController searchController = TextEditingController();
  final PagingController<int, TitleModel> titlePagingController =
      PagingController(firstPageKey: 0);

  final HadithDbHelper hadithDbHelper;
  final SearchRepo searchRepo;

  SearchCubit(
    this.hadithDbHelper,
    this.searchRepo,
  ) : super(const SearchLoadingState()) {
    titlePagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future start() async {
    final state = SearchLoadedState(
      searchText: "",
      searchType: searchRepo.searchType,
      searchFor: searchRepo.searchFor,
    );
    emit(state);
  }

  ///MARK: Search header
  Future _startNewSearch() async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    titlePagingController.refresh();
  }

  ///MARK: Search text

  Future updateSearchText(String searchText) async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    emit(
      state.copyWith(
        searchText: searchText,
      ),
    );
    await _startNewSearch();
  }

  ///MARK: SearchType
  Future changeSearchType(SearchType searchType) async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    await searchRepo.setSearchType(searchType);

    emit(state.copyWith(searchType: searchType));
    await _startNewSearch();
  }

  ///MARK: Search For
  Future changeSearchFor(SearchFor searchFor) async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    await searchRepo.setSearchFor(searchFor);

    emit(state.copyWith(searchFor: searchFor));
    await _startNewSearch();
  }

  ///MARK: clear
  Future clear() async {
    searchController.clear();
    await updateSearchText("");
  }

  ///MARK: Pagination
  Future _fetchPage(int pageKey) async {
    final state = this.state;

    if (state is! SearchLoadedState) return;

    final pageSize = state.pageSize;
    final searchText = state.searchText;

    try {
      final newItems = await hadithDbHelper.searchTitleByName(
        searchText: searchText,
        searchType: state.searchType,
        limit: pageSize,
        offset: pageKey,
      );

      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        titlePagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        titlePagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      titlePagingController.error = error;
    }
  }

  ///MARK: close
  @override
  Future<void> close() {
    titlePagingController.dispose();
    searchController.dispose();
    return super.close();
  }
}
