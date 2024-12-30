// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/responsive_text.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class HadithSearchCard extends StatelessWidget {
  final String searchedText;
  final HadithModel hadith;
  const HadithSearchCard({
    super.key,
    required this.searchedText,
    required this.hadith,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.brown.withValues(alpha: .3),
              width: 7,
            ),
          ),
        ),
        child: Column(
          children: [
            TitlesChainBreadCrumb(titleId: hadith.titleId),
            ResponsiveText(
              hadith.searchText,
              searchedText: searchedText,
              style: TextStyle(
                fontSize: context.watch<SettingsCubit>().state.fontSize * 10,
                fontFamily: 'adwaa',
                height: 1.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
