// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class ContinueReadingCard extends StatelessWidget {
  final TitleModel title;
  const ContinueReadingCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: 0.5,
        ),
        ListTile(
          leading: Icon(MdiIcons.bookOpenPageVariant),
          subtitle: Text(title.name),
          title: Text(S.of(context).continueReading),
        )
      ],
    );
  }
}
