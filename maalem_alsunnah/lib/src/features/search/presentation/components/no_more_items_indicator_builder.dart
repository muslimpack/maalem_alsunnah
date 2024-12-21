// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

class NoMoreItemsIndicatorBuilder extends StatelessWidget {
  const NoMoreItemsIndicatorBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          S.of(context).noMoreResultsMsg,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
