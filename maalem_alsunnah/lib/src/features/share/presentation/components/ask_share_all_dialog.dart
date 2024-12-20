import 'package:flutter/material.dart';

Future<bool?> showAskShareAllDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    builder: (context) {
      return const AskShareAllDialog();
    },
  );
}

class AskShareAllDialog extends StatelessWidget {
  const AskShareAllDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Share all images"),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("All"),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Current"),
        ),
      ],
    );
  }
}
