// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/core/functions/show_toast.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/screens/share_as_image_screen.dart';
import 'package:share_plus/share_plus.dart';

Future showShareDialog(BuildContext context, {required Hadith hadith}) {
  return showDialog(
    context: context,
    builder: (context) {
      return ShareDialog(hadith: hadith);
    },
  );
}

class ShareDialog extends StatelessWidget {
  final Hadith hadith;
  const ShareDialog({
    super.key,
    required this.hadith,
  });

  @override
  Widget build(BuildContext context) {
    final StringBuffer sb = StringBuffer();
    sb.write(hadith.narrator);
    if (hadith.narratorReference.isNotEmpty) {
      sb.write(" (${hadith.narratorReference})");
    }
    sb.write("\n\n-------\n\n");
    sb.write(hadith.hadith);
    sb.write("\n\n-------\n\n");
    sb.write("المرتبة: ${hadith.rank}");
    sb.write("\n\n${S.of(context).appHashtag}");

    final shareText = sb.toString();

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: AlertDialog(
        scrollable: true,
        title: Text(S.of(context).share),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 350),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Text(shareText),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: S.of(context).shareAsImage,
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {
              context.push(
                ShareAsImageScreen(
                  hadith: hadith,
                ),
              );
            },
          ),
          IconButton(
            tooltip: S.of(context).copy,
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: shareText),
              );
              showToast(
                msg: S.current.copiedToClipboard,
              );
            },
          ),
          IconButton(
            tooltip: S.of(context).share,
            icon: const Icon(Icons.share),
            onPressed: () async {
              await Share.share(shareText);
            },
          ),
        ],
      ),
    );
  }
}
