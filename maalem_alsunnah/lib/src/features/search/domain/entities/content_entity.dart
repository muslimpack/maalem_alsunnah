// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ContentEntity extends Equatable {
  final int id;
  final int titleId;
  final String text;
  final String searchText;

  const ContentEntity({
    required this.id,
    required this.titleId,
    required this.text,
    required this.searchText,
  });

  @override
  List<Object> get props => [id, titleId, text, searchText];
}