// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_viewer_bottom_bar.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_viewer_builder.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/components/font_settings_widgets.dart';

class ContentScreen extends StatelessWidget {
  final ContentViewerLoadedState state;
  const ContentScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.name),
        centerTitle: true,
        actions: [
          FontSettingsIconButton(),
        ],
      ),
      body: PageView.builder(
        controller: context.read<ContentViewerCubit>().pageController,
        itemCount: state.contentCount,
        itemBuilder: (context, index) {
          return ContentViewerBuilder(contentOrderId: index + 1);
        },
      ),
      bottomNavigationBar: ContentViewerBottomBar(state: state),
    );
  }
}
