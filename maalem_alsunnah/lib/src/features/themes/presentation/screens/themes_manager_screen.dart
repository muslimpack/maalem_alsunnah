import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/themes/presentation/controller/cubit/theme_cubit.dart';

class ThemeManagerScreen extends StatelessWidget {
  static const String routeName = "/themes";

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => ThemeManagerScreen(),
    );
  }

  const ThemeManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(S.of(context).theme)),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              SwitchListTile(
                value: state.brightness == Brightness.dark,
                title: Text(S.of(context).prefThemeDarkMode),
                onChanged: (value) {
                  if (state.brightness == Brightness.dark) {
                    context
                        .read<ThemeCubit>()
                        .changeBrightness(Brightness.light);
                  } else {
                    context
                        .read<ThemeCubit>()
                        .changeBrightness(Brightness.dark);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
