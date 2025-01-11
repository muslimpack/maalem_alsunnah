import 'package:hive/hive.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_color_settings.dart';

class FormatterColorSettingsRepo {
  final Box box;
  FormatterColorSettingsRepo(this.box);

  ///
  static const String _formatterColorSettingsKey = "formatterColorSettings";

  TextFormatterColorSettings get textFormatterColorSettings {
    final data = box.get(_formatterColorSettingsKey) as String?;
    final defaultValue = TextFormatterColorSettings.normal();
    final result =
        TextFormatterColorSettings.fromJson(data ?? defaultValue.toJson());
    return result;
  }

  Future setTextFormatterColorSettings(
      TextFormatterColorSettings settings) async {
    await box.put(_formatterColorSettingsKey, settings.toJson());
  }
}
