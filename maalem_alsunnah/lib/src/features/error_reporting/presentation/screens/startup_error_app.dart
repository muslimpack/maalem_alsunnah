import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/error_reporter.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/error_screen.dart';

/// Bare app shown when the real app couldn't start or mount its first
/// screen: no theme, storage or translations are assumed to work, so
/// [ErrorScreen] uses its Arabic fallback strings.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.report});

  final ErrorReport report;

  @override
  Widget build(BuildContext context) {
    final reporter = ErrorReporter.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Desktop toasts go through BotToast, which needs its host here too.
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: ErrorScreen(
        report: report,
        onReport: () => reporter.sendReport(report),
        onCopy: () => reporter.copyReport(report),
        onHome: null,
        onContact: reporter.contactPlain,
      ),
    );
  }
}
