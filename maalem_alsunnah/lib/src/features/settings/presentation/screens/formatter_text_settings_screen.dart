import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/components/formatter_color_settings_widgets.dart';

class FormatterColorSettingsScreen extends StatelessWidget {
  static const routeName = '/formatterColorSettings';

  const FormatterColorSettingsScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const FormatterColorSettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).textFormatterColorSettings),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: FormatterColorSettingsTextSample(),
          ),
          Divider(),
          Expanded(child: FormatterColorSettingsToolbox()),
        ],
      ),
    );
  }
}
