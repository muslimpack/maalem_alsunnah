// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/features/settings/domain/repository/text_font_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final TextFontRepo textFontRepo;
  SettingsCubit(
    this.textFontRepo,
  ) : super(
          SettingsState(
            fontSize: textFontRepo.fontSize,
            showDiacritics: textFontRepo.showDiacritics,
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
}
