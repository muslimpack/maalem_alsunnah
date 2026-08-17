// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/components/search_type_bar.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';

class SearchFiltersButton extends StatelessWidget {
  const SearchFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return IconButton(
          tooltip: S.of(context).searchFilters,
          onPressed: () async {
            await showSearchFilterDialog(context);
          },
          icon: const FaIcon(FontAwesomeIcons.filter, size: 18),
        );
      },
    );
  }
}

Future showSearchFilterDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const SearchFiltersDialog();
    },
  );
}

class SearchFiltersDialog extends StatelessWidget {
  const SearchFiltersDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).searchFilters),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchTypeBar(),
          ],
        ),
      ),
    );
  }
}
