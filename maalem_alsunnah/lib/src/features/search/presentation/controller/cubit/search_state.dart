// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchLoadedState extends SearchState {
  final String searchText;
  final SearchType searchType;
  final SearchForType searchForType;

  int get pageSize => 10;

  const SearchLoadedState({
    required this.searchText,
    required this.searchType,
    required this.searchForType,
  });

  @override
  List<Object> get props => [searchText, searchType, searchForType];

  SearchLoadedState copyWith({
    String? searchText,
    SearchType? searchType,
    SearchForType? searchForType,
  }) {
    return SearchLoadedState(
      searchText: searchText ?? this.searchText,
      searchType: searchType ?? this.searchType,
      searchForType: searchForType ?? this.searchForType,
    );
  }
}
