import 'package:maalem_alsunnah/src/features/search/domain/entities/title_entity.dart';

class TitleModel extends TitleEntity {
  const TitleModel({
    required super.id,
    required super.name,
    required super.parentId,
    required super.subTitlesCount,
    required super.orderId,
  });

  factory TitleModel.fromMap(Map<String, dynamic> map) {
    return TitleModel(
      id: map['id'] as int,
      orderId: map['orderId'] as int,
      name: map['name'] as String,
      parentId: (map['parentId'] as int?) ?? -1,
      subTitlesCount: map['subTitlesCount'] as int,
    );
  }
}
