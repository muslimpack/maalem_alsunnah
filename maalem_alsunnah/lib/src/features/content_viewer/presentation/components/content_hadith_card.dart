// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class ContentHadithCard extends StatelessWidget {
  final HadithModel hadith;
  final TextFormatterSettings textFormatterSettings;
  const ContentHadithCard({
    super.key,
    required this.hadith,
    required this.textFormatterSettings,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTitle = hadith.text.startsWith('باب');
    final String text = context.watch<SettingsCubit>().state.showDiacritics
        ? hadith.text
        : hadith.searchText;
    final String formattedText = isTitle ? text : "${hadith.id} - $text";
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: isTitle
              ? null
              : Border(
                  right: BorderSide(
                    color: Colors.brown.withValues(alpha: .3),
                    width: 7,
                  ),
                ),
        ),
        child: FormattedText(
          text: formattedText,
          settings: textFormatterSettings,
        ),
      ),
    );
  }
}
