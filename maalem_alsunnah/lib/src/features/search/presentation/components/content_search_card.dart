// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';

class ContentSearchCard extends StatelessWidget {
  final ContentModel content;
  const ContentSearchCard({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.book_outlined),
        title: TitlesChainBreadCrumb(titleId: content.titleId),
        subtitle: Text(
          content.text,
          maxLines: 7,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
      ),
    );
  }
}
