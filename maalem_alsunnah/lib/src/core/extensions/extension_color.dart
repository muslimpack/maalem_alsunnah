import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color get getContrastColor {
    final luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static int floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
