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

enum Role {
  bishop,
  king,
  knight,
  pawn,
  queen,
  rook,
}

enum PieceColor {
  white,
  black,
  ash,
  slate,
  pink,
  red,
  orange,
  yellow,
  green,
  cyan,
  navy,
  violet,
}

class Piece {
  Role role;
  PieceColor color;

  Piece(this.role, this.color);

  String get name => role == Role.knight ? 'N' : role.name[0].toUpperCase();
}

final pieceColors = {
  PieceColor.white: colors.whitePiece,
  PieceColor.black: colors.blackPiece,
  PieceColor.ash: colors.ashPiece,
  PieceColor.slate: colors.slatePiece,
  PieceColor.pink: colors.pinkPiece,
  PieceColor.red: colors.redPiece,
  PieceColor.orange: colors.orangePiece,
  PieceColor.yellow: colors.yellowPiece,
  PieceColor.green: colors.greenPiece,
  PieceColor.cyan: colors.cyanPiece,
  PieceColor.navy: colors.navyPiece,
  PieceColor.violet: colors.violetPiece,
};

final pieces = {
  'a1': Piece(Role.queen, PieceColor.slate),
  'b1': Piece(Role.bishop, PieceColor.slate),
  'c1': Piece(Role.rook, PieceColor.pink),
  'd1': Piece(Role.knight, PieceColor.pink),
  'e1': Piece(Role.rook, PieceColor.white),
  'f1': Piece(Role.knight, PieceColor.white),
  'g1': Piece(Role.bishop, PieceColor.white),
  'h1': Piece(Role.queen, PieceColor.white),
  'i1': Piece(Role.king, PieceColor.white),
  'j1': Piece(Role.bishop, PieceColor.white),
  'k1': Piece(Role.knight, PieceColor.white),
  'l1': Piece(Role.rook, PieceColor.white),
  'm1': Piece(Role.knight, PieceColor.green),
  'n1': Piece(Role.rook, PieceColor.green),
  'o1': Piece(Role.bishop, PieceColor.ash),
  'p1': Piece(Role.queen, PieceColor.ash),
  'a2': Piece(Role.rook, PieceColor.slate),
  'b2': Piece(Role.knight, PieceColor.slate),
  'c2': Piece(Role.pawn, PieceColor.pink),
  'd2': Piece(Role.pawn, PieceColor.pink),
  'e2': Piece(Role.pawn, PieceColor.white),
  'f2': Piece(Role.pawn, PieceColor.white),
  'g2': Piece(Role.pawn, PieceColor.white),
  'h2': Piece(Role.pawn, PieceColor.white),
  'i2': Piece(Role.pawn, PieceColor.white),
  'j2': Piece(Role.pawn, PieceColor.white),
  'k2': Piece(Role.pawn, PieceColor.white),
  'l2': Piece(Role.pawn, PieceColor.white),
  'm2': Piece(Role.pawn, PieceColor.green),
  'n2': Piece(Role.pawn, PieceColor.green),
  'o2': Piece(Role.knight, PieceColor.ash),
  'p2': Piece(Role.rook, PieceColor.ash),
  'a3': Piece(Role.bishop, PieceColor.red),
  'b3': Piece(Role.pawn, PieceColor.red),
  'o3': Piece(Role.pawn, PieceColor.cyan),
  'p3': Piece(Role.bishop, PieceColor.cyan),
  'a4': Piece(Role.queen, PieceColor.red),
  'b4': Piece(Role.pawn, PieceColor.red),
  'o4': Piece(Role.pawn, PieceColor.cyan),
  'p4': Piece(Role.queen, PieceColor.cyan),
  'a5': Piece(Role.rook, PieceColor.orange),
  'b5': Piece(Role.pawn, PieceColor.orange),
  'o5': Piece(Role.pawn, PieceColor.navy),
  'p5': Piece(Role.rook, PieceColor.navy),
  'a6': Piece(Role.knight, PieceColor.orange),
  'b6': Piece(Role.pawn, PieceColor.orange),
  'o6': Piece(Role.pawn, PieceColor.navy),
  'p6': Piece(Role.knight, PieceColor.navy),
  'a7': Piece(Role.bishop, PieceColor.yellow),
  'b7': Piece(Role.pawn, PieceColor.yellow),
  'o7': Piece(Role.pawn, PieceColor.violet),
  'p7': Piece(Role.bishop, PieceColor.violet),
  'a8': Piece(Role.queen, PieceColor.yellow),
  'b8': Piece(Role.pawn, PieceColor.yellow),
  'o8': Piece(Role.pawn, PieceColor.violet),
  'p8': Piece(Role.queen, PieceColor.violet),
  'a9': Piece(Role.queen, PieceColor.green),
  'b9': Piece(Role.pawn, PieceColor.green),
  'o9': Piece(Role.pawn, PieceColor.pink),
  'p9': Piece(Role.queen, PieceColor.pink),
  'a10': Piece(Role.bishop, PieceColor.green),
  'b10': Piece(Role.pawn, PieceColor.green),
  'o10': Piece(Role.pawn, PieceColor.pink),
  'p10': Piece(Role.bishop, PieceColor.pink),
  'a11': Piece(Role.knight, PieceColor.cyan),
  'b11': Piece(Role.pawn, PieceColor.cyan),
  'o11': Piece(Role.pawn, PieceColor.red),
  'p11': Piece(Role.knight, PieceColor.red),
  'a12': Piece(Role.rook, PieceColor.cyan),
  'b12': Piece(Role.pawn, PieceColor.cyan),
  'o12': Piece(Role.pawn, PieceColor.red),
  'p12': Piece(Role.rook, PieceColor.red),
  'a13': Piece(Role.queen, PieceColor.navy),
  'b13': Piece(Role.pawn, PieceColor.navy),
  'o13': Piece(Role.pawn, PieceColor.orange),
  'p13': Piece(Role.queen, PieceColor.orange),
  'a14': Piece(Role.bishop, PieceColor.navy),
  'b14': Piece(Role.pawn, PieceColor.navy),
  'o14': Piece(Role.pawn, PieceColor.orange),
  'p14': Piece(Role.bishop, PieceColor.orange),
  'a15': Piece(Role.rook, PieceColor.ash),
  'b15': Piece(Role.knight, PieceColor.ash),
  'c15': Piece(Role.pawn, PieceColor.violet),
  'd15': Piece(Role.pawn, PieceColor.violet),
  'e15': Piece(Role.pawn, PieceColor.black),
  'f15': Piece(Role.pawn, PieceColor.black),
  'g15': Piece(Role.pawn, PieceColor.black),
  'h15': Piece(Role.pawn, PieceColor.black),
  'i15': Piece(Role.pawn, PieceColor.black),
  'j15': Piece(Role.pawn, PieceColor.black),
  'k15': Piece(Role.pawn, PieceColor.black),
  'l15': Piece(Role.pawn, PieceColor.black),
  'm15': Piece(Role.pawn, PieceColor.yellow),
  'n15': Piece(Role.pawn, PieceColor.yellow),
  'o15': Piece(Role.knight, PieceColor.slate),
  'p15': Piece(Role.rook, PieceColor.slate),
  'a16': Piece(Role.queen, PieceColor.ash),
  'b16': Piece(Role.bishop, PieceColor.ash),
  'c16': Piece(Role.rook, PieceColor.violet),
  'd16': Piece(Role.knight, PieceColor.violet),
  'e16': Piece(Role.rook, PieceColor.black),
  'f16': Piece(Role.knight, PieceColor.black),
  'g16': Piece(Role.bishop, PieceColor.black),
  'h16': Piece(Role.queen, PieceColor.black),
  'i16': Piece(Role.king, PieceColor.black),
  'j16': Piece(Role.bishop, PieceColor.black),
  'k16': Piece(Role.knight, PieceColor.black),
  'l16': Piece(Role.rook, PieceColor.black),
  'm16': Piece(Role.knight, PieceColor.yellow),
  'n16': Piece(Role.rook, PieceColor.yellow),
  'o16': Piece(Role.bishop, PieceColor.slate),
  'p16': Piece(Role.queen, PieceColor.slate),
};

