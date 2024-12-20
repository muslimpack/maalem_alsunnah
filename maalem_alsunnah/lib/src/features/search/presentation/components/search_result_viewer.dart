import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/hadith_card.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultViewer extends StatelessWidget {
  const SearchResultViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is! SearchLoadedState) return const SizedBox.shrink();

        return PagedListView<int, Hadith>(
          padding: const EdgeInsets.all(15),
          pagingController: context.read<SearchCubit>().pagingController,
          builderDelegate: PagedChildBuilderDelegate<Hadith>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 500),
            itemBuilder: (context, hadith, index) => HadithCard(
              hadith: hadith,
              searchedText: state.searchText,
            ),
            newPageProgressIndicatorBuilder: (context) => const Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: CircularProgressIndicator(),
              ),
            ),
            noMoreItemsIndicatorBuilder: (context) => Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  S.of(context).noMoreResultsMsg,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(height: 10),
                Text(
                  '${S.of(context).noResultsFound}\n"${state.searchText}"',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
