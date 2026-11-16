import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/utils/rich_text_controller.dart';

/// Bold / italic / underline / strikethrough toggles for a [RichTextController].
///
/// Wrapped in a [TextFieldTapRegion] so tapping a button does not unfocus the
/// text field (and lose the selection) on desktop.
class TextStylingBar extends StatelessWidget {
  final RichTextController controller;

  const TextStylingBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colors = Theme.of(context).colorScheme;
    final style = ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? colors.primaryContainer : null,
      ),
    );
    final items = [
      (TextStyleType.bold, Icons.format_bold_rounded, s.bold),
      (TextStyleType.italic, Icons.format_italic_rounded, s.italic),
      (TextStyleType.underline, Icons.format_underlined_rounded, s.underline),
      (TextStyleType.strikethrough, Icons.strikethrough_s_rounded, s.strikethrough),
    ];

    return TextFieldTapRegion(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            for (final (type, icon, tooltip) in items)
              IconButton(
                tooltip: tooltip,
                isSelected: controller.isStyleActive(type),
                icon: Icon(icon),
                visualDensity: VisualDensity.compact,
                style: style,
                onPressed: () => controller.toggleStyle(type),
              ),
          ],
        ),
      ),
    );
  }
}
