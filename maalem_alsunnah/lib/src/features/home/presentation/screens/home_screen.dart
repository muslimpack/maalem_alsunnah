import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/hadith_card.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_field.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_filters_dialog.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/screens/search_screen.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/components/font_settings_widgets.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoadedState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: state.search ? const SearchField() : null,
            leading: const FontSettingsIconButton(),
            actions: [
              ///toogle search
              if (!state.search)
                IconButton(
                  tooltip: S.of(context).search,
                  onPressed: () {
                    context.read<HomeCubit>().toggleSearch(true);
                  },
                  icon: const Icon(Icons.search),
                )
              else ...[
                const SearchFiltersButton(),
                IconButton(
                  tooltip: S.of(context).close,
                  onPressed: () {
                    context.read<HomeCubit>().toggleSearch(false);
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],

              ///settings screen
              IconButton(
                tooltip: S.of(context).settings,
                onPressed: () {
                  context.push(const SettingsScreen());
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: state.search
              ? const SearchScreen()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints:
                            const BoxConstraints(maxWidth: 750, maxHeight: 300),
                        child: Image.asset(
                          "assets/images/app_icon.png",
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        tooltip: S.of(context).refresh,
                        onPressed: () {
                          context.read<HomeCubit>().refresh();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      const SizedBox(height: 20),
                      if (state.authenticHadith != null)
                        HadithCard(hadith: state.authenticHadith!),
                      if (state.weakHadith != null)
                        HadithCard(hadith: state.weakHadith!),
                      if (state.abandonedHadith != null)
                        HadithCard(hadith: state.abandonedHadith!),
                      if (state.fabricatedHadith != null)
                        HadithCard(hadith: state.fabricatedHadith!),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
