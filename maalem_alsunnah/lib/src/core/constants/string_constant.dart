part of 'constant.dart';

const Iterable<int> arabicDiacriticsChar = [
  1617,
  124,
  1614,
  124,
  1611,
  124,
  1615,
  124,
  1612,
  124,
  1616,
  124,
  1613,
  124,
  1618,
];

final RegExp arabicDiacriticsRegx = RegExp(
  r'[\u0610-\u061A\u064B-\u065F\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]',
);
