import 'package:flutter/widgets.dart';

extension SafePaddingExtension on EdgeInsets {
  /// Adds the system bottom and side insets (Android navigation / gesture bar,
  /// iOS home indicator, landscape side bars) to this padding.
  ///
  /// Use it as the padding of a scroll view: content still scrolls behind the
  /// system bar, but the last item can always be scrolled clear of it.
  /// Inside a [Scaffold] with a `bottomNavigationBar` the bottom inset is
  /// already consumed by that bar, so this adds nothing there.
  EdgeInsets withSafeArea(BuildContext context) {
    final inset = MediaQuery.paddingOf(context);
    return this + EdgeInsets.only(left: inset.left, right: inset.right, bottom: inset.bottom);
  }
}

/// Bottom padding for a bottom sheet: keeps its content above the keyboard
/// when it is open, and above the system navigation bar otherwise.
///
/// (`showModalBottomSheet(useSafeArea: true)` only avoids the *top* inset.)
double sheetBottomInset(BuildContext context) {
  // While the keyboard is up, `padding.bottom` drops to 0, so the sum is
  // max(keyboard, navigation bar).
  return MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom;
}
