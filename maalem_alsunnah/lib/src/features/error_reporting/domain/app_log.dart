import 'dart:collection';

/// In-memory ring buffer of recent app events, attached to error reports.
///
/// Holds names only (routes, event types, error messages), never user content.
class AppLog {
  AppLog({this.capacity = 100});

  /// Process-wide log fed by the navigator observer, bloc observer and
  /// error handlers.
  static final AppLog instance = AppLog();

  final int capacity;
  final Queue<String> _lines = Queue<String>();

  List<String> get lines => List.unmodifiable(_lines);

  /// Logs a caught error by type, place and top stack frame only: error
  /// messages can carry user content (search text, stored data).
  void addCaught(
    Object error,
    StackTrace? stack, {
    required String where,
    DateTime? at,
  }) {
    final frame = stack?.toString().split('\n').first.trim() ?? '';
    add(
      'caught ${error.runtimeType} in $where${frame.isEmpty ? '' : ' @ $frame'}',
      at: at,
    );
  }

  void add(String message, {DateTime? at}) {
    final time = (at ?? DateTime.now()).toUtc();
    final stamp = [time.hour, time.minute, time.second]
        .map((e) => e.toString().padLeft(2, '0'))
        .join(':');
    _lines.addLast('$stamp ${message.replaceAll('\n', r'\n')}');
    while (_lines.length > capacity) {
      _lines.removeFirst();
    }
  }
}
