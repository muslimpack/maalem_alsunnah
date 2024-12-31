// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class HadithEntity extends Equatable {
  final int id;
  final int titleId;
  final int contentId;
  final int orderId;
  final int count;
  final String text;
  final String searchText;

  const HadithEntity({
    required this.id,
    required this.titleId,
    required this.contentId,
    required this.orderId,
    required this.count,
    required this.text,
    required this.searchText,
  });

  @override
  List<Object> get props {
    return [
      id,
      titleId,
      contentId,
      orderId,
      count,
      text,
      searchText,
    ];
  }
}
