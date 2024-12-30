// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_slider.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';

class ContentNavBar extends StatelessWidget {
  const ContentNavBar({
    super.key,
    required this.state,
  });

  final ContentViewerLoadedState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: S.of(context).previous,
          onPressed: !state.hasPrevious
              ? null
              : () {
                  context.read<ContentViewerCubit>().previousContent();
                },
          icon: Icon(Icons.arrow_back),
        ),
        Expanded(child: ContentSlider(state: state)),
        IconButton(
          tooltip: S.of(context).next,
          onPressed: !state.hasNext
              ? null
              : () {
                  context.read<ContentViewerCubit>().nextContent();
                },
          icon: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
