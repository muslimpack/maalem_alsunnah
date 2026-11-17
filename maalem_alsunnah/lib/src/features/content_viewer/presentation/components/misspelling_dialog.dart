import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

/// Asks for the corrected text before a misspelling report is sent, so no
/// empty report reaches the developer. Returns the trimmed correction, or
/// `null` if the user cancelled.
Future<String?> showMisspellingDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const MisspellingDialog(),
  );
}

class MisspellingDialog extends StatefulWidget {
  const MisspellingDialog({super.key});

  static const fieldKey = Key('misspelling_field');
  static const sendKey = Key('misspelling_send');
  static const cancelKey = Key('misspelling_cancel');

  @override
  State<MisspellingDialog> createState() => _MisspellingDialogState();
}

class _MisspellingDialogState extends State<MisspellingDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _correction => _controller.text.trim();

  void _send() => Navigator.of(context).pop(_correction);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final canSend = _correction.isNotEmpty;

    return AlertDialog(
      title: Text(s.reportMisspelled),
      content: SizedBox(
        width: 480,
        child: TextField(
          key: MisspellingDialog.fieldKey,
          controller: _controller,
          autofocus: true,
          minLines: 3,
          maxLines: 8,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: s.misspellingCorrection,
            hintText: s.misspellingCorrectionHint,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          key: MisspellingDialog.cancelKey,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        FilledButton(
          key: MisspellingDialog.sendKey,
          onPressed: canSend ? _send : null,
          child: Text(s.contactSend),
        ),
      ],
    );
  }
}
