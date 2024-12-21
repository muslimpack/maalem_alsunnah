// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/search_for_type.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';

class SearchForBar extends StatelessWidget {
  const SearchForBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is! SearchLoadedState) return const SizedBox.shrink();
        return Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: SearchForType.values.map((e) {
            return ChoiceChip(
              label: Text(
                e.localeName(context),
              ),
              showCheckmark: false,
              selected: state.searchForType == e,
              onSelected: (value) async {
                context.read<SearchCubit>().changeSearchFor(e);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
