// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/title_card.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/new_page_progress_indicator_builder.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/no_items_found_indicator_builder.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/no_more_items_indicator_builder.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';

class SearchResultViewer extends StatelessWidget {
  const SearchResultViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is! SearchLoadedState) return const SizedBox.shrink();

        return PagedListView<int, TitleModel>(
          padding: const EdgeInsets.all(15),
          pagingController: context.read<SearchCubit>().titlePagingController,
          builderDelegate: PagedChildBuilderDelegate<TitleModel>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 500),
            itemBuilder: (context, hadith, index) => TitleCard(
              title: hadith,
            ),
            newPageProgressIndicatorBuilder: (context) =>
                NewPageProgressIndicatorBuilder(),
            noMoreItemsIndicatorBuilder: (context) =>
                NoMoreItemsIndicatorBuilder(),
            noItemsFoundIndicatorBuilder: (context) =>
                NoItemsFoundIndicatorBuilder(
              searchText: state.searchText,
            ),
          ),
        );
      },
    );
  }
}
