// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_color_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/repository/formatter_color_settings_repo.dart';
import 'package:maalem_alsunnah/src/features/settings/domain/repository/text_font_repo.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final TextFontRepo textFontRepo;
  final FormatterColorSettingsRepo formatterColorSettingsRepo;
  SettingsCubit(
    this.textFontRepo,
    this.formatterColorSettingsRepo,
  ) : super(
          SettingsState(
            fontSize: textFontRepo.fontSize,
            showDiacritics: textFontRepo.showDiacritics,
            formatterColorSettings:
                formatterColorSettingsRepo.textFormatterColorSettings,
          ),
        );

  ///MARK: Zikr Text

  Future<void> changFontSize(double value) async {
    final double tempValue = value.clamp(kFontMin, kFontMax);
    await textFontRepo.changFontSize(tempValue);
    emit(state.copyWith(fontSize: tempValue));
  }

  Future resetFontSize() async {
    await changFontSize(kFontDefault);
  }

  Future increaseFontSize() async {
    await changFontSize(state.fontSize + kFontChangeBy);
  }

  Future decreaseFontSize() async {
    await changFontSize(state.fontSize - kFontChangeBy);
  }

  /* ******* Diacritics ******* */

  Future<void> changDiacriticsStatus({required bool value}) async {
    await textFontRepo.changDiacriticsStatus(value: value);
    emit(state.copyWith(showDiacritics: value));
  }

  Future<void> toggleDiacriticsStatus() async {
    await changDiacriticsStatus(value: !state.showDiacritics);
  }

  /* ******* FormatterColorSettings ******* */

  Future<void> changFormatterColorSettings(
      {required TextFormatterColorSettings settings}) async {
    await formatterColorSettingsRepo.setTextFormatterColorSettings(settings);
    emit(state.copyWith(formatterColorSettings: settings));
  }

  Future<void> resetFormatterColorSettings() async {
    final settings = TextFormatterColorSettings.normal();
    await formatterColorSettingsRepo.setTextFormatterColorSettings(settings);
    emit(state.copyWith(formatterColorSettings: settings));
  }
}
