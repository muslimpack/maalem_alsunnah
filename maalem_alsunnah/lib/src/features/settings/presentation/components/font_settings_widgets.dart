import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/string_extension.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';

class FontSettingsIconButton extends StatelessWidget {
  const FontSettingsIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: S.of(context).fontSettings,
      padding: EdgeInsets.zero,
      icon: const FaIcon(FontAwesomeIcons.quoteRight, size: 20),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              contentPadding: EdgeInsets.zero,
              content: FontSettingsToolbox(),
            );
          },
        );
      },
    );
  }
}

class FontSettingsToolbox extends StatelessWidget {
  const FontSettingsToolbox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextSample(),
        FontSettingsBar(),
      ],
    );
  }
}

class FontSettingsBar extends StatelessWidget {
  final bool showFontResizeControllers;
  final bool showDiacriticsControllers;

  const FontSettingsBar({
    super.key,
    this.showFontResizeControllers = true,
    this.showDiacriticsControllers = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (showFontResizeControllers) ...[
          IconButton(
            tooltip: S.of(context).fontResetSize,
            icon: const FaIcon(FontAwesomeIcons.arrowRotateLeft, size: 18),
            onPressed: () {
              context.read<SettingsCubit>().resetFontSize();
            },
          ),
          IconButton(
            tooltip: S.of(context).fontIncreaseSize,
            icon: const FaIcon(FontAwesomeIcons.plus, size: 18),
            onPressed: () {
              context.read<SettingsCubit>().increaseFontSize();
            },
          ),
          IconButton(
            tooltip: S.of(context).fontDecreaseSize,
            icon: const FaIcon(FontAwesomeIcons.minus, size: 18),
            onPressed: () {
              context.read<SettingsCubit>().decreaseFontSize();
            },
          ),
        ],
        if (showDiacriticsControllers)
          // The letter itself shows the state: "بَ" with its fatha when
          // diacritics are shown, a plain "ب" when they are hidden.
          IconButton(
            tooltip: S.of(context).showDiacritics,
            isSelected: context.watch<SettingsCubit>().state.showDiacritics,
            icon: const _DiacriticsGlyph('ب'),
            selectedIcon: const _DiacriticsGlyph('بَ'),
            onPressed: () {
              context.read<SettingsCubit>().toggleDiacriticsStatus();
            },
          ),
      ],
    );
  }
}

/// An Arabic letter drawn at icon size, in the app's Arabic font, so the
/// diacritics toggle can show the mark it controls.
class _DiacriticsGlyph extends StatelessWidget {
  const _DiacriticsGlyph(this.glyph);

  final String glyph;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return SizedBox.square(
      dimension: 24,
      child: Center(
        child: Text(
          glyph,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'adwaa',
            fontSize: 22,
            height: 1,
            color: iconTheme.color,
          ),
        ),
      ),
    );
  }
}

class TextSample extends StatelessWidget {
  const TextSample({super.key});
  static String text = "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلَّ امْرِئٍ مَا نَوَى";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Card(
          child: Container(
            constraints: const BoxConstraints(minHeight: 200),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Text(
                  state.showDiacritics ? text : text.removeDiacritics,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'adwaa',
                    fontSize: state.fontSize * 10,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
