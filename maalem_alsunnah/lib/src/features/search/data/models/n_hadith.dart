import 'package:maalem_alsunnah/src/features/search/domain/entities/n_hadith_entity.dart';

class Hadith extends NHadithEntity {
  const Hadith({
    required super.id,
    required super.titleId,
    required super.hadith,
  });

  factory Hadith.fromMap(Map<String, dynamic> map) {
    return Hadith(
      id: map['id'] as int,
      titleId: map['titleId'] as int,
      hadith: map['hadith'] as String,
    );
  }
}
