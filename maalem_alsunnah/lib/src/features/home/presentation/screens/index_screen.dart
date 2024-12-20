// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/title_card.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class IndexScreen extends StatelessWidget {
  final List<TitleModel> maqassedList;

  const IndexScreen({
    super.key,
    required this.maqassedList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: maqassedList.length,
      itemBuilder: (context, index) {
        final title = maqassedList[index];
        return TitleCard(title: title);
      },
    );
  }
}
