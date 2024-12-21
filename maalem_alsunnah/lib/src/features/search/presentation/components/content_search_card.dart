// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_bread_crumb.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/responsive_text.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class ContentSearchCard extends StatelessWidget {
  final String searchedText;
  final ContentModel content;
  const ContentSearchCard({
    super.key,
    required this.searchedText,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.book_outlined),
        title: TitlesChainBreadCrumb(titleId: content.titleId),
        subtitle: ResponsiveText(
          context.watch<SettingsCubit>().state.showDiacritics
              ? content.text
              : content.searchText,
          searchedText: searchedText,
          style: TextStyle(
            fontSize: context.watch<SettingsCubit>().state.fontSize * 10,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
