// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/hadith_card_popup_menu.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/responsive_text.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HadithCard extends StatelessWidget {
  final Hadith hadith;
  final EdgeInsetsGeometry? margin;
  final String? searchedText;
  const HadithCard({
    super.key,
    required this.hadith,
    this.searchedText,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: hadith.rulingEnum.color.withValues(alpha: .3),
              width: 7,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hadith.narrator +
                          (hadith.narratorReference.isNotEmpty
                              ? " (${hadith.narratorReference})"
                              : ""),
                      style: TextStyle(
                        fontSize:
                            context.watch<SettingsCubit>().state.fontSize * 6,
                      ),
                    ),
                  ),
                  HadithCardPopupMenu(hadith: hadith),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ResponsiveText(
                  context.watch<SettingsCubit>().state.showDiacritics
                      ? hadith.hadith
                      : hadith.hadith.removeDiacritics,
                  searchedText: searchedText,
                  style: TextStyle(
                    fontSize: context.watch<SettingsCubit>().state.fontSize * 8,
                  ),
                ),
              ),
              const Divider(),
              Text(
                "المرتبة: ${hadith.rank}  |  الحكم: [${hadith.rulingEnum.title}]",
                style: TextStyle(
                  fontSize: context.watch<SettingsCubit>().state.fontSize * 6,
                  color: hadith.rulingEnum.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
