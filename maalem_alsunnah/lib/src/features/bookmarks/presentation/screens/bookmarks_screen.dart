import 'package:flutter/material.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

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
            leading: Icon(Icons.bookmark_rounded),
            subtitle: Text("Hadith $index"),
            title: Text("Hadith $index"),
            trailing: Icon(Icons.chevron_right_outlined),
          ),
        );
      },
    );
  }
}
