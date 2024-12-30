import 'dart:convert';

import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UIRepo {
  final Box box;

  UIRepo(this.box);

  ///* ******* desktop Window Size ******* */
  static const String desktopWindowSizeKey = "desktopWindowSize";
  Size? get desktopWindowSize {
    const Size defaultSize = Size(950, 950);
    try {
      final data = jsonDecode(
        box.get(desktopWindowSizeKey) as String? ??
            '{"width":${defaultSize.width},"height":${defaultSize.height}}',
      ) as Map<String, dynamic>;
      appPrint(data);

      final double width = (data['width'] as num).toDouble();
      final double height = (data['height'] as num).toDouble();

      return Size(width, height);
    } catch (e) {
      appPrint(e);
    }
    return defaultSize;
  }

  Future<void> changeDesktopWindowSize(Size value) async {
    final screenSize = {
      'width': value.width,
      'height': value.height,
    };
    final String data = jsonEncode(screenSize);
    return box.put(desktopWindowSizeKey, data);
  }
}
