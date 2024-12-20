import 'package:maalem_alsunnah/src/features/search/domain/entities/title_entity.dart';

class TitleModel extends TitleEntity {
  const TitleModel({
    required super.id,
    required super.name,
    required super.parentId,
    required super.subTitlesCount,
  });

  factory TitleModel.fromMap(Map<String, dynamic> map) {
    return TitleModel(
      id: map['id'] as int,
      name: map['name'] as String,
      parentId: num.parse((map['parentId'] as String?) ?? "-1") as int,
      subTitlesCount: map['subTitlesCount'] as int,
    );
  }
}
