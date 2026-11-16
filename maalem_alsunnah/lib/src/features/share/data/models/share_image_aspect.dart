import 'package:flutter/painting.dart';

/// Canvas sizes for the shared image. Every preset is 1080 logical pixels
/// wide; [tall] (2:3) is the tallest image the app produces.
enum ShareImageAspect {
  /// Picks the smallest preset that holds the whole text on one page, or
  /// [tall] when even that is not enough.
  auto(null),
  square(Size(1080, 1080)),
  portrait(Size(1080, 1350)),
  tall(Size(1080, 1620));

  final Size? size;
  const ShareImageAspect(this.size);

  /// The presets Auto tries, smallest first.
  static const List<ShareImageAspect> fixed = [square, portrait, tall];

  String get ratioLabel => switch (this) {
        auto => "",
        square => "1:1",
        portrait => "4:5",
        tall => "2:3",
      };
}
