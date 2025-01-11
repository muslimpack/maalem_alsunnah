import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/components/font_settings_widgets.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/about_screen.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/formatter_text_settings_screen.dart';
import 'package:maalem_alsunnah/src/features/themes/presentation/controller/cubit/theme_cubit.dart';
import 'package:maalem_alsunnah/src/features/themes/presentation/screens/themes_manager_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String routeName = "/settings";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).settings),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              ListTile(
                title: Text(S.of(context).theme),
                leading: Icon(Icons.color_lens),
                onTap: () => context.pushNamed(ThemeManagerScreen.routeName),
              ),
              ListTile(
                title: Text(S.of(context).textFormatterColorSettings),
                leading: Icon(Icons.brush_outlined),
                onTap: () =>
                    context.pushNamed(FormatterColorSettingsScreen.routeName),
              ),

              ///TODO(001) uncomment when add translation for whole app
              /*  ListTile(
                title: Text(S.of(context).prefAppLanguage),
                subtitle: Wrap(
                  children: List.generate(
                    S.delegate.supportedLocales.length,
                    (index) {
                      final locale = S.delegate.supportedLocales[index];

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ToggleButton(
                          label: Text(locale.languageCode),
                          selected:
                              state.locale?.languageCode == locale.languageCode,
                          showCheckmark: false,
                          onSelected: (value) {
                            context
                                .read<ThemeCubit>()
                                .changeAppLocale(locale.languageCode);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ), */
              const Divider(),
              const FontSettingsToolbox(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(S.of(context).aboutApp),
                onTap: () {
                  context.pushNamed(AboutScreen.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
