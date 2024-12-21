import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Future<T?> push<T extends Object?>(Widget route) async {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) {
          return route;
        },
      ),
    );
  }

  Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? arguments}) async {
    return Navigator.of(this).pushNamed(
      routeName,
      arguments: arguments,
    );
  }
}
