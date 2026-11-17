import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_gate.dart';

void main() {
  final t0 = DateTime.utc(2026, 11, 17, 10);

  group('ErrorGate', () {
    test('an unexpected error opens the screen', () {
      final gate = ErrorGate();
      expect(gate.shouldShow(StateError('boom'), t0), isTrue);
    });

    test('layout overflow errors are only logged', () {
      final gate = ErrorGate();
      final overflow = FlutterError(
        'A RenderFlex overflowed by 12 pixels on the right.',
      );
      expect(gate.shouldShow(overflow, t0), isFalse);
    });

    test('errors the framework marks silent are only logged', () {
      final gate = ErrorGate();
      expect(gate.shouldShow(StateError('quiet'), t0, silent: true), isFalse);
    });

    test('while the screen is open, further errors do not stack screens', () {
      final gate = ErrorGate();
      gate.shouldShow(StateError('first'), t0);

      expect(
        gate.shouldShow(
            StateError('cascade'), t0.add(const Duration(minutes: 5))),
        isFalse,
      );
    });

    test('errors right after the screen closes belong to the same burst', () {
      final gate = ErrorGate(burstWindow: const Duration(seconds: 2));
      gate.shouldShow(StateError('first'), t0);
      gate.screenClosed(t0.add(const Duration(seconds: 10)));

      expect(
        gate.shouldShow(
            StateError('late'), t0.add(const Duration(seconds: 11))),
        isFalse,
      );
    });

    test('a new error after the burst window opens the screen again', () {
      final gate = ErrorGate(burstWindow: const Duration(seconds: 2));
      gate.shouldShow(StateError('first'), t0);
      gate.screenClosed(t0.add(const Duration(seconds: 10)));

      expect(
        gate.shouldShow(StateError('new'), t0.add(const Duration(seconds: 14))),
        isTrue,
      );
    });
  });
}
