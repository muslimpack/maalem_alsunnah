import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/shared/custom_field_decoration.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            controller: context.read<SearchCubit>().searchController,
            decoration: customInputDecoration.copyWith(
              prefixIcon: IconButton(
                tooltip: S.of(context).clear,
                onPressed: () {
                  context.read<SearchCubit>().clear();
                },
                icon: Icon(MdiIcons.eraser),
              ),
            ),
            style: TextStyle(
              fontFamily: 'adwaa',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            onChanged: (value) {
              EasyDebounce.debounce(
                'search',
                const Duration(milliseconds: 500),
                () {
                  context.read<SearchCubit>().updateSearchText(value);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
