import 'piece.dart';
import 'square_key.dart';

typedef FEN = String;

class InvalidFENException implements Exception {}

class FENTokenIteratorException implements Exception {}

const FEN initialFEN =
    'aqabvrvnbrbnbbbqbkbbbnbrynyrsbsq/aranvpvpbpbpbpbpbpbpbpbpypypsnsr/nbnp12opob/nqnp12opoq/crcp12rprr/cncp12rprn/gbgp12pppb/gqgp12pppq/yqyp12vpvq/ybyp12vpvb/onop12npnn/orop12npnr/rqrp12cpcq/rbrp12cpcb/srsnppppwpwpwpwpwpwpwpwpgpgpanar/sqsbprpnwrwnwbwqwkwbwnwrgngrabaq';

const letterToColors = {
  'a': Color.ash,
  'b': Color.black,
  'c': Color.cyan,
  'g': Color.green,
  'n': Color.navy,
  'o': Color.orange,
  'p': Color.pink,
  'r': Color.red,
  's': Color.slate,
  'v': Color.violet,
  'w': Color.white,
  'y': Color.yellow,
};

const colorToLetters = {
  Color.ash: 'a',
  Color.black: 'b',
  Color.cyan: 'c',
  Color.green: 'g',
  Color.navy: 'n',
  Color.orange: 'o',
  Color.pink: 'p',
  Color.red: 'r',
  Color.slate: 's',
  Color.violet: 'v',
  Color.white: 'w',
  Color.yellow: 'y',
};

const letterToRoles = {
  'b': Role.bishop,
  'k': Role.king,
  'n': Role.knight,
  'p': Role.pawn,
  'q': Role.queen,
  'r': Role.rook,
};

String getPieceKey(Piece piece) {
  return colorToLetters[piece.color]! + piece.role.code;
}

final startIndex = -2;
const chunkLength = 2;

// Consume a string two chars at a time
class FENTokenIterator implements Iterator<String> {
  final FEN fen;
  int index = startIndex;

  FENTokenIterator(this.fen);

  @override
  String get current {
    if (index == startIndex) {
      throw FENTokenIteratorException();
    }
    return fen.substring(index, index + chunkLength);
  }

  @override
  bool moveNext() {
    index += chunkLength;
    return index < fen.length - 1;
  }
}

Piece parse(String token) {
  final color = letterToColors[token[0]];
  final role = letterToRoles[token[1]];

  if (color == null || role == null) {
    throw InvalidFENException();
  }

  return Piece(color: color, role: role);
}

// Only valid numbers are 01-16
final numericRE = new RegExp(r'^[0-1][0-9]$');

bool isNumeric(String str) {
  return numericRE.hasMatch(str);
}

Pieces read(FEN fen) {
  final pieces = Pieces();
  final rows = fen.split('/');

  for (final (rowIndex, fenRow) in rows.indexed) {
    final iter = FENTokenIterator(fenRow);
    var col = 0;
    var row = boardWidth - 1 - rowIndex;

    while (iter.moveNext()) {
      final token = iter.current;
      if (isNumeric(token)) {
        final skippedSquares = int.parse(token);
        col += skippedSquares - 1;
      } else {
        final square = fromFileAndRankIndex(col, row);
        pieces[square] = parse(token);
      }
      col++;
    }
  }

  return pieces;
}

FEN write(Pieces pieces) {
  final rows = Rank.values.reversed.map((rank) {
    final tokens = File.values.map((file) {
      final square = fromFileAndRankIndex(file.index, rank.index);
      final piece = pieces[square];
      // Add a `1` for each skipped square
      return piece != null ? getPieceKey(piece) : '1';
    });
    // Now replace the 1's with the total number of skipped squares
    return tokens.join('').splitMapJoin(
          RegExp(r'1+'),
          onMatch: (m) => '${m[0]!.length}'.padLeft(2, '0'),
        );
  });
  return rows.join('/');
}
