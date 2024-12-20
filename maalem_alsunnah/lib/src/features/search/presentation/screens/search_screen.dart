import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_result_viewer.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_ruling_filters_bar.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          children: [
            const SizedBox(height: 15),
            const SearchRullingFiltersBar(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                state.searchText.isEmpty
                    ? ""
                    : "${S.of(context).searchResultCount}: ${state.searchinfo.filtered.searchResultLength}",
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(
              child: SearchResultViewer(),
            ),
          ],
        );
      },
    );
  }
}
