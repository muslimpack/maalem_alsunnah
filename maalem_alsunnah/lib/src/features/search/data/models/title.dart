import 'package:maalem_alsunnah/src/features/search/domain/entities/title_entity.dart';

class Title extends TitleEntity {
  const Title({
    required super.id,
    required super.name,
    required super.parentId,
    required super.subTitlesCount,
  });

  factory Title.fromMap(Map<String, dynamic> map) {
    return Title(
      id: map['id'] as int,
      name: map['name'] as String,
      parentId: map['parentId'] as int,
      subTitlesCount: map['subTitlesCount'] as int,
    );
  }
}
