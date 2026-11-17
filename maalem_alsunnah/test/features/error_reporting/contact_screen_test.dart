import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/contact_message.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/contact_screen.dart';

void main() {
  const device = DeviceSnapshot(
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
  );

  Future<List<ContactMessage>> pumpForm(
    WidgetTester tester, {
    ContactType? initialType,
  }) async {
    final sent = <ContactMessage>[];
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
        home: ContactScreen(
          initialType: initialType,
          loadDevice: () async => device,
          onSend: (message) async => sent.add(message),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return sent;
  }

  bool sendEnabled(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byKey(ContactScreen.sendKey)).enabled;

  Future<void> chooseType(WidgetTester tester, String label) async {
    await tester.tap(find.byKey(ContactScreen.typeKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  testWidgets('send stays disabled until a type and message are given',
      (tester) async {
    await pumpForm(tester);
    expect(sendEnabled(tester), isFalse);

    await tester.enterText(
      find.byKey(ContactScreen.messageKey),
      'Please add a night mode',
    );
    await tester.pump();
    expect(sendEnabled(tester), isFalse);

    await chooseType(tester, 'Feature request');
    expect(sendEnabled(tester), isTrue);
  });

  testWidgets('sends the message with device info by default', (tester) async {
    final sent = await pumpForm(tester, initialType: ContactType.bug);

    await tester.enterText(
      find.byKey(ContactScreen.messageKey),
      'The app closes on search',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(ContactScreen.sendKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ContactScreen.sendKey));
    await tester.pumpAndSettle();

    expect(sent, hasLength(1));
    expect(sent.single.type, ContactType.bug);
    expect(sent.single.body, 'The app closes on search');
    expect(sent.single.device, same(device));
  });

  testWidgets('unticking device info sends without it', (tester) async {
    final sent = await pumpForm(tester, initialType: ContactType.question);

    await tester.enterText(
      find.byKey(ContactScreen.messageKey),
      'How do I search by number?',
    );
    await tester.tap(find.byKey(ContactScreen.shareDeviceKey));
    await tester.pump();
    await tester.ensureVisible(find.byKey(ContactScreen.sendKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ContactScreen.sendKey));
    await tester.pumpAndSettle();

    expect(sent.single.device, isNull);
  });

  testWidgets('the preview lists exactly what device info would be sent',
      (tester) async {
    await pumpForm(tester);

    expect(find.textContaining('Device: Google Pixel 8'), findsOneWidget);
    expect(find.textContaining('Platform: android'), findsOneWidget);
  });
}
