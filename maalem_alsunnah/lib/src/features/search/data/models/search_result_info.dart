// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/src/features/search/data/models/search_header.dart';
import 'package:equatable/equatable.dart';

class SearchResultInfo extends Equatable {
  final SearchHeader total;
  final SearchHeader filtered;

  const SearchResultInfo({required this.total, required this.filtered});

  SearchResultInfo.empty()
      : total = SearchHeader.empty(),
        filtered = SearchHeader.empty();

  SearchResultInfo copyWith({
    SearchHeader? total,
    SearchHeader? filtered,
  }) {
    return SearchResultInfo(
      total: total ?? this.total,
      filtered: filtered ?? this.filtered,
    );
  }

  @override
  List<Object> get props => [total, filtered];
}
