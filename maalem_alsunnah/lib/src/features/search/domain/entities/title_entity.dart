// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TitleEntity extends Equatable {
  final int id;
  final String name;
  final int parentId;
  final int subTitlesCount;

  const TitleEntity({
    required this.id,
    required this.name,
    required this.parentId,
    required this.subTitlesCount,
  });

  @override
  List<Object> get props => [id, name, parentId, subTitlesCount];
}
