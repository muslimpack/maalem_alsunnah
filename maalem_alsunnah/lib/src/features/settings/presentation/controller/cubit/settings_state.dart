// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final double fontSize;
  final bool showDiacritics;
  final TextFormatterColorSettings formatterColorSettings;

  const SettingsState({
    required this.fontSize,
    required this.showDiacritics,
    required this.formatterColorSettings,
  });

  @override
  List<Object> get props => [fontSize, showDiacritics, formatterColorSettings];

  SettingsState copyWith({
    double? fontSize,
    bool? showDiacritics,
    TextFormatterColorSettings? formatterColorSettings,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      showDiacritics: showDiacritics ?? this.showDiacritics,
      formatterColorSettings:
          formatterColorSettings ?? this.formatterColorSettings,
    );
  }
}
