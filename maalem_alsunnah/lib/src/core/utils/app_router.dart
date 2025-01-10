import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/home_screen.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/about_screen.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/screens/share_as_image_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    if (settings.name == ContentViewerScreen.routeName) {
      final Map args = settings.arguments as Map;
      return ContentViewerScreen.route(
        titleId: args["titleId"] as int,
        viewAsContent: args["viewAsContent"] as bool? ?? false,
      );
    } else if (settings.name == SettingsScreen.routeName) {
      return SettingsScreen.route();
    } else if (settings.name == AboutScreen.routeName) {
      return AboutScreen.route();
    } else if (settings.name == ShareAsImageScreen.routeName) {
      final Map args = settings.arguments as Map;
      return ShareAsImageScreen.route(
        itemId: args["itemId"],
        shareType: args["shareType"],
      );
    }
    return HomeScreen.route();
  }
}
