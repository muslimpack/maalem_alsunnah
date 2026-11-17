import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/safe_padding_extension.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/contact_message.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';

extension ContactTypeLabel on ContactType {
  String label(S s) => switch (this) {
        ContactType.featureRequest => s.contactTypeFeatureRequest,
        ContactType.bug => s.contactTypeBug,
        ContactType.contentError => s.contactTypeContentError,
        ContactType.question => s.contactTypeQuestion,
        ContactType.other => s.contactTypeOther,
      };
}

/// Form for writing to the developer: a type, a message, and an opt-in to
/// attach the non-sensitive [DeviceSnapshot].
class ContactScreen extends StatefulWidget {
  const ContactScreen({
    super.key,
    this.initialType,
    required this.loadDevice,
    required this.onSend,
  });

  static const String routeName = "/contact";

  static const typeKey = Key('contact_type');
  static const messageKey = Key('contact_message');
  static const shareDeviceKey = Key('contact_share_device');
  static const sendKey = Key('contact_send');

  final ContactType? initialType;
  final Future<DeviceSnapshot> Function() loadDevice;
  final Future<void> Function(ContactMessage message) onSend;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late ContactType? _type = widget.initialType;
  final _body = TextEditingController();
  bool _shareDevice = true;
  bool _sending = false;
  late final Future<DeviceSnapshot> _device = widget.loadDevice();

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  ContactMessage get _message => ContactMessage(type: _type, body: _body.text);

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      final device = _shareDevice ? await _device : null;
      await widget.onSend(_message.copyWithDevice(device));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final canSend = !_sending && _message.validate().isEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(s.contactDeveloper), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16).withSafeArea(context),
        children: [
          DropdownButtonFormField<ContactType>(
            key: ContactScreen.typeKey,
            initialValue: _type,
            decoration: InputDecoration(
              labelText: s.contactType,
              border: const OutlineInputBorder(),
            ),
            hint: Text(s.contactTypeRequired),
            items: [
              for (final type in ContactType.values)
                DropdownMenuItem(value: type, child: Text(type.label(s))),
            ],
            onChanged: (value) => setState(() => _type = value),
          ),
          const SizedBox(height: 16),
          TextField(
            key: ContactScreen.messageKey,
            controller: _body,
            minLines: 5,
            maxLines: 12,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: s.contactMessage,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              helperText:
                  s.contactMessageTooShort(ContactMessage.minBodyLength),
            ),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            key: ContactScreen.shareDeviceKey,
            contentPadding: EdgeInsets.zero,
            value: _shareDevice,
            onChanged: (value) => setState(() => _shareDevice = value ?? false),
            title: Text(s.contactShareDeviceInfo),
            subtitle: Text(s.contactShareDeviceInfoHint),
          ),
          if (_shareDevice)
            FutureBuilder<DeviceSnapshot>(
              future: _device,
              builder: (context, snapshot) {
                final device = snapshot.data;
                if (device == null) return const LinearProgressIndicator();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        device.lines.join('\n'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: ContactScreen.sendKey,
            onPressed: canSend ? _send : null,
            icon: const Icon(Icons.send),
            label: Text(s.contactSend),
          ),
        ],
      ),
    );
  }
}
