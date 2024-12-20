import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/features/home/data/models/hadith_ruling_enum.dart';
import 'package:maalem_alsunnah/src/features/search/domain/entities/hadith_entity.dart';

class Hadith extends HadithEntity {
  const Hadith({
    required super.id,
    required super.srcBookId,
    required super.narrator,
    required super.narratorReference,
    required super.rank,
    required super.rulingEnum,
    required super.hadith,
  });

  factory Hadith.fromMap(Map<String, dynamic> map) {
    final narrator = map['narrator'] as String? ?? "";
    final narratorReference =
        (map['narratorReference'] as String? ?? "").removeBrackets();
    return Hadith(
      id: map['id'] as int,
      srcBookId: map['srcBookId'] as int,
      narrator: narrator,
      narratorReference: narratorReference,
      rank: (map['rank'] as String).removeBrackets(),
      rulingEnum: HadithRulingEnum.fromString(map['ruling'] as String),
      hadith: map['hadith'] as String,
    );
  }
}
