import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/models/wrapped.dart';
import 'package:maalem_alsunnah/src/core/shared/color_dialog.dart';
import 'package:maalem_alsunnah/src/core/shared/yes_no_dialog.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_color_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_format_text_style.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class FormatterColorSettingsToolbox extends StatelessWidget {
  const FormatterColorSettingsToolbox({super.key});

  @override
  Widget build(BuildContext context) {
    void updateColor(Color? newColor, String colorType,
        TextFormatterColorSettings settings) {
      switch (colorType) {
        case 'defaultColor':
          context.read<SettingsCubit>().changFormatterColorSettings(
                settings: settings.copyWith(
                  defaultColor: Wrapped.value(newColor),
                ),
              );
          break;
        case 'hadithTextColor':
          context.read<SettingsCubit>().changFormatterColorSettings(
                settings: settings.copyWith(
                  hadithTextColor: Wrapped.value(newColor),
                ),
              );
          break;
        case 'quranTextColor':
          context.read<SettingsCubit>().changFormatterColorSettings(
                settings: settings.copyWith(
                  quranTextColor: Wrapped.value(newColor),
                ),
              );
          break;
        case 'squareBracketsColor':
          context.read<SettingsCubit>().changFormatterColorSettings(
                settings: settings.copyWith(
                  squareBracketsColor: Wrapped.value(newColor),
                ),
              );
          break;
        case 'roundBracketsColor':
          context.read<SettingsCubit>().changFormatterColorSettings(
                settings: settings.copyWith(
                  roundBracketsColor: Wrapped.value(newColor),
                ),
              );
          break;
        case 'startingNumberColor':
          context.read<SettingsCubit>().changFormatterColorSettings(
                settings: settings.copyWith(
                  startingNumberColor: Wrapped.value(newColor),
                ),
              );
          break;
      }
    }

    Widget buildColorPicker(String label, String subTitle, Color? currentColor,
        ValueChanged<Color?> onColorChanged) {
      return ListTile(
        leading: Icon(Icons.brush_outlined),
        title: Text(label),
        subtitle: Text(subTitle),
        trailing: CircleAvatar(
          backgroundColor: currentColor,
        ),
        onTap: () async {
          final pickedColor = await showColorSelectionDialog(
            context,
            currentColor ?? Colors.black,
          );

          if (pickedColor != null) {
            onColorChanged(pickedColor);
          }
        },
      );
    }

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final currentSettings = state.formatterColorSettings;
        return ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text(S.of(context).reset),
              onTap: () async {
                final confirm =
                    await showYesOrNoDialog(context, S.of(context).reset);
                if (confirm != true) return;
                if (!context.mounted) return;
                context.read<SettingsCubit>().resetFormatterColorSettings();
              },
            ),
            // buildColorPicker(
            //   'Default Color',
            //   'Default Color',
            //   currentSettings.defaultColor,
            //   (color) => updateColor(color, 'defaultColor', currentSettings),
            // ),
            buildColorPicker(
              S.of(context).hadithTextColor,
              '«  »',
              currentSettings.hadithTextColor,
              (color) => updateColor(color, 'hadithTextColor', currentSettings),
            ),
            buildColorPicker(
              S.of(context).quranTextColor,
              '﴿  ﴾',
              currentSettings.quranTextColor,
              (color) => updateColor(color, 'quranTextColor', currentSettings),
            ),
            buildColorPicker(
              S.of(context).squareBracketsColor,
              '[  ]',
              currentSettings.squareBracketsColor,
              (color) =>
                  updateColor(color, 'squareBracketsColor', currentSettings),
            ),
            buildColorPicker(
              S.of(context).roundBracketsColor,
              '(  )',
              currentSettings.roundBracketsColor,
              (color) =>
                  updateColor(color, 'roundBracketsColor', currentSettings),
            ),
            buildColorPicker(
              S.of(context).startingNumberColor,
              '123456789',
              currentSettings.startingNumberColor,
              (color) =>
                  updateColor(color, 'startingNumberColor', currentSettings),
            ),
          ],
        );
      },
    );
  }
}

class FormatterColorSettingsTextSample extends StatelessWidget {
  const FormatterColorSettingsTextSample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      final settings = hadithTextFormatterSettings(context);
      final formattedText = """
قال تعالى: ﴿وَإِنْ كُنْتُمْ جُنُبًا فَاطَّهَّرُوا﴾. [المائدة:6]

988 - (ق)عَنْ ‌أَبِي هُرَيْرَةَ، عن النبي صلى الله عليه وسلم قَالَ: «حَقٌّ عَلَى كُلِّ مُسْلِمٍ، أَنْ يَغْتَسِلَ فِي كُلِّ سَبْعَةِ أَيَّامٍ يَوْمًا، يَغْسِلُ فِيهِ رَأْسَهُ وَجَسَدَهُ». [خ897/م849]
""";

      return Card(
        child: Container(
          constraints: BoxConstraints(minHeight: 200),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
                child: FormattedText(
              text: formattedText,
              settings: settings,
            )),
          ),
        ),
      );
    });
  }
}
