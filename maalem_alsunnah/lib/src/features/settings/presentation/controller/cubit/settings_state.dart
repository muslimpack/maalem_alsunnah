// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final double fontSize;
  final bool showDiacritics;

  const SettingsState({
    required this.fontSize,
    required this.showDiacritics,
  });

  @override
  List<Object> get props => [fontSize, showDiacritics];

  SettingsState copyWith({
    double? fontSize,
    bool? showDiacritics,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      showDiacritics: showDiacritics ?? this.showDiacritics,
    );
  }
}
