import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/utils/email_manager.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/share_dialog.dart';

class HadithCardPopupMenu extends StatelessWidget {
  final HadithModel hadith;
  const HadithCardPopupMenu({
    super.key,
    required this.hadith,
  });

  Future report() async {
    EmailManager.sendMisspelled(hadith: hadith);
  }

  Future share(BuildContext context) async {
    showShareDialog(context, shareType: ShareType.hadith, itemId: hadith.id);
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
