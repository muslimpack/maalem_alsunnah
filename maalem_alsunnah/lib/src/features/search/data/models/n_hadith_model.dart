import 'package:maalem_alsunnah/src/features/search/domain/entities/n_hadith_entity.dart';

class NHadithModel extends NHadithEntity {
  const NHadithModel({
    required super.id,
    required super.titleId,
    required super.hadith,
  });

  factory NHadithModel.fromMap(Map<String, dynamic> map) {
    return NHadithModel(
      id: map['id'] as int,
      titleId: map['titleId'] as int,
      hadith: map['hadith'] as String,
    );
  }
}
