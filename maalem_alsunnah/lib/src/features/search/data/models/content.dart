import 'package:maalem_alsunnah/src/features/search/domain/entities/content_entity.dart';

class Content extends ContentEntity {
  const Content({
    required super.id,
    required super.titleId,
    required super.text,
    required super.searchText,
  });

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'] as int,
      titleId: map['titleId'] as int,
      text: map['text'] as String,
      searchText: map['searchText'] as String,
    );
  }
}
