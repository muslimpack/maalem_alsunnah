import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/themes/presentation/controller/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeManagerScreen extends StatelessWidget {
  const ThemeManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
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
