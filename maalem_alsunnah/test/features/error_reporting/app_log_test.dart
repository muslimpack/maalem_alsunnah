import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/app_log.dart';

void main() {
  group('AppLog', () {
    test('keeps lines in order, each stamped with its UTC time', () {
      final log = AppLog(capacity: 10);
      log.add('opened home', at: DateTime.utc(2026, 11, 17, 9, 5, 3));
      log.add('opened search', at: DateTime.utc(2026, 11, 17, 9, 5, 4));

      expect(log.lines, [
        '09:05:03 opened home',
        '09:05:04 opened search',
      ]);
    });

    test('drops the oldest line once capacity is reached', () {
      final log = AppLog(capacity: 2);
      final t = DateTime.utc(2026);
      log.add('a', at: t);
      log.add('b', at: t);
      log.add('c', at: t);

      expect(log.lines, ['00:00:00 b', '00:00:00 c']);
    });

    test('a caught error logs its type, place and top frame, not its message',
        () {
      final log = AppLog(capacity: 5);
      log.addCaught(
        const FormatException('no such column: user search text'),
        StackTrace.fromString(
          '#0      SearchCubit.load (search_cubit.dart:140)\n#1 x',
        ),
        where: 'SearchCubit',
        at: DateTime.utc(2026),
      );

      const expected = '00:00:00 caught FormatException in SearchCubit @ '
          '#0      SearchCubit.load (search_cubit.dart:140)';
      expect(log.lines, [expected]);
    });

    test('a multi-line entry stays one line', () {
      final log = AppLog(capacity: 5);
      log.add('error\n#0 main', at: DateTime.utc(2026));

      expect(log.lines, [r'00:00:00 error\n#0 main']);
    });
  });
}
