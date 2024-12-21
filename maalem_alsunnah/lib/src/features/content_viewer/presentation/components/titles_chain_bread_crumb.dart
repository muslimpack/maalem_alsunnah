// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

class TitlesChainBreadCrumb extends StatelessWidget {
  const TitlesChainBreadCrumb({
    super.key,
    required this.titleId,
  });

  final int titleId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<HadithDbHelper>().getTitleChain(titleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LinearProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else {
          return TitlesChainBreadCrumbBuilder(titlesChains: snapshot.data!);
        }
      },
    );
  }
}

class TitlesChainBreadCrumbBuilder extends StatelessWidget {
  const TitlesChainBreadCrumbBuilder({
    super.key,
    required this.titlesChains,
  });

  final List<TitleModel> titlesChains;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: BreadCrumb.builder(
        itemCount: titlesChains.length,
        builder: (index) {
          return BreadCrumbItem(
            content: BreadCrumbItemBuilder(
              index: index,
              titlesChains: titlesChains,
            ),
          );
        },
        divider: Text(
          '/',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class BreadCrumbItemBuilder extends StatelessWidget {
  final int index;
  final List<TitleModel> titlesChains;
  const BreadCrumbItemBuilder({
    super.key,
    required this.index,
    required this.titlesChains,
  });

  @override
  Widget build(BuildContext context) {
    final title = titlesChains[index];
    if (index == 0) {
      return TextButton(
        child: Row(
          children: [
            Icon(Icons.home_rounded),
            SizedBox(width: 5),
            Text(
              title.name,
            ),
          ],
        ),
        onPressed: () {},
      );
    } else if (index == titlesChains.length - 1) {
      return FilledButton(
        child: Text(
          title.name,
        ),
        onPressed: () {},
      );
    }
    return TextButton(
      child: Text(
        title.name,
      ),
      onPressed: () {},
    );
  }
}
