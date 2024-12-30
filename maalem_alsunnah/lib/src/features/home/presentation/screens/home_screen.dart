import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/screens/bookmarks_screen.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/screens/notes_screen.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/continue_reading_card.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/home_app_bar.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/index_screen.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => HomeScreen(),
    );
  }

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
    context.read<HomeCubit>().tabIndexChanged(tabController.index);
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
                HomeAppBar(
                  tabController: tabController,
                  state: state,
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
          bottomNavigationBar:
              (tabController.index != 1) && (state.lastReadTitle != null)
                  ? ContinueReadingCard(
                      title: state.lastReadTitle!,
                      progress: state.readProgress,
                    )
                  : null,
        );
      },
    );
  }
}
