part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Brightness brightness;

  final String fontFamily;
  final Locale? locale;
  const ThemeState({
    required this.brightness,
    required this.fontFamily,
    required this.locale,
  });

  ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF451b1b),
        brightness: brightness,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }

  ThemeState copyWith({
    Brightness? brightness,
    String? fontFamily,
    Locale? locale,
  }) {
    return ThemeState(
      brightness: brightness ?? this.brightness,
      fontFamily: fontFamily ?? this.fontFamily,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [brightness, fontFamily, locale];
}
