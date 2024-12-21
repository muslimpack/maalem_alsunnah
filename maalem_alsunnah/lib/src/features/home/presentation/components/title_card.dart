// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/sub_titles_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
  });

  final TitleModel title;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        onTap: () {
          if (title.subTitlesCount == 0) {
            context.pushNamed(
              ContentViewerScreen.routeName,
              arguments: title,
            );
          } else {
            context.pushNamed(
              SubTitlesViewerScreen.routeName,
              arguments: title,
            );
          }
        },
        leading: Icon(
          MdiIcons.bookOpenPageVariant,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title.name),
        subtitle: Text("عدد الفصول: ${title.subTitlesCount}"),
        trailing: Icon(Icons.chevron_right_outlined),
      ),
    );
  }
}
