import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/components/pending_report_dialog.dart';

void main() {
  Future<bool?> openDialog(WidgetTester tester, Key button) async {
    bool? answer;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              answer = await showPendingReportDialog(
                context,
                summary: 'Bad state: No element',
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Bad state: No element'), findsOneWidget);

    await tester.tap(find.byKey(button));
    await tester.pumpAndSettle();
    return answer;
  }

  testWidgets('send answers yes', (tester) async {
    expect(await openDialog(tester, PendingReportDialog.sendKey), isTrue);
  });

  testWidgets('not now answers no', (tester) async {
    expect(await openDialog(tester, PendingReportDialog.dismissKey), isFalse);
  });
}
