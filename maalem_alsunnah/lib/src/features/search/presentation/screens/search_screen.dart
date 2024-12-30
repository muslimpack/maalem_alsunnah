import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/title_card.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_for.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/content_search_card.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/hadith_search_card.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_filters_dialog.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_for_bar.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_result_viewer.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is! SearchLoadedState) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 15,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SearchForBar(),
                SearchFiltersButton(),
              ],
            ),
            Expanded(
              child: switch (state.searchFor) {
                SearchFor.title => SearchResultViewer<TitleModel>(
                    pagingController: sl<SearchCubit>().titlePagingController,
                    itemBuilder: (context, item, index) {
                      return TitleCard(title: item);
                    },
                  ),
                SearchFor.content => SearchResultViewer<ContentModel>(
                    pagingController: sl<SearchCubit>().contentPagingController,
                    itemBuilder: (context, item, index) {
                      return ContentSearchCard(
                        content: item,
                        searchedText: state.searchText,
                      );
                    },
                  ),
                SearchFor.hadith => SearchResultViewer<HadithModel>(
                    pagingController: sl<SearchCubit>().hadithPagingController,
                    itemBuilder: (context, item, index) {
                      return HadithSearchCard(
                        hadith: item,
                        searchedText: state.searchText,
                      );
                    },
                  ),
              },
            ),
          ],
        );
      },
    );
  }
}
