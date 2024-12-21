import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({
    super.key,
  });

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
          subtitle: Text("lorem ipsum"),
          title: Text(S.of(context).continueReading),
        )
      ],
    );
  }
}
