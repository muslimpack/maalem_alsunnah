import 'package:maalem_alsunnah/src/core/constants/constant.dart';

extension StringExtension on String {
  String get removeDiacritics {
    return replaceAll(
      RegExp(String.fromCharCodes(arabicDiacriticsChar)),
      "",
    );
  }

  String removeBrackets() {
    return replaceAll(RegExp('[()]'), '');
  }
}
