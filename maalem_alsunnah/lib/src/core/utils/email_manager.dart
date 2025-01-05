// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/core/functions/open_url.dart';
import 'package:maalem_alsunnah/src/core/models/email.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';

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
    required HadithModel hadith,
  }) async {
    final StringBuffer sb = StringBuffer();
    sb.writeln("t:${hadith.titleId} | c:${hadith.contentId} | h:${hadith.id}");
    sb.writeln(hadith.text);
    sb.writeln();
    sb.writeln();
    await sendEmail(
      email: Email(
        subject: S.current.misspelled,
        body: sb.toString(),
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
