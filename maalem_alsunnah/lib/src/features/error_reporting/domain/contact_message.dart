import 'package:maalem_alsunnah/src/core/functions/mailto_uri.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';

enum ContactType { featureRequest, bug, contentError, question, other }

enum ContactProblem { missingType, messageTooShort }

/// A message the user writes to the developer from the contact form.
class ContactMessage {
  const ContactMessage({
    required this.type,
    required this.body,
    this.device,
  });

  static const int minBodyLength = 10;

  final ContactType? type;
  final String body;

  /// Attached only when the user opts in to sharing device info.
  final DeviceSnapshot? device;

  ContactMessage copyWithDevice(DeviceSnapshot? device) =>
      ContactMessage(type: type, body: body, device: device);

  Set<ContactProblem> validate() => {
        if (type == null) ContactProblem.missingType,
        if (body.trim().length < minBodyLength) ContactProblem.messageTooShort,
      };

  Uri toMailUri({
    required String to,
    required String appTitle,
    required String typeLabel,
    required String appVersion,
  }) {
    final device = this.device;
    final text = device == null
        ? body.trim()
        : '${body.trim()}\n\n---\n${device.lines.join('\n')}';
    return mailtoUri(
      to: to,
      subject: '$appTitle | $typeLabel | v$appVersion',
      body: text,
    );
  }
}
