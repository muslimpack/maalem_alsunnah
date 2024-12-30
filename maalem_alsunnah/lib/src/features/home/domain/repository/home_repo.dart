import 'package:hive/hive.dart';

class HomeRepo {
  final Box box;

  HomeRepo(this.box);

  /// Search Type
  static const String lastReadTitleIdKey = "lastReadTitleId";
  int? get lastReadTitleId {
    final data = box.get(lastReadTitleIdKey) as int?;

    return data;
  }

  Future setLastReadTitleId(int lastReadTitle) async {
    return box.put(lastReadTitleIdKey, lastReadTitle);
  }
}
