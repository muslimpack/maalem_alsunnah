// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/index_screen.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TitlesChainBreadCrumb(titleId: state.title.id),
          Expanded(
            child: IndexScreen(
              maqassedList: state.titles,
            ),
          ),
        ],
      ),
    );
  }
}
