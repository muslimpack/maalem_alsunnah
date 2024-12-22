// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ContinueReadingCard extends StatelessWidget {
  final TitleModel title;
  final double progress;
  const ContinueReadingCard({
    super.key,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: progress,
        ),
        ListTile(
          leading: Icon(MdiIcons.bookOpenPageVariant),
          subtitle: Text(title.name),
          title: Text(S.of(context).continueReading),
          onTap: () {
            context.pushNamed(
              ContentViewerScreen.routeName,
              arguments: title.id,
            );
          },
        )
      ],
    );
  }
}
