import 'piece.dart';
import 'square_key.dart';

typedef FEN = String;

class InvalidFENException implements Exception {}
class FENTokenIteratorException implements Exception {}

const FEN initialFEN = 'aqabvrvnbrbnbbbqbkbbbnbrynyrsbsq/aranvpvpbpbpbpbpbpbpbpbpypypsnsr/nbnp12opob/nqnp12opoq/crcp12rprr/cncp12rprn/gbgp12pppb/gqgp12pppq/yqyp12vpvq/ybyp12vpvb/onop12npnn/orop12npnr/rqrp12cpcq/rbrp12cpcb/srsnppppwpwpwpwpwpwpwpwpgpgpanar/sqsbprpnwrwnwbwqwkwbwnwrgngrabaq';

const colorMap = {
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

const roleMap = {
  'b': Role.bishop,
  'k': Role.king,
  'n': Role.knight,
  'p': Role.pawn,
  'q': Role.queen,
  'r': Role.rook,
};

final startIndex = -2;
const chunkLength = 2;

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
  final color = colorMap[token[0]];
  final role = roleMap[token[1]];

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
  final pieces = Map<Key, Piece>();
  final rows = fen.split('/');

  for (final (rowIndex, fenRow) in rows.indexed) {
    final iter = FENTokenIterator(fenRow);
    var col = 0;
    var row = rowLength - 1 - rowIndex;

    while (iter.moveNext()) {
      final token = iter.current;
      if (isNumeric(token)) {
        final skippedSquares = int.parse(token);
        col += skippedSquares - 1;
      } else {
        final key = posToKey(col, row);
        pieces[key] = parse(token);
      }
      col++;
    }
  }

  return pieces;
}
