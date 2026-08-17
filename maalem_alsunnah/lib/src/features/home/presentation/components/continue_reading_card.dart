// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

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
          leading: FaIcon(
            title.subTitlesCount > 0
                ? FontAwesomeIcons.bookOpen
                : FontAwesomeIcons.book,
            size: 20,
          ),
          subtitle: Text(
            title.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          title: Text(S.of(context).continueReading),
          onTap: () {
            context.pushNamed(
              ContentViewerScreen.routeName,
              arguments: {"titleId": title.id, "viewAsContent": true},
            );
          },
        )
      ],
    );
  }
}
