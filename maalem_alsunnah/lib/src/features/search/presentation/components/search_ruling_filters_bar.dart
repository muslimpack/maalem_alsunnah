// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/home/data/models/hadith_ruling_enum.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';

class SearchRullingFiltersBar extends StatelessWidget {
  const SearchRullingFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is! SearchLoadedState) return const SizedBox.shrink();
        return Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: HadithRulingEnum.values.map((e) {
            final count = state.searchinfo.total.rulingStats[e] ?? 0;
            return ChoiceChip(
              label: Text(
                "${e.title} ($count)",
              ),
              showCheckmark: false,
              selected: state.activeRuling.contains(e),
              onSelected: (value) async {
                context.read<SearchCubit>().toggleRulingStatus(e, value);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
