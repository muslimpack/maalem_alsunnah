import 'package:maalem_alsunnah/src/features/search/domain/entities/content_entity.dart';

class ContentModel extends ContentEntity {
  const ContentModel({
    required super.id,
    required super.titleId,
    required super.text,
    required super.searchText,
  });

  factory ContentModel.fromMap(Map<String, dynamic> map) {
    return ContentModel(
      id: map['id'] as int,
      titleId: map['titleId'] as int,
      text: map['text'] as String,
      searchText: map['searchText'] as String,
    );
  }
}
