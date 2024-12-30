import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:hive/hive.dart';

class TextFontRepo {
  final Box box;
  TextFontRepo(this.box);

  ///MARK: Font
  /* ******* Font Size ******* */
  static const String _fontSizeKey = "prefFontSize";
  double get fontSize => box.get(_fontSizeKey) as double? ?? kFontDefault;

  Future<void> changFontSize(double value) async {
    final double tempValue = value.clamp(kFontMin, kFontMax);
    await box.put(_fontSizeKey, tempValue);
  }

  /* ******* Diacritics ******* */

  static const String _showDiacriticsKey = "prefShowDiacritics";
  bool get showDiacritics => box.get(_showDiacriticsKey) as bool? ?? true;

  Future<void> changDiacriticsStatus({required bool value}) async =>
      box.put(_showDiacriticsKey, value);
}
