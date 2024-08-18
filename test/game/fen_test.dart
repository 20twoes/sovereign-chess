import 'package:test/test.dart';

import 'package:sovereign_chess/src/game/fen.dart' as fen;
import 'package:sovereign_chess/src/game/piece.dart';
import 'package:sovereign_chess/src/game/player.dart';
import 'package:sovereign_chess/src/game/position.dart';
import 'package:sovereign_chess/src/game/square_key.dart';

void main() {
  group('FEN read', () {
    test('should return pieces with their positions', () {
      final testFEN = 'aq02vr';
      final pieces = fen.read(testFEN);
      expect(pieces[Square.A16], Piece(color: Color.ash, role: Role.queen));
      expect(pieces[Square.B16], null);
      expect(pieces[Square.D16], Piece(color: Color.violet, role: Role.rook));
    });

    test('should handle multiple lines', () {
      final testFEN = 'aq15/ar15';
      final pieces = fen.read(testFEN);
      expect(pieces[Square.A16], Piece(color: Color.ash, role: Role.queen));
      expect(pieces[Square.A15], Piece(color: Color.ash, role: Role.rook));
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
        Square.A16: Piece(color: Color.ash, role: Role.queen),
      };
      final result = fen.write(pieces);
      expect(result, 'aq15/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16');
    });

    test('should work for random squares', () {
      final pieces = {
        Square.A15: Piece(color: Color.white, role: Role.rook),
        Square.C13: Piece(color: Color.white, role: Role.rook),
        Square.E13: Piece(color: Color.white, role: Role.rook),
        Square.K8: Piece(color: Color.pink, role: Role.bishop),
        Square.P1: Piece(color: Color.navy, role: Role.pawn),
      };
      final result = fen.write(pieces);
      expect(result,
          '16/wr15/16/02wr01wr11/16/16/16/16/10pb05/16/16/16/16/16/16/15np');
    });
  });

  group('fenToPosition', () {
    test('should work', () {
      final rawFEN =
          'aqabvrvnbrbnbbbqbkbbbnbrynyrsbsq/aranvpvpbpbpbpbp01bpbpbpypypsnsr/nbnp12opob/nqnp12opoq/crcp12rprr/cncp06bp05rprn/gbgp12pppb/gqgp12pppq/yqyp12vpvq/ybyp12vpvb/onop06wp05npnn/orop12npnr/rqrp12cpcq/rbrp05wp06cpcb/srsnppppwpwpwp02wpwpwpgpgpanar/sqsbprpnwrwnwbwqwkwbwnwrgngrabaq 2 w p b cv 7';

      final result = fen.fenToPosition(rawFEN);

      expect(result.boardFEN,
          'aqabvrvnbrbnbbbqbkbbbnbrynyrsbsq/aranvpvpbpbpbpbp01bpbpbpypypsnsr/nbnp12opob/nqnp12opoq/crcp12rprr/cncp06bp05rprn/gbgp12pppb/gqgp12pppq/yqyp12vpvq/ybyp12vpvb/onop06wp05npnn/orop12npnr/rqrp12cpcq/rbrp05wp06cpcb/srsnppppwpwpwp02wpwpwpgpgpanar/sqsbprpnwrwnwbwqwkwbwnwrgngrabaq');
      expect(result.activePlayer, Player.p2);
      expect(result.ownedArmy(Player.p1), Color.white);
      expect(result.ownedArmy(Player.p2), Color.black);
      expect(result.controlledArmies(Player.p1).length, 1);
      expect(result.controlledArmies(Player.p1).contains(Color.pink), true);
      expect(result.controlledArmies(Player.p2).length, 2);
      expect(result.controlledArmies(Player.p2).contains(Color.cyan), true);
      expect(result.controlledArmies(Player.p2).contains(Color.violet), true);
    });
  });
}
