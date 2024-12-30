// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/content_image_card.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/controller/cubit/share_image_cubit.dart';

class ShareAsImageScreen extends StatelessWidget {
  final int itemId;
  final ShareType shareType;

  static const String routeName = "/shareAsImage";

  static Route route({required int itemId, required ShareType shareType}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
        arguments: {"itemId": itemId, "shareType": shareType},
      ),
      builder: (_) => ShareAsImageScreen(itemId: itemId, shareType: shareType),
    );
  }

  const ShareAsImageScreen({
    super.key,
    required this.itemId,
    required this.shareType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ShareImageCubit>()..start(itemId: itemId, shareType: shareType),
      child: BlocBuilder<ShareImageCubit, ShareImageState>(
        builder: (context, state) {
          if (state is! ShareImageLoadedState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).shareAsImage),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await context.read<ShareImageCubit>().shareImage(false);
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: state.showLoadingIndicator
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink(),
              ),
            ),
            body: PageView.builder(
              controller: context.read<ShareImageCubit>().pageController,
              itemCount: state.splittedMatn.length,
              onPageChanged: context.read<ShareImageCubit>().onPageChanged,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    FittedBox(
                      child: RepaintBoundary(
                        key: context.read<ShareImageCubit>().imageKeys[index],
                        child: switch (state.shareType) {
                          ShareType.content => ContentImageCard(
                              content: state.imageCardArgs[0] as ContentModel,
                              title: state.imageCardArgs[1] as TitleModel,
                              titleChain:
                                  state.imageCardArgs[2] as List<TitleModel>,
                              settings: state.settings,
                              matnRange: state.splittedMatn[index],
                              splittedLength: state.splittedMatn.length,
                              splittedindex: index,
                            ),
                          ShareType.hadith => SizedBox(), //TODO
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: state.splittedMatn.length < 2
                ? null
                : BottomAppBar(
                    height: kToolbarHeight,
                    child: Text(
                      "${state.splittedMatn.length} : ${state.activeIndex + 1}",
                      textAlign: TextAlign.center,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
