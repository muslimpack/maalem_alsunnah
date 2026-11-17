// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/functions/send_email.dart';
import 'package:maalem_alsunnah/src/core/models/email.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/domain/misspelling_report.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/app_info.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';

class EmailManager {
  static Future sendMisspelled({
    required HadithModel hadith,
    required String correction,
  }) async {
    await sendEmail(
      email: Email(
        subject: S.current.misspelled,
        body: misspellingReportBody(
          hadith: hadith,
          correction: correction,
          correctionLabel: S.current.misspellingCorrection,
          originalLabel: S.current.misspellingOriginal,
        ),
      ),
    );
  }

  static Future<void> sendEmail({
    required Email email,
  }) async {
    final emailToSend = email.copyWith(
      subject: "${S.current.appTitle} | ${email.subject} | v${AppInfo.version}",
    );

    await openMail(emailToSend.uri, fallbackText: emailToSend.body);
  }
}
