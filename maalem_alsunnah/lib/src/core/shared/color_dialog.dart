// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';

Future<Color?> showColorSelectionDialog(
    BuildContext context, Color color) async {
  return await showDialog<Color?>(
    context: context,
    builder: (context) => ColorSelectionDialog(color: color),
  );
}

class ColorSelectionDialog extends StatelessWidget {
  final Color color;
  const ColorSelectionDialog({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color selectedColor = color;
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: ColorPicker(
          hexInputBar: true,
          enableAlpha: false,
          pickerColor: selectedColor,
          labelTypes: const [],
          onColorChanged: (value) {
            selectedColor = value;
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(S.of(context).select),
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
        ),
      ],
    );
  }
}
