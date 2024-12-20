// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/src/features/home/data/models/hadith_ruling_enum.dart';
import 'package:equatable/equatable.dart';

class SearchHeader extends Equatable {
  static String get query {
    return "COUNT(*) AS searchResultLength, "
        "${HadithRulingEnum.values.map((e) => "SUM(CASE WHEN ruling LIKE '%${e.title}%' THEN 1 ELSE 0 END) AS ${e.title}").join(",")}";
  }

  final int searchResultLength;
  final Map<HadithRulingEnum, int> rulingStats;

  const SearchHeader({
    required this.searchResultLength,
    required this.rulingStats,
  });

  SearchHeader.empty()
      : searchResultLength = 0,
        rulingStats = HadithRulingEnum.values
            .fold({}, (previousValue, element) => previousValue..[element] = 0);

  @override
  List<Object> get props => [
        searchResultLength,
        rulingStats,
      ];

  factory SearchHeader.fromMap(Map<String, dynamic> map) {
    final rulingStats =
        map.entries.fold<Map<HadithRulingEnum, int>>({}, (previousValue, e) {
      final r = HadithRulingEnum.values
          .where((element) => element.title == e.key)
          .firstOrNull;

      if (r == null) return previousValue;

      return previousValue..[r] = e.value as int? ?? 0;
    });

    return SearchHeader(
      searchResultLength: map['searchResultLength'] as int,
      rulingStats: rulingStats,
    );
  }

  SearchHeader copyWith({
    int? searchResultLength,
    Map<HadithRulingEnum, int>? rulingStats,
  }) {
    return SearchHeader(
      searchResultLength: searchResultLength ?? this.searchResultLength,
      rulingStats: rulingStats ?? this.rulingStats,
    );
  }
}
