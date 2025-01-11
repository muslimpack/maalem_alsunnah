part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Brightness brightness;
  final Color color;
  final String fontFamily;
  final Locale? locale;
  const ThemeState({
    required this.brightness,
    required this.color,
    required this.fontFamily,
    required this.locale,
  });

  ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: brightness,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }

  ThemeState copyWith({
    Brightness? brightness,
    Color? color,
    String? fontFamily,
    Locale? locale,
  }) {
    return ThemeState(
      brightness: brightness ?? this.brightness,
      color: color ?? this.color,
      fontFamily: fontFamily ?? this.fontFamily,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [brightness, color, fontFamily, locale];
}
