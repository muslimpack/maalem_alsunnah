// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/core/functions/show_toast.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/screens/share_as_image_screen.dart';
import 'package:share_plus/share_plus.dart';

Future showShareDialog(BuildContext context,
    {required int itemId, required ShareType shareType}) {
  return showDialog(
    context: context,
    builder: (context) {
      return ShareDialog(itemId: itemId, shareType: shareType);
    },
  );
}

class ShareDialog extends StatefulWidget {
  final int itemId;
  final ShareType shareType;
  const ShareDialog({
    super.key,
    required this.itemId,
    required this.shareType,
  });

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  final StringBuffer sb = StringBuffer();
  bool isLoading = true;
  late ContentModel content;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    switch (widget.shareType) {
      case ShareType.content:
        content = await sl<HadithDbHelper>().getContentById(widget.itemId);
      case ShareType.hadith:

        ///TODO
        break;
    }

    await perpareSharedText();
    setState(() {
      isLoading = false;
    });
  }

  Future perpareSharedText() async {
    switch (widget.shareType) {
      case ShareType.content:
        sb.write(content.text);
      case ShareType.hadith:

        ///TODO
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              context.pushNamed(
                ShareAsImageScreen.routeName,
                arguments: {
                  "itemId": widget.itemId,
                  "shareType": widget.shareType
                },
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
