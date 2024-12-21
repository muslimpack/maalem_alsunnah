import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_field.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/settings_screen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.tabController,
    required this.state,
  });

  final HomeLoadedState state;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      leading: Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset('assets/images/app_icon2.png'),
      ),
      title: !state.search ? Text(S.of(context).appTitle) : SearchField(),
      centerTitle: true,
      actions: [
        if (!state.search)
          IconButton(
            tooltip: S.of(context).settings,
            onPressed: () {
              sl<HomeCubit>().toggleSearch(!state.search);
            },
            icon: const Icon(Icons.search),
          )
        else
          IconButton(
            tooltip: S.of(context).settings,
            onPressed: () {
              sl<HomeCubit>().toggleSearch(!state.search);
            },
            icon: const Icon(Icons.close),
          ),
        IconButton(
          tooltip: S.of(context).settings,
          onPressed: () {
            context.push(const SettingsScreen());
          },
          icon: const Icon(Icons.settings),
        ),
      ],
      bottom: TabBar(
        controller: tabController,
        tabs: [
          Tab(
            text: S.of(context).index,
            icon: Icon(Icons.list),
          ),
          Tab(
            text: S.of(context).search,
            icon: Icon(Icons.search),
          ),
          Tab(
            text: S.of(context).bookmarks,
            icon: Icon(Icons.bookmark_border_outlined),
          ),
          Tab(
            text: S.of(context).notes,
            icon: Icon(Icons.library_books_outlined),
          ),
        ],
      ),
    );
  }
}
