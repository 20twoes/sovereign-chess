import 'package:flutter/material.dart';

import 'config.dart';
import 'types.dart';

class Board extends StatelessWidget {
  Board({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: files.length,
      children: _generateSquares(),
    );
  }

  List<Widget> _generateSquares() {
    List<Widget> list = [];
    final getColor = (r, c) {
      if (c % 2 != 0) {
        return r % 2 == 0 ? 'dark' : 'light';
      } else {
        return r % 2 == 0 ? 'light' : 'dark';
      }
    };

    for (final (rankIndex, rank) in ranks.reversed.indexed) {
      for (var (fileIndex, file) in files.indexed) {
        final name = '${file}${rank}';
        Piece? piece = pieces[name];

        list.add(SquareWidget(
          name: name,
          color: getColor(rankIndex, fileIndex),
          piece: piece,
        ));
      }
    }
    return list;
  }
}

const textStyle = TextStyle(
  color: Colors.pinkAccent,
  decoration: TextDecoration.none,
  fontSize: 10,
  fontWeight: FontWeight.normal,
);

class SquareWidget extends StatelessWidget {
  final String color;
  final String name;
  Piece? piece;

  SquareWidget({
    super.key,
    required this.color,
    required this.name,
    this.piece,
  });

  @override
  Widget build(BuildContext context) {
    var bgColor = getSquareColor(name);
    if (bgColor == null) {
      bgColor = color == 'dark' ? colors.darkSquare : colors.lightSquare;
    }

    return Container(
      child: Column(
        children: [
          Text(
            name,
            style: textStyle,
          ),
          if (piece != null) Expanded(
            child: Center(
              child: Text(
                '${piece?.name}',
                style: TextStyle(
                  color: pieceColors[piece?.color],
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0.0, color: Colors.black26),
        color: bgColor,
      ),
    );
  }
}

enum Role {
  bishop,
  king,
  knight,
  pawn,
  queen,
  rook,
}

enum Color {
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
  Color color;

  Piece(this.role, this.color);

  String get name => role == Role.knight ? 'N' : role.name[0].toUpperCase();
}

final pieceColors = {
  Color.white: colors.whitePiece,
  Color.black: colors.blackPiece,
  Color.ash: colors.ashPiece,
  Color.slate: colors.slatePiece,
  Color.pink: colors.pinkPiece,
  Color.red: colors.redPiece,
  Color.orange: colors.orangePiece,
  Color.yellow: colors.yellowPiece,
  Color.green: colors.greenPiece,
  Color.cyan: colors.cyanPiece,
  Color.navy: colors.navyPiece,
  Color.violet: colors.violetPiece,
};

final pieces = {
  'a1': Piece(Role.queen, Color.slate),
  'b1': Piece(Role.bishop, Color.slate),
  'c1': Piece(Role.rook, Color.pink),
  'd1': Piece(Role.knight, Color.pink),
  'e1': Piece(Role.rook, Color.white),
  'f1': Piece(Role.knight, Color.white),
  'g1': Piece(Role.bishop, Color.white),
  'h1': Piece(Role.queen, Color.white),
  'i1': Piece(Role.king, Color.white),
  'j1': Piece(Role.bishop, Color.white),
  'k1': Piece(Role.knight, Color.white),
  'l1': Piece(Role.rook, Color.white),
  'm1': Piece(Role.knight, Color.green),
  'n1': Piece(Role.rook, Color.green),
  'o1': Piece(Role.bishop, Color.ash),
  'p1': Piece(Role.queen, Color.ash),
  'a2': Piece(Role.rook, Color.slate),
  'b2': Piece(Role.knight, Color.slate),
  'c2': Piece(Role.pawn, Color.pink),
  'd2': Piece(Role.pawn, Color.pink),
  'e2': Piece(Role.pawn, Color.white),
  'f2': Piece(Role.pawn, Color.white),
  'g2': Piece(Role.pawn, Color.white),
  'h2': Piece(Role.pawn, Color.white),
  'i2': Piece(Role.pawn, Color.white),
  'j2': Piece(Role.pawn, Color.white),
  'k2': Piece(Role.pawn, Color.white),
  'l2': Piece(Role.pawn, Color.white),
  'm2': Piece(Role.pawn, Color.green),
  'n2': Piece(Role.pawn, Color.green),
  'o2': Piece(Role.knight, Color.ash),
  'p2': Piece(Role.rook, Color.ash),
  'a3': Piece(Role.bishop, Color.red),
  'b3': Piece(Role.pawn, Color.red),
  'o3': Piece(Role.pawn, Color.cyan),
  'p3': Piece(Role.bishop, Color.cyan),
  'a4': Piece(Role.queen, Color.red),
  'b4': Piece(Role.pawn, Color.red),
  'o4': Piece(Role.pawn, Color.cyan),
  'p4': Piece(Role.queen, Color.cyan),
  'a5': Piece(Role.rook, Color.orange),
  'b5': Piece(Role.pawn, Color.orange),
  'o5': Piece(Role.pawn, Color.navy),
  'p5': Piece(Role.rook, Color.navy),
  'a6': Piece(Role.knight, Color.orange),
  'b6': Piece(Role.pawn, Color.orange),
  'o6': Piece(Role.pawn, Color.navy),
  'p6': Piece(Role.knight, Color.navy),
  'a7': Piece(Role.bishop, Color.yellow),
  'b7': Piece(Role.pawn, Color.yellow),
  'o7': Piece(Role.pawn, Color.violet),
  'p7': Piece(Role.bishop, Color.violet),
  'a8': Piece(Role.queen, Color.yellow),
  'b8': Piece(Role.pawn, Color.yellow),
  'o8': Piece(Role.pawn, Color.violet),
  'p8': Piece(Role.queen, Color.violet),
  'a9': Piece(Role.queen, Color.green),
  'b9': Piece(Role.pawn, Color.green),
  'o9': Piece(Role.pawn, Color.pink),
  'p9': Piece(Role.queen, Color.pink),
  'a10': Piece(Role.bishop, Color.green),
  'b10': Piece(Role.pawn, Color.green),
  'o10': Piece(Role.pawn, Color.pink),
  'p10': Piece(Role.bishop, Color.pink),
  'a11': Piece(Role.knight, Color.cyan),
  'b11': Piece(Role.pawn, Color.cyan),
  'o11': Piece(Role.pawn, Color.red),
  'p11': Piece(Role.knight, Color.red),
  'a12': Piece(Role.rook, Color.cyan),
  'b12': Piece(Role.pawn, Color.cyan),
  'o12': Piece(Role.pawn, Color.red),
  'p12': Piece(Role.rook, Color.red),
  'a13': Piece(Role.queen, Color.navy),
  'b13': Piece(Role.pawn, Color.navy),
  'o13': Piece(Role.pawn, Color.orange),
  'p13': Piece(Role.queen, Color.orange),
  'a14': Piece(Role.bishop, Color.navy),
  'b14': Piece(Role.pawn, Color.navy),
  'o14': Piece(Role.pawn, Color.orange),
  'p14': Piece(Role.bishop, Color.orange),
  'a15': Piece(Role.rook, Color.ash),
  'b15': Piece(Role.knight, Color.ash),
  'c15': Piece(Role.pawn, Color.violet),
  'd15': Piece(Role.pawn, Color.violet),
  'e15': Piece(Role.pawn, Color.black),
  'f15': Piece(Role.pawn, Color.black),
  'g15': Piece(Role.pawn, Color.black),
  'h15': Piece(Role.pawn, Color.black),
  'i15': Piece(Role.pawn, Color.black),
  'j15': Piece(Role.pawn, Color.black),
  'k15': Piece(Role.pawn, Color.black),
  'l15': Piece(Role.pawn, Color.black),
  'm15': Piece(Role.pawn, Color.yellow),
  'n15': Piece(Role.pawn, Color.yellow),
  'o15': Piece(Role.knight, Color.slate),
  'p15': Piece(Role.rook, Color.slate),
  'a16': Piece(Role.queen, Color.ash),
  'b16': Piece(Role.bishop, Color.ash),
  'c16': Piece(Role.rook, Color.violet),
  'd16': Piece(Role.knight, Color.violet),
  'e16': Piece(Role.rook, Color.black),
  'f16': Piece(Role.knight, Color.black),
  'g16': Piece(Role.bishop, Color.black),
  'h16': Piece(Role.queen, Color.black),
  'i16': Piece(Role.king, Color.black),
  'j16': Piece(Role.bishop, Color.black),
  'k16': Piece(Role.knight, Color.black),
  'l16': Piece(Role.rook, Color.black),
  'm16': Piece(Role.knight, Color.yellow),
  'n16': Piece(Role.rook, Color.yellow),
  'o16': Piece(Role.bishop, Color.slate),
  'p16': Piece(Role.queen, Color.slate),
};

