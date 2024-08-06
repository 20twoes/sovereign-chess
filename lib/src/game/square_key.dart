import 'package:flutter/material.dart' as material;

import 'config.dart';
import 'piece.dart';

// Square name: File + Rank
// Deprecated:  Use Square enum
typedef Key = String;

const boardWidth = 16;
const boardSize = boardWidth * boardWidth;

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

enum Rank {
  R1,
  R2,
  R3,
  R4,
  R5,
  R6,
  R7,
  R8,
  R9,
  R10,
  R11,
  R12,
  R13,
  R14,
  R15,
  R16,
}

final ranks = List<String>.generate(
  16,
  (int index) => (index + 1).toString().padLeft(2, '0'),
  growable: false,
);

List<String> buildKeys() {
  var result = <String>[];
  for (final file in files) {
    final row = ranks.map((r) => file + r);
    result = [...result, ...row];
  }
  return result;
}

final allKeys = buildKeys();

//Key posToKey(int col, int row) => allKeys[boardWidth * col + row];

enum Square {
  A1,
  B1,
  C1,
  D1,
  E1,
  F1,
  G1,
  H1,
  I1,
  J1,
  K1,
  L1,
  M1,
  N1,
  O1,
  P1,
  A2,
  B2,
  C2,
  D2,
  E2,
  F2,
  G2,
  H2,
  I2,
  J2,
  K2,
  L2,
  M2,
  N2,
  O2,
  P2,
  A3,
  B3,
  C3,
  D3,
  E3,
  F3,
  G3,
  H3,
  I3,
  J3,
  K3,
  L3,
  M3,
  N3,
  O3,
  P3,
  A4,
  B4,
  C4,
  D4,
  E4,
  F4,
  G4,
  H4,
  I4,
  J4,
  K4,
  L4,
  M4,
  N4,
  O4,
  P4,
  A5,
  B5,
  C5,
  D5,
  E5,
  F5,
  G5,
  H5,
  I5,
  J5,
  K5,
  L5,
  M5,
  N5,
  O5,
  P5,
  A6,
  B6,
  C6,
  D6,
  E6,
  F6,
  G6,
  H6,
  I6,
  J6,
  K6,
  L6,
  M6,
  N6,
  O6,
  P6,
  A7,
  B7,
  C7,
  D7,
  E7,
  F7,
  G7,
  H7,
  I7,
  J7,
  K7,
  L7,
  M7,
  N7,
  O7,
  P7,
  A8,
  B8,
  C8,
  D8,
  E8,
  F8,
  G8,
  H8,
  I8,
  J8,
  K8,
  L8,
  M8,
  N8,
  O8,
  P8,
  A9,
  B9,
  C9,
  D9,
  E9,
  F9,
  G9,
  H9,
  I9,
  J9,
  K9,
  L9,
  M9,
  N9,
  O9,
  P9,
  A10,
  B10,
  C10,
  D10,
  E10,
  F10,
  G10,
  H10,
  I10,
  J10,
  K10,
  L10,
  M10,
  N10,
  O10,
  P10,
  A11,
  B11,
  C11,
  D11,
  E11,
  F11,
  G11,
  H11,
  I11,
  J11,
  K11,
  L11,
  M11,
  N11,
  O11,
  P11,
  A12,
  B12,
  C12,
  D12,
  E12,
  F12,
  G12,
  H12,
  I12,
  J12,
  K12,
  L12,
  M12,
  N12,
  O12,
  P12,
  A13,
  B13,
  C13,
  D13,
  E13,
  F13,
  G13,
  H13,
  I13,
  J13,
  K13,
  L13,
  M13,
  N13,
  O13,
  P13,
  A14,
  B14,
  C14,
  D14,
  E14,
  F14,
  G14,
  H14,
  I14,
  J14,
  K14,
  L14,
  M14,
  N14,
  O14,
  P14,
  A15,
  B15,
  C15,
  D15,
  E15,
  F15,
  G15,
  H15,
  I15,
  J15,
  K15,
  L15,
  M15,
  N15,
  O15,
  P15,
  A16,
  B16,
  C16,
  D16,
  E16,
  F16,
  G16,
  H16,
  I16,
  J16,
  K16,
  L16,
  M16,
  N16,
  O16,
  P16;

  material.Color get backgroundColor {
    var bgColor = coloredSquares[this];

    if (bgColor == null) {
      final rank = this.index ~/ boardWidth;

      if (rank % 2 == 0) {
        bgColor = this.index % 2 == 0 ? colors.darkSquare : colors.lightSquare;
      } else {
        bgColor = this.index % 2 == 0 ? colors.lightSquare : colors.darkSquare;
      }
    }

    return bgColor as material.Color;
  }

  String get sanName {
    // HACK
    return switch (this.name.length) {
      2 => this.name[0].toLowerCase() + '0' + this.name[1],
      3 => this.name.toLowerCase(),
      _ => throw 'Unexpected Square name length',
    };
  }

  bool get isPromotionSquare => _promotionSquares.contains(this);
}

Iterable<Square> fenIter() {
  final range = List.generate(boardSize, (i) => i, growable: false);
  return range.map((i) {
    return fenIndexToSquare(i);
  });
}

Square fenIndexToSquare(int i) {
  final rank = switch (i) {
    0 => boardWidth - 1,
    _ => (boardWidth - (i ~/ boardWidth)) - 1,
  };
  final file = i % boardWidth;
  return fromFileAndRankIndex(file, rank);
}

Square fromFileAndRankIndex(int file, int rank) {
  final i = (rank * boardWidth) + file;
  return Square.values[i];
}

final coloredSquares = {
  Square.H9: colors.whiteSquare,
  Square.I8: colors.whiteSquare,
  Square.H8: colors.blackSquare,
  Square.I9: colors.blackSquare,
  Square.G7: colors.ashSquare,
  Square.J10: colors.ashSquare,
  Square.G10: colors.slateSquare,
  Square.J7: colors.slateSquare,
  Square.H11: colors.pinkSquare,
  Square.I6: colors.pinkSquare,
  Square.E12: colors.redSquare,
  Square.L5: colors.redSquare,
  Square.F9: colors.orangeSquare,
  Square.K8: colors.orangeSquare,
  Square.F11: colors.yellowSquare,
  Square.K6: colors.yellowSquare,
  Square.F6: colors.greenSquare,
  Square.K11: colors.greenSquare,
  Square.F8: colors.cyanSquare,
  Square.K9: colors.cyanSquare,
  Square.E5: colors.navySquare,
  Square.L12: colors.navySquare,
  Square.H6: colors.violetSquare,
  Square.I11: colors.violetSquare,
};

final _promotionSquares = Set.unmodifiable(<Square>{
  Square.G7,
  Square.H7,
  Square.I7,
  Square.J7,
  Square.G8,
  Square.H8,
  Square.I8,
  Square.J8,
  Square.G9,
  Square.H9,
  Square.I9,
  Square.J9,
  Square.G10,
  Square.H10,
  Square.I10,
  Square.J10,
});
