// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class BreadCrumbItemBuilder extends StatelessWidget {
  final int index;
  final List<TitleModel> titlesChains;
  final Function(int index, TitleModel title)? onPressed;
  const BreadCrumbItemBuilder({
    super.key,
    required this.index,
    required this.titlesChains,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final title = titlesChains[index];

    if (index == 0) {
      return TextButton(
        child: Text(
          title.name,
        ),
        onPressed: () {
          onPressed?.call(index, title);
        },
      );
    } else if (index == titlesChains.length - 1) {
      return TextButton(
        child: Text(
          title.name,
        ),
        onPressed: () {
          onPressed?.call(index, title);
        },
      );
    }
    return TextButton(
      child: Text(
        title.name,
      ),
      onPressed: () {
        onPressed?.call(index, title);
      },
    );
  }
}
