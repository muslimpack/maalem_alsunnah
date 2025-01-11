// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/title_card.dart';

class SubListScreen extends StatelessWidget {
  final ContentSubListViewerLoadedState state;
  const SubListScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.name),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(15),
            sliver: SliverFloatingHeader(
              snapMode: FloatingHeaderSnapMode.overlay,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TitlesChainBreadCrumb(titleId: state.title.id),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(15).copyWith(top: 0),
            sliver: SliverList.builder(
              itemCount: state.titles.length,
              itemBuilder: (context, index) {
                final title = state.titles[index];
                return TitleCard(
                  title: title,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
