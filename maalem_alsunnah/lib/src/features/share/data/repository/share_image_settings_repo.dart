import 'package:hive/hive.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_settings.dart';

class ShareImageSettingsRepo {
  final Box box;
  ShareImageSettingsRepo(this.box);

  static const String _settingsKey = "prefShareImageSettings";

  ShareImageSettings get settings {
    final data = box.get(_settingsKey) as String?;
    if (data == null) return const ShareImageSettings.defaults();
    try {
      return ShareImageSettings.fromJson(data);
    } catch (_) {
      return const ShareImageSettings.defaults();
    }
  }

  Future<void> setSettings(ShareImageSettings settings) async {
    await box.put(_settingsKey, settings.toJson());
  }
}
