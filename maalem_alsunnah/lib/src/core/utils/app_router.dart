import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/sub_titles_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/home_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    if (settings.name == SubTitlesViewerScreen.routeName) {
      return SubTitlesViewerScreen.route(settings.arguments as TitleModel);
    } else if (settings.name == ContentViewerScreen.routeName) {
      return ContentViewerScreen.route(settings.arguments as TitleModel);
    }
    return HomeScreen.route();
  }
}
