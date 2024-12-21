import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/screens/bookmarks_screen.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/continue_reading_card.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/index_screen.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/notes_screen.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/screens/search_screen.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        tabController.addListener(
          tabControllerChanged,
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    tabController.removeListener(tabControllerChanged);
    tabController.dispose();
    super.dispose();
  }

  void tabControllerChanged() {
    // context
    //     .read<HomeBloc>()
    //     .add(TabIndexChangedHomeEvent(index: tabController.index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: NestedScrollView(
            controller: ScrollController(),
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  leading: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.asset('assets/images/app_icon2.png'),
                  ),
                  title: Text(S.of(context).appTitle),
                  centerTitle: true,
                  actions: [
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
                )
              ];
            },
            body: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: tabController,
              children: [
                IndexScreen(maqassedList: state.maqassedList),
                SearchScreen(),
                BookmarksScreen(),
                NotesScreen(),
              ],
            ),
          ),
          bottomNavigationBar: ContinueReadingCard(),
        );
      },
    );
  }
}
