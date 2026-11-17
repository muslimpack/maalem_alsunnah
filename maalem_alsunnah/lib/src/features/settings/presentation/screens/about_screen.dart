import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/core/extensions/safe_padding_extension.dart';
import 'package:maalem_alsunnah/src/core/functions/open_url.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/app_info.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/contact_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String routeName = "/about";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AboutScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aboutApp),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15).withSafeArea(context),
        children: [
          const SizedBox(height: 15),
          ListTile(
            leading: Image.asset(
              "assets/images/app_icon2.png",
            ),
            title: Text("${S.of(context).appTitle} ${AppInfo.version}"),
            subtitle: Text(S.of(context).freeAdFreeAndOpenSourceApp),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text(S.of(context).contactDeveloper),
            onTap: () => context.pushNamed(ContactScreen.routeName),
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
"""),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: Text(S.of(context).github),
            onTap: () {
              openURL(kOrgGithub);
            },
          ),
        ],
      ),
    );
  }
}
