// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/bread_crumb_item_builder.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class TitlesChainBreadCrumbBuilder extends StatelessWidget {
  final List<TitleModel> titlesChains;
  final Function(int index, TitleModel title) onPressed;

  const TitlesChainBreadCrumbBuilder({
    super.key,
    required this.titlesChains,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BreadCrumb.builder(
        itemCount: titlesChains.length,
        builder: (index) {
          return BreadCrumbItem(
            content: BreadCrumbItemBuilder(
              index: index,
              titlesChains: titlesChains,
              onPressed: onPressed,
            ),
          );
        },
        divider: Text(
          '/',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
