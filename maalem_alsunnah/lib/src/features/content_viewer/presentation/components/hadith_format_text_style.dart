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
  final TextFormatterSettings textFormatterSettings = TextFormatterSettings(
    deafaultStyle: defaultStyle,
    hadithTextStyle: defaultStyle.copyWith(
      // fontWeight: FontWeight.bold,
      color: Colors.yellow[700],
    ),
    quranTextStyle: defaultStyle.copyWith(
      color: Colors.lightGreen[300],
      fontWeight: FontWeight.bold,
    ),
    squareBracketsStyle: defaultStyle.copyWith(
      color: Colors.cyan[300],
    ),
    roundBracketsStyle: defaultStyle.copyWith(
      color: Colors.red[300],
    ),
    startingNumberStyle: defaultStyle.copyWith(
      color: Colors.purple[300],
      fontWeight: FontWeight.bold,
    ),
  );

  return textFormatterSettings;
}
