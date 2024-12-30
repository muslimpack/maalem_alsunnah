// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/utils/email_manager.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith.dart';

class HadithCardPopupMenu extends StatelessWidget {
  final Hadith hadith;
  const HadithCardPopupMenu({
    super.key,
    required this.hadith,
  });

  Future report() async {
    EmailManager.sendMisspelled(hadith: hadith);
  }

  Future share(BuildContext context) async {
    // showShareDialog(context, hadith: hadith);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'report') {
          await report();
        } else if (value == 'share') {
          await share(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'report',
          child: ListTile(
            leading: const Icon(Icons.report_gmailerrorred),
            title: Text(S.of(context).reportMisspelled),
          ),
        ),
        PopupMenuItem<String>(
          value: 'share',
          child: ListTile(
            leading: const Icon(Icons.share),
            title: Text(S.of(context).share),
          ),
        ),
      ],
    );
  }
}
