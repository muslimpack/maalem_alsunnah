import 'package:maalem_alsunnah/src/core/extensions/extension_color.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_platform.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType {
  info,
  error,
  warning,
  success,
}

Future<void> showToast({
  required String msg,
  Toast toastLength = Toast.LENGTH_SHORT,
  ToastType type = ToastType.info,
}) async {
  final backgroundColor = switch (type) {
    ToastType.error => Colors.red,
    ToastType.info => Colors.black,
    ToastType.warning => Colors.amber,
    ToastType.success => Colors.green,
  };

  final textColor = backgroundColor.getContrastColor;

  if (PlatformExtension.isDesktop) {
    BotToast.showText(
      text: msg,
      contentColor: backgroundColor.withValues(alpha: .5),
      align: Alignment.bottomCenter,
      textStyle: TextStyle(
        color: textColor,
      ),
      duration: Duration(seconds: toastLength == Toast.LENGTH_SHORT ? 1 : 5),
      contentPadding: const EdgeInsets.all(10),
    );
  } else {
    Fluttertoast.showToast(
      backgroundColor: backgroundColor.withValues(alpha: .5),
      textColor: textColor,
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }
}
