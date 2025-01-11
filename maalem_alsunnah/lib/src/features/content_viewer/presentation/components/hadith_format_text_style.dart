import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

TextFormatterSettings hadithTextFormatterSettings(BuildContext context) {
  final defaultStyle = TextStyle(
    fontSize: context.watch<SettingsCubit>().state.fontSize * 10,
    fontFamily: 'adwaa',
    height: 1.5,
  );

  return hadithTextFormatterSettingsByDefault(context, defaultStyle);
}

TextFormatterSettings hadithTextFormatterSettingsByDefault(
    BuildContext context, TextStyle defaultStyle) {
  final formatterColorSettings =
      context.watch<SettingsCubit>().state.formatterColorSettings;

  final TextFormatterSettings textFormatterSettings = TextFormatterSettings(
    deafaultStyle: defaultStyle,
    hadithTextStyle: defaultStyle.copyWith(
      // fontWeight: FontWeight.bold,
      color: formatterColorSettings.hadithTextColor,
    ),
    quranTextStyle: defaultStyle.copyWith(
      color: formatterColorSettings.quranTextColor,
      fontWeight: FontWeight.bold,
    ),
    squareBracketsStyle: defaultStyle.copyWith(
      color: formatterColorSettings.squareBracketsColor,
    ),
    roundBracketsStyle: defaultStyle.copyWith(
      color: formatterColorSettings.roundBracketsColor,
    ),
    startingNumberStyle: defaultStyle.copyWith(
      color: formatterColorSettings.startingNumberColor,
      fontWeight: FontWeight.bold,
    ),
  );

  return textFormatterSettings;
}
