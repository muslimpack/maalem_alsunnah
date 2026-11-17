import 'package:flutter/services.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/core/functions/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the user's mail app. If none can open it, copies [fallbackText]
/// and tells the user where to send it, so a written message is never lost.
Future<void> openMail(Uri uri, {required String fallbackText}) async {
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (opened) return;

  await Clipboard.setData(ClipboardData(text: fallbackText));
  String message;
  try {
    message = S.current.contactNoEmailApp(kOrgEmail);
  } catch (_) {
    // Localization may not have loaded (startup failure).
    message = 'لم يُعثر على تطبيق بريد، تم نسخ الرسالة. أرسلها إلى $kOrgEmail';
  }
  try {
    await showToast(msg: message);
  } catch (_) {
    // No toast host (e.g. a bare error app); the clipboard copy still stands.
  }
}
