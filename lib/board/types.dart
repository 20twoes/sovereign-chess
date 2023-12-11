import 'package:flutter/material.dart';

import 'config.dart';

enum File {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h,
  i,
  j,
  k,
  l,
  m,
  n,
  o,
  p,
}

final files = File.values.map((f) => f.name);

//enum Rank {
//  1,
//  2,
//  3,
//  4,
//  5,
//  6,
//  7,
//  8,
//  9,
//  10,
//  11,
//  12,
//  13,
//  14,
//  15,
//  16,
//}

final ranks = List<String>.generate(
  16,
  (int index) => '${index + 1}',
  growable: false,
);

final coloredSquares = {
  'h9': colors.whiteSquare,
  'i8': colors.whiteSquare,
  'h8': colors.blackSquare,
  'i9': colors.blackSquare,
  'g7': colors.ashSquare,
  'j10': colors.ashSquare,
  'g10': colors.slateSquare,
  'j7': colors.slateSquare,
  'h11': colors.pinkSquare,
  'i6': colors.pinkSquare,
  'e12': colors.redSquare,
  'l5': colors.redSquare,
  'f9': colors.orangeSquare,
  'k8': colors.orangeSquare,
  'f11': colors.yellowSquare,
  'k6': colors.yellowSquare,
  'f6': colors.greenSquare,
  'k11': colors.greenSquare,
  'f8': colors.cyanSquare,
  'k9': colors.cyanSquare,
  'e5': colors.navySquare,
  'l12': colors.navySquare,
  'h6': colors.violetSquare,
  'i11': colors.violetSquare,
};

//Color getColor = (r, c) {
//  if (c % 2 != 0) {
//    return r % 2 == 0 ? 'dark' : 'light';
//  } else {
//    return r % 2 == 0 ? 'light' : 'dark';
//  }
//};

Color? getSquareColor(String squareName) {
      //color == 'dark' ? colors.darkSquare : colors.lightSquare;
  return coloredSquares[squareName];
}
