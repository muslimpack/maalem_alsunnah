import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/contact_message.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/device_snapshot.dart';

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

  group('ContactMessage.validate', () {
    test('a type and a real message are required', () {
      const message = ContactMessage(type: null, body: ' hi ');
      expect(message.validate(), {
        ContactProblem.missingType,
        ContactProblem.messageTooShort,
      });
    });

    test('a complete message has no problems', () {
      const message = ContactMessage(
        type: ContactType.featureRequest,
        body: 'Please add a night mode',
      );
      expect(message.validate(), isEmpty);
    });
  });

  group('ContactMessage.toMailUri', () {
    test('subject is app | type | version, body percent-encoded', () {
      const message = ContactMessage(
        type: ContactType.bug,
        body: 'Q&A #2\nbroken',
      );

      final uri = message.toMailUri(
        to: 'dev@example.com',
        appTitle: 'Maalem',
        typeLabel: 'Bug',
        appVersion: '0.2.01',
      );

      expect(
        uri.toString(),
        'mailto:dev@example.com'
        '?subject=Maalem%20%7C%20Bug%20%7C%20v0.2.01'
        '&body=Q%26A%20%232%0Abroken',
      );
    });

    test('device info is appended only when shared', () {
      const withoutDevice = ContactMessage(
        type: ContactType.question,
        body: 'How do I search?',
      );
      final withDevice = withoutDevice.copyWithDevice(device);

      String bodyOf(ContactMessage m) => Uri.decodeComponent(
            m
                .toMailUri(
                  to: 'dev@example.com',
                  appTitle: 'Maalem',
                  typeLabel: 'Question',
                  appVersion: '0.2.01',
                )
                .toString()
                .split('&body=')
                .last,
          );

      expect(bodyOf(withoutDevice), 'How do I search?');
      expect(bodyOf(withDevice), startsWith('How do I search?\n\n---\n'));
      expect(bodyOf(withDevice), contains('Device: Google Pixel 8'));
      expect(bodyOf(withDevice), endsWith('Theme: light'));
    });
  });
}
