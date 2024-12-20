import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 30,
      itemBuilder: (context, index) {
        return Card(
          clipBehavior: Clip.hardEdge,
          child: ListTile(
            onTap: () {},
            leading: Icon(MdiIcons.bookOpenPageVariant),
            subtitle: Text("Hadith $index"),
            title: Text("Hadith $index"),
            trailing: Icon(Icons.chevron_right_outlined),
          ),
        );
      },
    );
  }
}
