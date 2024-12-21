import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/sub_titles_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/home_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/about_screen.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    if (settings.name == SubTitlesViewerScreen.routeName) {
      return SubTitlesViewerScreen.route(settings.arguments as TitleModel);
    } else if (settings.name == ContentViewerScreen.routeName) {
      return ContentViewerScreen.route(settings.arguments as TitleModel);
    } else if (settings.name == SettingsScreen.routeName) {
      return SettingsScreen.route();
    } else if (settings.name == AboutScreen.routeName) {
      return AboutScreen.route();
    }
    return HomeScreen.route();
  }
}
