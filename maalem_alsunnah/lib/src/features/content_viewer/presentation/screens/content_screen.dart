import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final cubit = context.read<ContentViewerCubit>();
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.title.name),
        centerTitle: true,
        actions: const [
          FontSettingsIconButton(),
        ],
      ),
      // Keyboard navigation (desktop): arrows follow reading direction.
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowLeft):
              isRtl ? cubit.nextContent : cubit.previousContent,
          const SingleActivator(LogicalKeyboardKey.arrowRight):
              isRtl ? cubit.previousContent : cubit.nextContent,
          const SingleActivator(LogicalKeyboardKey.pageUp): cubit.previousContent,
          const SingleActivator(LogicalKeyboardKey.pageDown): cubit.nextContent,
        },
        child: Focus(
          autofocus: true,
          child: PageView.builder(
            controller: cubit.pageController,
            itemCount: state.contentCount,
            itemBuilder: (context, index) {
              return ContentViewerBuilder(contentOrderId: index + 1);
            },
          ),
        ),
      ),
      bottomNavigationBar: ContentViewerBottomBar(state: state),
    );
  }
}
