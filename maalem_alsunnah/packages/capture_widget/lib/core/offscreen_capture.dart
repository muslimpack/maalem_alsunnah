import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Renders [widget] in its own widget tree, never shown on screen, and
/// returns it as an image of [logicalSize] × [pixelRatio] physical pixels.
///
/// Use it to capture widgets that aren't built on screen, such as the pages
/// of a `PageView` the user hasn't scrolled to. Images inside [widget] should
/// be precached (see `precacheImage`) so they are ready when it paints.
///
/// The tree has a [MediaQuery] (no text scaling) and a [Directionality]
/// above [widget], but no theme or localizations: pass in anything else the
/// widget needs.
Future<ui.Image> captureOffscreen(
  Widget widget, {
  required Size logicalSize,
  double pixelRatio = 1,
  TextDirection textDirection = TextDirection.ltr,
  Duration settle = const Duration(milliseconds: 20),
}) async {
  final view = WidgetsBinding.instance.platformDispatcher.implicitView ??
      WidgetsBinding.instance.platformDispatcher.views.first;

  final repaintBoundary = RenderRepaintBoundary();
  final renderView = RenderView(
    view: view,
    child: RenderPositionedBox(child: repaintBoundary),
    configuration: ViewConfiguration(
      logicalConstraints: BoxConstraints.tight(logicalSize),
      physicalConstraints: BoxConstraints.tight(logicalSize * pixelRatio),
      devicePixelRatio: pixelRatio,
    ),
  );

  final pipelineOwner = PipelineOwner()..rootNode = renderView;
  renderView.prepareInitialFrame();

  bool dirty = false;
  final buildOwner = BuildOwner(
    focusManager: FocusManager(),
    onBuildScheduled: () => dirty = true,
  );

  final adapter = RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: MediaQuery(
      data: MediaQueryData(
        size: logicalSize,
        devicePixelRatio: pixelRatio,
        textScaler: TextScaler.noScaling,
      ),
      child: Directionality(
        textDirection: textDirection,
        child: SizedBox.fromSize(size: logicalSize, child: widget),
      ),
    ),
  );
  final rootElement = adapter.attachToRenderTree(buildOwner);

  void frame() {
    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();
    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();
  }

  try {
    frame();
    // Images resolve after the first build and schedule a rebuild; give
    // them a few frames to land.
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(settle);
      if (!dirty) break;
      dirty = false;
      frame();
    }

    return await repaintBoundary.toImage(pixelRatio: pixelRatio);
  } finally {
    // Unmount the tree so states (and their image listeners) are disposed.
    RenderObjectToWidgetAdapter<RenderBox>(container: repaintBoundary)
        .attachToRenderTree(buildOwner, rootElement);
    buildOwner.finalizeTree();
  }
}
