import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/core/functions/open_url.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aboutApp),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const SizedBox(height: 15),
          ListTile(
            leading: Image.asset(
              "assets/images/app_icon2.png",
            ),
            title: Text("${S.of(context).appTitle} $kAppVersion"),
            subtitle: Text(S.of(context).freeAdFreeAndOpenSourceApp),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.handshake),
            title: Text(S.of(context).prayForUsAndParents),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.source_outlined),
            title: Text(S.of(context).source),
            isThreeLine: true,
            subtitle: Text("""
${S.of(context).hadithBookSource}
${S.of(context).hadithBookSourceDesc}
"""),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(S.of(context).sourceBookAuthor),
            isThreeLine: true,
            subtitle: Text("""
${S.of(context).hadithBookAuthor}
${S.of(context).hadithBookAuthorDesc}
"""),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: Text(S.of(context).github),
            onTap: () {
              openURL("https://github.com/muslimpack/maalem_alsunnah");
            },
          ),
        ],
      ),
    );
  }
}
