// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_screen.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/sub_list_screen.dart';

class ContentViewerScreen extends StatelessWidget {
  final int titleId;
  final bool viewAsContent;

  static const String routeName = "/viewer";

  static Route route({required int titleId, required bool viewAsContent}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
        arguments: {"titleId": titleId, "viewAsContent": viewAsContent},
      ),
      builder: (_) =>
          ContentViewerScreen(titleId: titleId, viewAsContent: viewAsContent),
    );
  }

  const ContentViewerScreen({
    super.key,
    required this.titleId,
    required this.viewAsContent,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ContentViewerCubit>()..start(titleId, isContent: viewAsContent),
      child: BlocBuilder<ContentViewerCubit, ContentViewerState>(
        builder: (context, state) {
          if (state is ContentSubListViewerLoadedState) {
            return SubListScreen(state: state);
          }

          if (state is ContentViewerLoadedState) {
            return ContentScreen(state: state);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
