import 'package:maalem_alsunnah/src/features/search/domain/entities/hadith_entity.dart';

class HadithModel extends HadithEntity {
  const HadithModel({
    required super.id,
    required super.titleId,
    required super.contentId,
    required super.orderId,
    required super.count,
    required super.text,
    required super.searchText,
  });

  factory HadithModel.fromMap(Map<String, dynamic> map) {
    return HadithModel(
      id: (map['id'] as int?) ?? -1,
      titleId: map['titleId'] as int,
      contentId: map['contentId'] as int,
      orderId: map['contentId'] as int,
      count: (map['count'] as int?) ?? 0,
      text: map['text'] as String,
      searchText: map['searchText'] as String,
    );
  }
}
