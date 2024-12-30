// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/core/functions/open_url.dart';
import 'package:maalem_alsunnah/src/core/models/email.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith.dart';

class EmailManager {
  static void messageUS() {
    sendEmail(
      email: Email(
        subject: S.current.chat,
        body: '',
      ),
    );
  }

  static Future sendMisspelled({
    required Hadith hadith,
  }) async {
    await sendEmail(
      email: Email(
        subject: S.current.misspelled,
        body: '''
رقم الحديث: ${hadith.id}
${hadith.narrator}${hadith.narratorReference.isNotEmpty ? "(${hadith.narratorReference})" : ""}
-------

${hadith.hadith}

-------
المرتبة: ${hadith.rank}

======= =======

''',
      ),
    );
  }

  static Future<void> sendEmail({
    required Email email,
  }) async {
    final emailToSend = email.copyWith(
      subject: "${S.current.appTitle} | ${email.subject} | v$kAppVersion",
    );

    final uri = emailToSend.getURI;

    await openURL(uri);
  }
}
