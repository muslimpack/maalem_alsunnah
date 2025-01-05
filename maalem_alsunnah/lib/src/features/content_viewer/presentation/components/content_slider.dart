// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/controller/cubit/content_viewer_cubit.dart';

class ContentSlider extends StatefulWidget {
  const ContentSlider({
    super.key,
    required this.state,
  });

  final ContentViewerLoadedState state;

  @override
  State<ContentSlider> createState() => _ContentSliderState();
}

class _ContentSliderState extends State<ContentSlider> {
  late double value;

  @override
  void didUpdateWidget(covariant ContentSlider oldWidget) {
    if (widget.state.content.orderId != value) {
      setState(() {
        value = widget.state.content.orderId.toDouble();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    value = widget.state.content.titleId.toDouble();
  }

  bool isChanging = false;

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: widget.state.contentRange.start,
      max: widget.state.contentRange.end,
      divisions: widget.state.contentCount,
      value: isChanging ? value : widget.state.content.orderId.toDouble(),
      onChanged: (value) {
        setState(() {
          isChanging = true;
          this.value = value;
        });
      },
      label: value.toInt().toString(),
      onChangeEnd: (value) async {
        context.read<ContentViewerCubit>().goToContent(
              value.toInt(),
            );
        setState(() {
          isChanging = false;
        });
      },
    );
  }
}
