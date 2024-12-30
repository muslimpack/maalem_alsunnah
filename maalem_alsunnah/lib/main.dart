import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/app.dart';
import 'package:maalem_alsunnah/init_services.dart';

void main() async {
  await initServices();
  runApp(const App());
}
