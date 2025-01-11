import 'package:maalem_alsunnah/src/features/themes/data/repository/theme_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepo themeRepo;
  ThemeCubit(this.themeRepo)
      : super(
          ThemeState(
            brightness: themeRepo.brightness,
            color: themeRepo.color,
            fontFamily: themeRepo.fontFamily,
            locale: themeRepo.appLocale,
          ),
        );

  ///MARK: Theme
  Future<void> changeBrightness(Brightness brightness) async {
    await themeRepo.setBrightness(brightness);
    emit(state.copyWith(brightness: brightness));
  }

  Future<void> toggleBrightness() async {
    changeBrightness(
      state.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );
  }

  ///MARK:Font Family
  Future<void> changeFontFamily(String fontFamily) async {
    await themeRepo.changFontFamily(fontFamily);
    emit(state.copyWith(fontFamily: fontFamily));
  }

  ///MARK: App Locale
  Future<void> changeAppLocale(String locale) async {
    await themeRepo.changAppLocale(locale);
    emit(state.copyWith(locale: Locale(locale)));
  }

  ///MARK: App Color
  Future<void> changeColor(Color color) async {
    await themeRepo.setColor(color);
    emit(state.copyWith(color: color));
  }
}
