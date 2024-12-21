import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            const Expanded(
              child: SearchResultViewer(),
            ),
          ],
        );
      },
    );
  }
}
