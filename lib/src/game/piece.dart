import 'square_key.dart';
import 'package:flutter_svg/flutter_svg.dart' as flutter_svg;

typedef Pieces = Map<Square, Piece>;

enum Role {
  bishop,
  king,
  knight,
  pawn,
  queen,
  rook;

  String get code {
    return switch (this) {
      Role.bishop => 'b',
      Role.king => 'k',
      Role.knight => 'n',
      Role.pawn => 'p',
      Role.queen => 'q',
      Role.rook => 'r',
    };
  }
}

const roleNotations = {
  Role.bishop: 'B',
  Role.king: 'K',
  Role.knight: 'N',
  Role.pawn: 'P',
  Role.queen: 'Q',
  Role.rook: 'R',
};

enum Color {
  ash,
  black,
  cyan,
  green,
  navy,
  orange,
  pink,
  red,
  slate,
  violet,
  white,
  yellow,
}

const colorNotations = {
  Color.ash: 'A',
  Color.black: 'B',
  Color.cyan: 'C',
  Color.green: 'G',
  Color.navy: 'N',
  Color.orange: 'O',
  Color.pink: 'P',
  Color.red: 'R',
  Color.slate: 'S',
  Color.violet: 'V',
  Color.white: 'W',
  Color.yellow: 'Y',
};

Color? charToColor(String ch) {
  return switch (ch) {
    'a' => Color.ash,
    'b' => Color.black,
    'c' => Color.cyan,
    'g' => Color.green,
    'n' => Color.navy,
    'o' => Color.orange,
    'p' => Color.pink,
    'r' => Color.red,
    's' => Color.slate,
    'v' => Color.violet,
    'w' => Color.white,
    'y' => Color.yellow,
    '-' => null,
    _ => throw Exception('Invalid Color char code')
  };
}

class Piece {
  final Color color;
  final Role role;

  Piece({required this.color, required this.role});

  //String get name => role == Role.knight ? 'N' : role.name[0].toUpperCase();

  String get notation => '${colorNotations[color]}${roleNotations[role]}';

  @override
  operator ==(o) => o is Piece && o.color == color && o.role == role;

  String toString() => '${color.name} ${role.name}'.toUpperCase();
}

//enum PieceEnum {
//  ashBishop(color: Color.ash, role: Role.bishop),
//  ashKing(color: Color.ash, role: Role.king),
//  ashKnight(color: Color.ash, role: Role.knight),
//  ashPawn(color: Color.ash, role: Role.pawn),
//  ashQueen(color: Color.ash, role: Role.queen),
//  ashRook(color: Color.ash, role: Role.rook),
//
//  blackBishop(color: Color.black, role: Role.bishop),
//  blackKing(color: Color.black, role: Role.king),
//  blackKnight(color: Color.black, role: Role.knight),
//  blackPawn(color: Color.black, role: Role.pawn),
//  blackQueen(color: Color.black, role: Role.queen),
//  blackRook(color: Color.black, role: Role.rook),
//
//  cyanBishop(color: Color.cyan, role: Role.bishop),
//  cyanKing(color: Color.cyan, role: Role.king),
//  cyanKnight(color: Color.cyan, role: Role.knight),
//  cyanPawn(color: Color.cyan, role: Role.pawn),
//  cyanQueen(color: Color.cyan, role: Role.queen),
//  cyanRook(color: Color.cyan, role: Role.rook),
//
//  greenBishop(color: Color.green, role: Role.bishop),
//  greenKing(color: Color.green, role: Role.king),
//  greenKnight(color: Color.green, role: Role.knight),
//  greenPawn(color: Color.green, role: Role.pawn),
//  greenQueen(color: Color.green, role: Role.queen),
//  greenRook(color: Color.green, role: Role.rook),
//
//  navyBishop(color: Color.navy, role: Role.bishop),
//  navyKing(color: Color.navy, role: Role.king),
//  navyKnight(color: Color.navy, role: Role.knight),
//  navyPawn(color: Color.navy, role: Role.pawn),
//  navyQueen(color: Color.navy, role: Role.queen),
//  navyRook(color: Color.navy, role: Role.rook),
//
//  orangeBishop(color: Color.orange, role: Role.bishop),
//  orangeKing(color: Color.orange, role: Role.king),
//  orangeKnight(color: Color.orange, role: Role.knight),
//  orangePawn(color: Color.orange, role: Role.pawn),
//  orangeQueen(color: Color.orange, role: Role.queen),
//  orangeRook(color: Color.orange, role: Role.rook),
//
//  pinkBishop(color: Color.pink, role: Role.bishop),
//  pinkKing(color: Color.pink, role: Role.king),
//  pinkKnight(color: Color.pink, role: Role.knight),
//  pinkPawn(color: Color.pink, role: Role.pawn),
//  pinkQueen(color: Color.pink, role: Role.queen),
//  pinkRook(color: Color.pink, role: Role.rook),
//
//  redBishop(color: Color.red, role: Role.bishop),
//  redKing(color: Color.red, role: Role.king),
//  redKnight(color: Color.red, role: Role.knight),
//  redPawn(color: Color.red, role: Role.pawn),
//  redQueen(color: Color.red, role: Role.queen),
//  redRook(color: Color.red, role: Role.rook),
//
//  slateBishop(color: Color.slate, role: Role.bishop),
//  slateKing(color: Color.slate, role: Role.king),
//  slateKnight(color: Color.slate, role: Role.knight),
//  slatePawn(color: Color.slate, role: Role.pawn),
//  slateQueen(color: Color.slate, role: Role.queen),
//  slateRook(color: Color.slate, role: Role.rook),
//
//  violetBishop(color: Color.violet, role: Role.bishop),
//  violetKing(color: Color.violet, role: Role.king),
//  violetKnight(color: Color.violet, role: Role.knight),
//  violetPawn(color: Color.violet, role: Role.pawn),
//  violetQueen(color: Color.violet, role: Role.queen),
//  violetRook(color: Color.violet, role: Role.rook),
//
//  whiteBishop(color: Color.white, role: Role.bishop),
//  whiteKing(color: Color.white, role: Role.king),
//  whiteKnight(color: Color.white, role: Role.knight),
//  whitePawn(color: Color.white, role: Role.pawn),
//  whiteQueen(color: Color.white, role: Role.queen),
//  whiteRook(color: Color.white, role: Role.rook),
//
//  yellowBishop(color: Color.yellow, role: Role.bishop),
//  yellowKing(color: Color.yellow, role: Role.king),
//  yellowKnight(color: Color.yellow, role: Role.knight),
//  yellowPawn(color: Color.yellow, role: Role.pawn),
//  yellowQueen(color: Color.yellow, role: Role.queen),
//  yellowRook(color: Color.yellow, role: Role.rook);
//
//  const PieceEnum({
//    required this.color,
//    required this.role,
//  });
//
//  final Color color;
//  final Role role;
//
//  String get name => role == Role.knight ? 'N' : role.name[0].toUpperCase();
//
//  String toString() => '${color.name} ${role.name}'.toUpperCase();
//}

final svgPieceColors = {
  Color.white: '#fff',
  Color.black: '#000',
  Color.ash: '#90a4ae',
  Color.slate: '#616161',
  Color.pink: '#EC407A',
  Color.red: '#EF5350',
  Color.orange: '#FFA726',
  Color.yellow: '#FFEE58',
  Color.green: '#66BB6A',
  Color.cyan: '#26C6DA',
  Color.navy: '#5C6BC0',
  Color.violet: '#7E57C2',
};

class PieceRenderer {
  final Piece piece;

  PieceRenderer(this.piece);

  flutter_svg.SvgPicture asWidget() {
    final svgString = switch ((piece.color, piece.role)) {
      (Color.black, Role.bishop) => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="opacity:1; fill:none; fill-rule:evenodd; fill-opacity:1; stroke:#000000; stroke-width:1.5; stroke-linecap:round; stroke-linejoin:round; stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;" transform="translate(0,0.6)">
            <g style="fill:#000000; stroke:#000000; stroke-linecap:butt;">
              <path d="M 9,36 C 12.39,35.03 19.11,36.43 22.5,34 C 25.89,36.43 32.61,35.03 36,36 C 36,36 37.65,36.54 39,38 C 38.32,38.97 37.35,38.99 36,38.5 C 32.61,37.53 25.89,38.96 22.5,37.5 C 19.11,38.96 12.39,37.53 9,38.5 C 7.65,38.99 6.68,38.97 6,38 C 7.35,36.54 9,36 9,36 z"/>
              <path d="M 15,32 C 17.5,34.5 27.5,34.5 30,32 C 30.5,30.5 30,30 30,30 C 30,27.5 27.5,26 27.5,26 C 33,24.5 33.5,14.5 22.5,10.5 C 11.5,14.5 12,24.5 17.5,26 C 17.5,26 15,27.5 15,30 C 15,30 14.5,30.5 15,32 z"/>
              <path d="M 25 8 A 2.5 2.5 0 1 1  20,8 A 2.5 2.5 0 1 1  25 8 z"/>
            </g>
            <path d="M 17.5,26 L 27.5,26 M 15,30 L 30,30 M 22.5,15.5 L 22.5,20.5 M 20,18 L 25,18" style="fill:none; stroke:#ffffff; stroke-linejoin:miter;"/>
          </g>
        </svg>
      ''',
      (Color.black, Role.king) => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="fill:none; fill-opacity:1; fill-rule:evenodd; stroke:#000000; stroke-width:1.5; stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;">
            <path d="M 22.5,11.63 L 22.5,6" style="fill:none; stroke:#000000; stroke-linejoin:miter;" id="path6570"/>
            <path d="M 22.5,25 C 22.5,25 27,17.5 25.5,14.5 C 25.5,14.5 24.5,12 22.5,12 C 20.5,12 19.5,14.5 19.5,14.5 C 18,17.5 22.5,25 22.5,25" style="fill:#000000;fill-opacity:1; stroke-linecap:butt; stroke-linejoin:miter;"/>
            <path d="M 12.5,37 C 18,40.5 27,40.5 32.5,37 L 32.5,30 C 32.5,30 41.5,25.5 38.5,19.5 C 34.5,13 25,16 22.5,23.5 L 22.5,27 L 22.5,23.5 C 20,16 10.5,13 6.5,19.5 C 3.5,25.5 12.5,30 12.5,30 L 12.5,37" style="fill:#000000; stroke:#000000;"/>
            <path d="M 20,8 L 25,8" style="fill:none; stroke:#000000; stroke-linejoin:miter;"/>
            <path d="M 32,29.5 C 32,29.5 40.5,25.5 38.03,19.85 C 34.15,14 25,18 22.5,24.5 L 22.5,26.6 L 22.5,24.5 C 20,18 10.85,14 6.97,19.85 C 4.5,25.5 13,29.5 13,29.5" style="fill:none; stroke:#ffffff;"/>
            <path d="M 12.5,30 C 18,27 27,27 32.5,30 M 12.5,33.5 C 18,30.5 27,30.5 32.5,33.5 M 12.5,37 C 18,34 27,34 32.5,37" style="fill:none; stroke:#ffffff;"/>
          </g>
        </svg>
      ''',
      (Color.black, Role.knight) => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="opacity:1; fill:none; fill-opacity:1; fill-rule:evenodd; stroke:#000000; stroke-width:1.5; stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;" transform="translate(0,0.3)">
            <path
              d="M 22,10 C 32.5,11 38.5,18 38,39 L 15,39 C 15,30 25,32.5 23,18"
              style="fill:#000000; stroke:#000000;" />
            <path
              d="M 24,18 C 24.38,20.91 18.45,25.37 16,27 C 13,29 13.18,31.34 11,31 C 9.958,30.06 12.41,27.96 11,28 C 10,28 11.19,29.23 10,30 C 9,30 5.997,31 6,26 C 6,24 12,14 12,14 C 12,14 13.89,12.1 14,10.5 C 13.27,9.506 13.5,8.5 13.5,7.5 C 14.5,6.5 16.5,10 16.5,10 L 18.5,10 C 18.5,10 19.28,8.008 21,7 C 22,7 22,10 22,10"
              style="fill:#000000; stroke:#000000;" />
            <path
              d="M 9.5 25.5 A 0.5 0.5 0 1 1 8.5,25.5 A 0.5 0.5 0 1 1 9.5 25.5 z"
              style="fill:#ffffff; stroke:#ffffff;" />
            <path
              d="M 15 15.5 A 0.5 1.5 0 1 1  14,15.5 A 0.5 1.5 0 1 1  15 15.5 z"
              transform="matrix(0.866,0.5,-0.5,0.866,9.693,-5.173)"
              style="fill:#ffffff; stroke:#ffffff;" />
            <path
              d="M 24.55,10.4 L 24.1,11.85 L 24.6,12 C 27.75,13 30.25,14.49 32.5,18.75 C 34.75,23.01 35.75,29.06 35.25,39 L 35.2,39.5 L 37.45,39.5 L 37.5,39 C 38,28.94 36.62,22.15 34.25,17.66 C 31.88,13.17 28.46,11.02 25.06,10.5 L 24.55,10.4 z "
              style="fill:#ffffff; stroke:none;" />
          </g>
        </svg>
      ''',
      (Color.black, Role.pawn) => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <path d="m 22.5,9 c -2.21,0 -4,1.79 -4,4 0,0.89 0.29,1.71 0.78,2.38 C 17.33,16.5 16,18.59 16,21 c 0,2.03 0.94,3.84 2.41,5.03 C 15.41,27.09 11,31.58 11,39.5 H 34 C 34,31.58 29.59,27.09 26.59,26.03 28.06,24.84 29,23.03 29,21 29,18.59 27.67,16.5 25.72,15.38 26.21,14.71 26.5,13.89 26.5,13 c 0,-2.21 -1.79,-4 -4,-4 z" style="opacity:1; fill:#000000; fill-opacity:1; fill-rule:nonzero; stroke:#000000; stroke-width:1.5; stroke-linecap:round; stroke-linejoin:miter; stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;"/>
        </svg>
      ''',
      (Color.black, Role.queen) => '''
        <?xml version="1.0" encoding="utf-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
        "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45"
        height="45">
          <g style="fill:#000000;stroke:#000000;stroke-width:1.5; stroke-linecap:round;stroke-linejoin:round">

            <path d="M 9,26 C 17.5,24.5 30,24.5 36,26 L 38.5,13.5 L 31,25 L 30.7,10.9 L 25.5,24.5 L 22.5,10 L 19.5,24.5 L 14.3,10.9 L 14,25 L 6.5,13.5 L 9,26 z"
            style="stroke-linecap:butt;fill:#000000" />
            <path d="m 9,26 c 0,2 1.5,2 2.5,4 1,1.5 1,1 0.5,3.5 -1.5,1 -1,2.5 -1,2.5 -1.5,1.5 0,2.5 0,2.5 6.5,1 16.5,1 23,0 0,0 1.5,-1 0,-2.5 0,0 0.5,-1.5 -1,-2.5 -0.5,-2.5 -0.5,-2 0.5,-3.5 1,-2 2.5,-2 2.5,-4 -8.5,-1.5 -18.5,-1.5 -27,0 z" />
            <path d="M 11.5,30 C 15,29 30,29 33.5,30" />
            <path d="m 12,33.5 c 6,-1 15,-1 21,0" />
            <circle cx="6" cy="12" r="2" />
            <circle cx="14" cy="9" r="2" />
            <circle cx="22.5" cy="8" r="2" />
            <circle cx="31" cy="9" r="2" />
            <circle cx="39" cy="12" r="2" />
            <path d="M 11,38.5 A 35,35 1 0 0 34,38.5"
            style="fill:none; stroke:#000000;stroke-linecap:butt;" />
            <g style="fill:none; stroke:#ffffff;">
              <path d="M 11,29 A 35,35 1 0 1 34,29" />
              <path d="M 12.5,31.5 L 32.5,31.5" />
              <path d="M 11.5,34.5 A 35,35 1 0 0 33.5,34.5" />
              <path d="M 10.5,37.5 A 35,35 1 0 0 34.5,37.5" />
            </g>
          </g>
        </svg>
      ''',
      (Color.black, Role.rook) => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="opacity:1; fill:#000000; fill-opacity:1; fill-rule:evenodd; stroke:#000000; stroke-width:1.5; stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;" transform="translate(0,0.3)">
            <path
              d="M 9,39 L 36,39 L 36,36 L 9,36 L 9,39 z "
              style="stroke-linecap:butt;" />
            <path
              d="M 12.5,32 L 14,29.5 L 31,29.5 L 32.5,32 L 12.5,32 z "
              style="stroke-linecap:butt;" />
            <path
              d="M 12,36 L 12,32 L 33,32 L 33,36 L 12,36 z "
              style="stroke-linecap:butt;" />
            <path
              d="M 14,29.5 L 14,16.5 L 31,16.5 L 31,29.5 L 14,29.5 z "
              style="stroke-linecap:butt;stroke-linejoin:miter;" />
            <path
              d="M 14,16.5 L 11,14 L 34,14 L 31,16.5 L 14,16.5 z "
              style="stroke-linecap:butt;" />
            <path
              d="M 11,14 L 11,9 L 15,9 L 15,11 L 20,11 L 20,9 L 25,9 L 25,11 L 30,11 L 30,9 L 34,9 L 34,14 L 11,14 z "
              style="stroke-linecap:butt;" />
            <path
              d="M 12,35.5 L 33,35.5 L 33,35.5"
              style="fill:none; stroke:#ffffff; stroke-width:1; stroke-linejoin:miter;" />
            <path
              d="M 13,31.5 L 32,31.5"
              style="fill:none; stroke:#ffffff; stroke-width:1; stroke-linejoin:miter;" />
            <path
              d="M 14,29.5 L 31,29.5"
              style="fill:none; stroke:#ffffff; stroke-width:1; stroke-linejoin:miter;" />
            <path
              d="M 14,16.5 L 31,16.5"
              style="fill:none; stroke:#ffffff; stroke-width:1; stroke-linejoin:miter;" />
            <path
              d="M 11,14 L 34,14"
              style="fill:none; stroke:#ffffff; stroke-width:1; stroke-linejoin:miter;" />
          </g>
        </svg>
      ''',
      _ => _getNonBlackPieceSVGString(piece),
    };

    return flutter_svg.SvgPicture.string(
      svgString,
    );
  }

  String _getNonBlackPieceSVGString(Piece piece) {
    final hexColor = svgPieceColors[piece.color] as String;

    return switch (piece.role) {
      Role.bishop => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="opacity:1; fill:none; fill-rule:evenodd; fill-opacity:1; stroke:#000000; stroke-width:1.5; stroke-linecap:round; stroke-linejoin:round; stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;" transform="translate(0,0.6)">
            <g style="fill:$hexColor; stroke:#000000; stroke-linecap:butt;">
              <path d="M 9,36 C 12.39,35.03 19.11,36.43 22.5,34 C 25.89,36.43 32.61,35.03 36,36 C 36,36 37.65,36.54 39,38 C 38.32,38.97 37.35,38.99 36,38.5 C 32.61,37.53 25.89,38.96 22.5,37.5 C 19.11,38.96 12.39,37.53 9,38.5 C 7.65,38.99 6.68,38.97 6,38 C 7.35,36.54 9,36 9,36 z"/>
              <path d="M 15,32 C 17.5,34.5 27.5,34.5 30,32 C 30.5,30.5 30,30 30,30 C 30,27.5 27.5,26 27.5,26 C 33,24.5 33.5,14.5 22.5,10.5 C 11.5,14.5 12,24.5 17.5,26 C 17.5,26 15,27.5 15,30 C 15,30 14.5,30.5 15,32 z"/>
              <path d="M 25 8 A 2.5 2.5 0 1 1  20,8 A 2.5 2.5 0 1 1  25 8 z"/>
            </g>
            <path d="M 17.5,26 L 27.5,26 M 15,30 L 30,30 M 22.5,15.5 L 22.5,20.5 M 20,18 L 25,18" style="fill:none; stroke:#000000; stroke-linejoin:miter;"/>
          </g>
        </svg>
      ''',
      Role.king => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <svg xmlns="http://www.w3.org/2000/svg" width="45" height="45">
          <g fill="none" fill-rule="evenodd" stroke="#000" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5">
            <path stroke-linejoin="miter" d="M22.5 11.63V6M20 8h5"/>
            <path fill="$hexColor" stroke-linecap="butt" stroke-linejoin="miter" d="M22.5 25s4.5-7.5 3-10.5c0 0-1-2.5-3-2.5s-3 2.5-3 2.5c-1.5 3 3 10.5 3 10.5"/>
            <path fill="$hexColor" d="M12.5 37c5.5 3.5 14.5 3.5 20 0v-7s9-4.5 6-10.5c-4-6.5-13.5-3.5-16 4V27v-3.5c-2.5-7.5-12-10.5-16-4-3 6 6 10.5 6 10.5v7"/>
            <path d="M12.5 30c5.5-3 14.5-3 20 0m-20 3.5c5.5-3 14.5-3 20 0m-20 3.5c5.5-3 14.5-3 20 0"/>
          </g>
        </svg>
      ''',
      Role.knight => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="opacity:1; fill:none; fill-opacity:1; fill-rule:evenodd; stroke:#000000; stroke-width:1.5; stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;" transform="translate(0,0.3)">
            <path
              d="M 22,10 C 32.5,11 38.5,18 38,39 L 15,39 C 15,30 25,32.5 23,18"
              style="fill:$hexColor; stroke:#000000;" />
            <path
              d="M 24,18 C 24.38,20.91 18.45,25.37 16,27 C 13,29 13.18,31.34 11,31 C 9.958,30.06 12.41,27.96 11,28 C 10,28 11.19,29.23 10,30 C 9,30 5.997,31 6,26 C 6,24 12,14 12,14 C 12,14 13.89,12.1 14,10.5 C 13.27,9.506 13.5,8.5 13.5,7.5 C 14.5,6.5 16.5,10 16.5,10 L 18.5,10 C 18.5,10 19.28,8.008 21,7 C 22,7 22,10 22,10"
              style="fill:$hexColor; stroke:#000000;" />
            <path
              d="M 9.5 25.5 A 0.5 0.5 0 1 1 8.5,25.5 A 0.5 0.5 0 1 1 9.5 25.5 z"
              style="fill:#000000; stroke:#000000;" />
            <path
              d="M 15 15.5 A 0.5 1.5 0 1 1  14,15.5 A 0.5 1.5 0 1 1  15 15.5 z"
              transform="matrix(0.866,0.5,-0.5,0.866,9.693,-5.173)"
              style="fill:#000000; stroke:#000000;" />
          </g>
        </svg>
      ''',
      Role.pawn => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <path d="m 22.5,9 c -2.21,0 -4,1.79 -4,4 0,0.89 0.29,1.71 0.78,2.38 C 17.33,16.5 16,18.59 16,21 c 0,2.03 0.94,3.84 2.41,5.03 C 15.41,27.09 11,31.58 11,39.5 H 34 C 34,31.58 29.59,27.09 26.59,26.03 28.06,24.84 29,23.03 29,21 29,18.59 27.67,16.5 25.72,15.38 26.21,14.71 26.5,13.89 26.5,13 c 0,-2.21 -1.79,-4 -4,-4 z" style="opacity:1; fill:$hexColor; fill-opacity:1; fill-rule:nonzero; stroke:#000000; stroke-width:1.5; stroke-linecap:round; stroke-linejoin:miter; stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;"/>
        </svg>
      ''',
      Role.queen => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="fill:$hexColor;stroke:#000000;stroke-width:1.5;stroke-linejoin:round">
            <path d="M 9,26 C 17.5,24.5 30,24.5 36,26 L 38.5,13.5 L 31,25 L 30.7,10.9 L 25.5,24.5 L 22.5,10 L 19.5,24.5 L 14.3,10.9 L 14,25 L 6.5,13.5 L 9,26 z"/>
            <path d="M 9,26 C 9,28 10.5,28 11.5,30 C 12.5,31.5 12.5,31 12,33.5 C 10.5,34.5 11,36 11,36 C 9.5,37.5 11,38.5 11,38.5 C 17.5,39.5 27.5,39.5 34,38.5 C 34,38.5 35.5,37.5 34,36 C 34,36 34.5,34.5 33,33.5 C 32.5,31 32.5,31.5 33.5,30 C 34.5,28 36,28 36,26 C 27.5,24.5 17.5,24.5 9,26 z"/>
            <path d="M 11.5,30 C 15,29 30,29 33.5,30" style="fill:none"/>
            <path d="M 12,33.5 C 18,32.5 27,32.5 33,33.5" style="fill:none"/>
            <circle cx="6" cy="12" r="2" />
            <circle cx="14" cy="9" r="2" />
            <circle cx="22.5" cy="8" r="2" />
            <circle cx="31" cy="9" r="2" />
            <circle cx="39" cy="12" r="2" />
          </g>
        </svg>
      ''',
      Role.rook => '''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="45" height="45">
          <g style="opacity:1; fill:$hexColor; fill-opacity:1; fill-rule:evenodd; stroke:#000000; stroke-width:1.5; stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4; stroke-dasharray:none; stroke-opacity:1;" transform="translate(0,0.3)">
            <path
              d="M 9,39 L 36,39 L 36,36 L 9,36 L 9,39 z "
              style="stroke-linecap:butt;" />
            <path
              d="M 12,36 L 12,32 L 33,32 L 33,36 L 12,36 z "
              style="stroke-linecap:butt;" />
            <path
              d="M 11,14 L 11,9 L 15,9 L 15,11 L 20,11 L 20,9 L 25,9 L 25,11 L 30,11 L 30,9 L 34,9 L 34,14"
              style="stroke-linecap:butt;" />
            <path
              d="M 34,14 L 31,17 L 14,17 L 11,14" />
            <path
              d="M 31,17 L 31,29.5 L 14,29.5 L 14,17"
              style="stroke-linecap:butt; stroke-linejoin:miter;" />
            <path
              d="M 31,29.5 L 32.5,32 L 12.5,32 L 14,29.5" />
            <path
              d="M 11,14 L 34,14"
              style="fill:none; stroke:#000000; stroke-linejoin:miter;" />
          </g>
        </svg>
      ''',
    };
  }
}
