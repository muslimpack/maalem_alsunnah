import 'package:flutter/material.dart';

///   والحديث الصحيح مراتبه هي (صحيح، صحيح لغيره، حسن، حسن لغيره)
///   والحديث الضعيف (ضعيف، مرسل صحيح، مرسل حسن، مرسل ضعيف)
///   والحديث المتروك (ضعيف جدا، مرسل ضعيف جدا)
///   والحديث المكذوب (مكذوب)

enum HadithRulingEnum {
  authentic(
    id: 1,
    title: "صحيح",
    color: Colors.green,
  ),
  weak(
    id: 2,
    title: "ضعيف",
    color: Colors.yellow,
  ),
  abandoned(
    id: 3,
    title: "متروك",
    color: Colors.orange,
  ),
  fabricated(
    id: 4,
    title: "مكذوب",
    color: Colors.red,
  ),
  ;

  const HadithRulingEnum({
    required this.id,
    required this.title,
    required this.color,
  });

  static HadithRulingEnum fromString(String rulingText) {
    return HadithRulingEnum.values.where((e) => e.title == rulingText).first;
  }

  final int id;
  final String title;
  final Color color;
}
