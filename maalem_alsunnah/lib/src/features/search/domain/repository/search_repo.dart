import 'package:hive/hive.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_for.dart';
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

  /// Search for
  static const String searchForKey = "searchFor";
  SearchFor get searchFor {
    final data = box.get(searchForKey) as String?;
    if (data == null) return SearchFor.title;
    return SearchFor.fromString(data);
  }

  Future setSearchFor(SearchFor searchFor) async {
    return box.put(searchForKey, searchType.name);
  }
}
