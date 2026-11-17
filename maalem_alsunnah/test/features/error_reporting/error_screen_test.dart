import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/error_screen.dart';

void main() {
  final report = ErrorReport(
    error: 'Bad state: No element',
    stackTrace: StackTrace.fromString('#0 main (file.dart:1)'),
    device: const DeviceSnapshot(
      appVersion: '0.2.01',
      buildNumber: '3',
      platform: 'android',
      osVersion: 'Android 14',
      manufacturer: 'Google',
      model: 'Pixel 8',
      appLocale: 'ar',
      systemLocale: 'ar',
      screenSize: '411x914',
      pixelRatio: 3,
      theme: 'light',
    ),
    recentEvents: const [],
    createdAt: DateTime.utc(2026, 11, 17),
  );

  Future<List<String>> pumpScreen(WidgetTester tester) async {
    final calls = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: ErrorScreen(
          report: report,
          onReport: () => calls.add('report'),
          onCopy: () => calls.add('copy'),
          onHome: () => calls.add('home'),
          onContact: () => calls.add('contact'),
        ),
      ),
    );
    return calls;
  }

  testWidgets('each action button calls its own action', (tester) async {
    final calls = await pumpScreen(tester);

    for (final key in [
      ErrorScreen.reportKey,
      ErrorScreen.copyKey,
      ErrorScreen.homeKey,
      ErrorScreen.contactKey,
    ]) {
      await tester.ensureVisible(find.byKey(key));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(key));
    }

    expect(calls, ['report', 'copy', 'home', 'contact']);
  });

  testWidgets('details stay hidden until asked for, then show the report',
      (tester) async {
    await pumpScreen(tester);

    expect(find.textContaining('#0 main (file.dart:1)'), findsNothing);

    await tester.ensureVisible(find.byKey(ErrorScreen.detailsKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ErrorScreen.detailsKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('#0 main (file.dart:1)'), findsOneWidget);
    expect(find.textContaining('Device: Google Pixel 8'), findsOneWidget);
  });

  testWidgets('the error summary is shown up front', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Bad state: No element'), findsOneWidget);
  });
}
