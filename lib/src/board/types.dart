import 'package:flutter/material.dart';

import '../piece.dart' as piece;
import '../square_key.dart';
import 'config.dart';

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

final pieceColors = {
  piece.Color.white: colors.whitePiece,
  piece.Color.black: colors.blackPiece,
  piece.Color.ash: colors.ashPiece,
  piece.Color.slate: colors.slatePiece,
  piece.Color.pink: colors.pinkPiece,
  piece.Color.red: colors.redPiece,
  piece.Color.orange: colors.orangePiece,
  piece.Color.yellow: colors.yellowPiece,
  piece.Color.green: colors.greenPiece,
  piece.Color.cyan: colors.cyanPiece,
  piece.Color.navy: colors.navyPiece,
  piece.Color.violet: colors.violetPiece,
};
