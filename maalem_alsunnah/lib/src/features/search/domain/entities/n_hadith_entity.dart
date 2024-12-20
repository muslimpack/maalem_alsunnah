// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class NHadithEntity extends Equatable {
  final int id;
  final int titleId;
  final String hadith;

  const NHadithEntity({
    required this.id,
    required this.titleId,
    required this.hadith,
  });

  @override
  List<Object> get props => [id, titleId, hadith];
}
