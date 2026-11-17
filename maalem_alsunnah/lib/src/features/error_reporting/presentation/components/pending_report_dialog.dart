import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

/// Asks whether to send a report left over from the last launch.
/// Resolves to true for send, false (or null if dismissed) otherwise.
Future<bool?> showPendingReportDialog(
  BuildContext context, {
  required String summary,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => PendingReportDialog(summary: summary),
  );
}

class PendingReportDialog extends StatelessWidget {
  const PendingReportDialog({super.key, required this.summary});

  static const sendKey = Key('pending_report_send');
  static const dismissKey = Key('pending_report_dismiss');

  final String summary;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AlertDialog(
      title: Text(s.errorPendingTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.errorPendingBody),
          const SizedBox(height: 12),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              summary,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: dismissKey,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(s.errorPendingDismiss),
        ),
        FilledButton(
          key: sendKey,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(s.errorPendingSend),
        ),
      ],
    );
  }
}
