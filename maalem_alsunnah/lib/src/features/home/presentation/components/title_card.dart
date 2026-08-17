// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/bookmark_button.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
    this.viewAsContent = false,
  });

  final TitleModel title;
  final bool viewAsContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        onTap: () {
          context.pushNamed(
            ContentViewerScreen.routeName,
            arguments: {"titleId": title.id, "viewAsContent": title.subTitlesCount == 0},
          );
        },
        leading: FaIcon(
          title.subTitlesCount > 0
              ? FontAwesomeIcons.bookOpen
              : FontAwesomeIcons.book,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        title: Text(title.name),
        subtitle: title.subTitlesCount < 1 ? null : Text("عدد الفصول: ${title.subTitlesCount}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BookmarkButton(itemId: title.id.toString(), type: BookmarkType.title),
            const Icon(Icons.chevron_right_outlined),
          ],
        ),
      ),
    );
  }
}
