import 'package:hive/hive.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_type.dart';

class SearchRepo {
  final Box box;

  SearchRepo(this.box);

  /// Search Type
  static const String searchTypeKey = "searchType";
  SearchType get searchType {
    final data = box.get(searchTypeKey) as String?;
    if (data == null) return SearchType.typical;
    return SearchType.fromString(data);
  }

  Future setSearchType(SearchType searchType) async {
    return box.put(searchTypeKey, searchType.name);
  }
}
