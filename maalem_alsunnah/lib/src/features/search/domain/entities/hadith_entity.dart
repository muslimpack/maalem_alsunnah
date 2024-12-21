import 'package:equatable/equatable.dart';

class HadithEntity extends Equatable {
  final int id;
  final int srcBookId;
  final String narrator;
  final String narratorReference;
  final String rank;
  final String hadith;

  const HadithEntity({
    required this.id,
    required this.srcBookId,
    required this.narrator,
    required this.narratorReference,
    required this.rank,
    required this.hadith,
  });

  @override
  List<Object> get props {
    return [
      id,
      srcBookId,
      narrator,
      narratorReference,
      rank,
      hadith,
    ];
  }
}
