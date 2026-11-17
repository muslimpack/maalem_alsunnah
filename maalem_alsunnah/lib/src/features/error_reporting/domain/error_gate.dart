/// Decides whether an uncaught error should open the error screen.
///
/// Layout overflows are cosmetic and only logged. Errors often cascade, so
/// only one screen opens per burst: none while one is open, and none within
/// [burstWindow] after it closes.
class ErrorGate {
  ErrorGate({this.burstWindow = const Duration(seconds: 3)});

  final Duration burstWindow;

  bool _screenOpen = false;
  DateTime? _closedAt;

  /// [silent] is Flutter's own flag for errors it considers non-fatal.
  bool shouldShow(Object error, DateTime now, {bool silent = false}) {
    if (silent || isCosmetic(error)) return false;
    if (_screenOpen) return false;
    final closedAt = _closedAt;
    if (closedAt != null && now.difference(closedAt) < burstWindow) {
      return false;
    }
    _screenOpen = true;
    return true;
  }

  void screenClosed(DateTime now) {
    _screenOpen = false;
    _closedAt = now;
  }

  static bool isCosmetic(Object error) =>
      error.toString().contains(' overflowed by ');
}
