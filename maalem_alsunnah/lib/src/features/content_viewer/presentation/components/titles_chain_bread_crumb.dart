// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/core/utils/app_nav_observer.dart';
import 'package:maalem_alsunnah/src/core/utils/dummy_data.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_rich_text_builder.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TitlesChainBreadCrumb extends StatefulWidget {
  final bool showLastOnly;
  const TitlesChainBreadCrumb({
    super.key,
    required this.titleId,
    this.showLastOnly = false,
  });

  final int titleId;

  @override
  State<TitlesChainBreadCrumb> createState() => _TitlesChainBreadCrumbState();
}

class _TitlesChainBreadCrumbState extends State<TitlesChainBreadCrumb> {
  late Future<List<TitleModel>> titlesChains;
  @override
  void initState() {
    super.initState();
    titlesChains = _updateAndGetList();
  }

  void refreshList() {
    setState(() {
      titlesChains = _updateAndGetList();
    });
  }

  Future<List<TitleModel>> _updateAndGetList() async {
    return sl<HadithDbHelper>().getTitleChain(widget.titleId);
  }

  @override
  void didUpdateWidget(covariant TitlesChainBreadCrumb oldWidget) {
    if (oldWidget.titleId != widget.titleId) {
      refreshList();
    }
    super.didUpdateWidget(oldWidget);
  }

  void onPressed(BuildContext context, int index, TitleModel title) {
    bool titleFoundInStack = false;
    for (var route in routeStack) {
      final Map? args = route.settings.arguments as Map?;
      final int? routeTitleId = args?["titleId"] as int?;
      if (routeTitleId != null && title.id == routeTitleId) {
        titleFoundInStack = true;
        break;
      }
    }
    if (titleFoundInStack) {
      Navigator.popUntil(
        context,
        (r) => (r.settings.arguments as Map)["titleId"] == title.id,
      );
    } else {
      if (routeStack.length <= 1) {
        context.pushNamed(
          ContentViewerScreen.routeName,
          arguments: {"titleId": title.id},
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          ContentViewerScreen.routeName,
          arguments: {"titleId": title.id},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: titlesChains,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            enabled: true,
            child: TitlesChainRichTextBuilder(
              titlesChains: titleModelDummyData,
              onPressed: (index, title) => onPressed(context, index, title),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else {
          final List<TitleModel> titlesChains = snapshot.data!;
          if (widget.showLastOnly && titlesChains.length > 1) {
            titlesChains.removeRange(0, titlesChains.length - 1);
          }
          return TitlesChainRichTextBuilder(
            titlesChains: titlesChains,
            onPressed: (index, title) => onPressed(context, index, title),
          );
        }
      },
    );
  }
}
