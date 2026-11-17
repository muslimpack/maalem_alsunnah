import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/domain/misspelling_report.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/misspelling_dialog.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';

void main() {
  const hadith = HadithModel(
    id: 'h12',
    titleId: 3,
    contentId: 7,
    orderId: 1,
    count: 0,
    text: 'عن انس قال',
    searchText: 'عن انس قال',
  );

  group('misspellingReportBody', () {
    test('ids, then the correction, then the original text', () {
      expect(
        misspellingReportBody(
          hadith: hadith,
          correction: 'عن أنس قال',
          correctionLabel: 'Correction',
          originalLabel: 'Original text',
        ),
        't:3 | c:7 | h:h12\n'
        '\n'
        'Correction:\n'
        'عن أنس قال\n'
        '\n'
        'Original text:\n'
        'عن انس قال\n',
      );
    });
  });

  group('MisspellingDialog', () {
    Future<List<String?>> openDialog(WidgetTester tester) async {
      final results = <String?>[];
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  results.add(await showMisspellingDialog(context)),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return results;
    }

    bool sendEnabled(WidgetTester tester) => tester
        .widget<FilledButton>(find.byKey(MisspellingDialog.sendKey))
        .enabled;

    testWidgets('send is disabled while the correction is blank',
        (tester) async {
      await openDialog(tester);
      expect(sendEnabled(tester), isFalse);

      await tester.enterText(find.byKey(MisspellingDialog.fieldKey), '   ');
      await tester.pump();
      expect(sendEnabled(tester), isFalse);
    });

    testWidgets('send returns the trimmed correction', (tester) async {
      final results = await openDialog(tester);

      await tester.enterText(
        find.byKey(MisspellingDialog.fieldKey),
        '  عن أنس  ',
      );
      await tester.pump();
      await tester.tap(find.byKey(MisspellingDialog.sendKey));
      await tester.pumpAndSettle();

      expect(results, ['عن أنس']);
    });

    testWidgets('cancel returns nothing', (tester) async {
      final results = await openDialog(tester);

      await tester.enterText(find.byKey(MisspellingDialog.fieldKey), 'x');
      await tester.tap(find.byKey(MisspellingDialog.cancelKey));
      await tester.pumpAndSettle();

      expect(results, [null]);
    });
  });
}
