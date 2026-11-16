import 'dart:ui' as ui;

import 'package:capture_widget/capture_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('captures a widget that is not on screen at the asked size', (tester) async {
    await tester.pumpWidget(const SizedBox());

    final image = await tester.runAsync(() => captureOffscreen(
          const ColoredBox(color: Color(0xff112233)),
          logicalSize: const Size(100, 150),
          pixelRatio: 2,
        ));

    expect(image, isNotNull);
    expect(image!.width, 200);
    expect(image.height, 300);

    final bytes = await tester.runAsync(() => image.toByteData(format: ui.ImageByteFormat.rawRgba));
    // The centre pixel is the box colour, not transparent.
    const offset = (150 * 200 + 100) * 4;
    expect(bytes!.getUint8(offset), 0x11);
    expect(bytes.getUint8(offset + 1), 0x22);
    expect(bytes.getUint8(offset + 2), 0x33);
    expect(bytes.getUint8(offset + 3), 0xff);
  });
}
