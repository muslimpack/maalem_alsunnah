import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:equatable/equatable.dart';

class Email extends Equatable {
  final String mailTo;
  final String subject;
  final String body;

  const Email({
    this.mailTo = kOrgEmail,
    required this.subject,
    required this.body,
  });

  Email copyWith({
    String? mailTo,
    String? subject,
    String? body,
  }) {
    return Email(
      mailTo: mailTo ?? this.mailTo,
      subject: subject ?? this.subject,
      body: body ?? this.body,
    );
  }

  @override
  List<Object> get props => [mailTo, subject, body];
}

extension EmailExt on Email {
  String get getURI => 'mailto:$mailTo?subject=$subject&body=$body';
}
