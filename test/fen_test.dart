import 'package:test/test.dart';

import 'package:sovereign_chess/src/fen.dart' as fen;
import 'package:sovereign_chess/src/piece.dart';

void main() {
  group('FEN read', () {
    test('should return pieces with their positions', () {
      final testFEN = 'aq02vr';
      final pieces = fen.read(testFEN);
      expect(pieces['a16'], Piece(color: Color.ash, role: Role.queen));
      expect(pieces['b16'], null);
      expect(pieces['d16'], Piece(color: Color.violet, role: Role.rook));
    });

    test('should handle multiple lines', () {
      final testFEN = 'aq15/ar15';
      final pieces = fen.read(testFEN);
      expect(pieces['a16'], Piece(color: Color.ash, role: Role.queen));
      expect(pieces['a15'], Piece(color: Color.ash, role: Role.rook));
      expect(pieces.length, 2);
    });
  });

  group('FENTokenIterator', () {
    test('should iterate two chars at a time', () {
      final testFEN = 'aq15';
      final iter = fen.FENTokenIterator(testFEN);
      iter.moveNext();
      expect(iter.current, 'aq');
      iter.moveNext();
      expect(iter.current, '15');
    });

    test('should handle invalid FEN length', () {
      final testFEN = 'aq1';
      final iter = fen.FENTokenIterator(testFEN);
      expect(iter.moveNext(), true);
      expect(iter.moveNext(), false);
    });
  });

  group('FEN write', () {
    test('should return FEN string', () {
      final pieces = {
        'a16': Piece(color: Color.ash, role: Role.queen),
      };
      final result = fen.write(pieces);
      expect(result, 'aq15/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16');
    });
    test('should work for random squares', () {
      final pieces = {
        'a15': Piece(color: Color.white, role: Role.rook),
        'c13': Piece(color: Color.white, role: Role.rook),
        'e13': Piece(color: Color.white, role: Role.rook),
        'k8': Piece(color: Color.pink, role: Role.bishop),
        'p1': Piece(color: Color.navy, role: Role.pawn),
      };
      final result = fen.write(pieces);
      expect(result,
          '16/wr15/16/02wr01wr11/16/16/16/16/10pb05/16/16/16/16/16/16/15np');
    });
  });
}
