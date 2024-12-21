// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

class NoItemsFoundIndicatorBuilder extends StatelessWidget {
  final String searchText;
  const NoItemsFoundIndicatorBuilder({
    super.key,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search),
        const SizedBox(height: 10),
        Text(
          '${S.of(context).noResultsFound}\n"$searchText"',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
