import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/app.dart';
import 'package:maalem_alsunnah/init_services.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/error_reporter.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/startup_error_app.dart';

void main() async {
  final reporter = ErrorReporter.instance..install();
  try {
    await initServices();
  } catch (error, stack) {
    WidgetsFlutterBinding.ensureInitialized();
    final report = await reporter.buildReport(error, stack);
    await reporter.keepUntilHandled(report);
    runApp(StartupErrorApp(report: report));
    return;
  }
  // Read before the app runs, so a new error can't be mistaken for it.
  final pending = await reporter.takePendingReport();
  runApp(const App());
  if (pending != null) reporter.offerAfterFirstFrame(pending);
}
