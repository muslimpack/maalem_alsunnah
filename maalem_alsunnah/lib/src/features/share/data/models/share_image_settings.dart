import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_aspect.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_theme.dart';

/// The reader's choices on the share-as-image screen, kept between shares.
class ShareImageSettings extends Equatable {
  static const double minFontSize = 34;
  static const double maxFontSize = 66;
  static const double fontSizeStep = 4;
  static const double defaultFontSize = 46;

  final ShareImagePalette palette;

  /// `null` until the reader picks one; the image then follows the app.
  final Brightness? brightness;
  final ShareImageAspect aspect;
  final double fontSize;
  final bool showTitleChain;

  const ShareImageSettings({
    required this.palette,
    required this.brightness,
    required this.aspect,
    required this.fontSize,
    required this.showTitleChain,
  });

  const ShareImageSettings.defaults()
      : palette = ShareImagePalette.maroon,
        brightness = null,
        aspect = ShareImageAspect.auto,
        fontSize = defaultFontSize,
        showTitleChain = true;

  ShareImageTheme theme(Brightness appBrightness) {
    return ShareImageTheme.resolve(palette, brightness ?? appBrightness);
  }

  ShareImageSettings copyWith({
    ShareImagePalette? palette,
    Brightness? brightness,
    ShareImageAspect? aspect,
    double? fontSize,
    bool? showTitleChain,
  }) {
    return ShareImageSettings(
      palette: palette ?? this.palette,
      brightness: brightness ?? this.brightness,
      aspect: aspect ?? this.aspect,
      fontSize: (fontSize ?? this.fontSize).clamp(minFontSize, maxFontSize),
      showTitleChain: showTitleChain ?? this.showTitleChain,
    );
  }

  String toJson() => json.encode({
        'palette': palette.name,
        'brightness': brightness?.name,
        'aspect': aspect.name,
        'fontSize': fontSize,
        'showTitleChain': showTitleChain,
      });

  factory ShareImageSettings.fromJson(String source) {
    const defaults = ShareImageSettings.defaults();
    final map = json.decode(source) as Map<String, dynamic>;

    T byName<T extends Enum>(List<T> values, Object? name, T fallback) {
      return values.where((value) => value.name == name).firstOrNull ?? fallback;
    }

    return ShareImageSettings(
      palette: byName(ShareImagePalette.values, map['palette'], defaults.palette),
      brightness: Brightness.values.where((b) => b.name == map['brightness']).firstOrNull,
      aspect: byName(ShareImageAspect.values, map['aspect'], defaults.aspect),
      fontSize: ((map['fontSize'] as num?)?.toDouble() ?? defaults.fontSize)
          .clamp(minFontSize, maxFontSize),
      showTitleChain: map['showTitleChain'] as bool? ?? defaults.showTitleChain,
    );
  }

  @override
  List<Object?> get props => [palette, brightness, aspect, fontSize, showTitleChain];
}
