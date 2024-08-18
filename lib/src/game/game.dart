import 'board.dart';
import 'fen.dart' show fenToPosition;
import 'piece.dart' show Color;
import 'player.dart' show Player;
import 'position.dart' show Position;
import '../user.dart' show UserModel;

export 'board.dart';
export 'fen.dart' show FEN;

typedef Games = List<Game>;

enum GameState {
  Created,
  Accepted,
  FirstMove,
  InProgress,
  DefectMoveKing,
  Ended,
}

GameState _getGameState(String state) {
  for (final gameState in GameState.values) {
    if (state == gameState.name) {
      return gameState;
    }
  }
  throw Exception('GameState not recognized');
}

class Game {
  final String id;
  final GameState state;
  final String player1;
  final String? player2;
  late Player?
      currentPlayer; // enum denoting which player the logged in user is
  List<Move> moves;

  Game({
    required this.id,
    required this.state,
    required this.player1,
    this.player2,
    required this.moves,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'pid': String id,
        'state': String state,
        'player1': String player1,
        'player2': String? player2,
        'moves': List<dynamic> moves,
      } =>
        Game(
          id: id,
          state: _getGameState(state),
          player1: player1,
          player2: player2,
          moves: [for (var move in moves) Move.fromJson(move)],
        ),
      _ => throw const FormatException('Failed to load game.'),
    };
  }

  String get fen => moves.last.fen;

  Position currentPosition() {
    return fenToPosition(moves.last.rawFEN);
  }

  bool userCreatedGame(String userId) {
    return userId == player1;
  }

  void setPlayer(UserModel user) {
    if (user?.id == this.player1) {
      this.currentPlayer = Player.p1;
    } else if (user?.id == this.player2) {
      this.currentPlayer = Player.p2;
    }
  }

  DateTime timeSinceLastMove() {
    return moves.last.timestamp;
  }
}

String _parseFen(String fen) {
  // Only interested in the first field which contains the piece placements (board FEN)
  return fen.split(' ')[0];
}

DateTime _parseTimestamp(Map<String, dynamic> json) {
  final ms = json[r"$date"]?[r"$numberLong"];
  return DateTime.fromMillisecondsSinceEpoch(int.parse(ms), isUtc: true);
}

class Move {
  final String fen;
  final String rawFEN;
  final DateTime timestamp;

  Move({required this.fen, required this.rawFEN, required this.timestamp});

  factory Move.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'fen': String fen,
        'ts': Map<String, dynamic> ts,
      } =>
        Move(
          fen: _parseFen(fen),
          rawFEN: fen,
          timestamp: _parseTimestamp(ts),
        ),
      _ => throw const FormatException('Failed to parse Move'),
    };
  }
}

class GameForList {
  final String id;
  final String fen;
  final GameState state;

  GameForList({
    required this.id,
    required this.fen,
    required this.state,
  });

  factory GameForList.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'pid': String id,
        'fen': String fen,
        'state': String state,
      } =>
        GameForList(
          id: id,
          fen: fen,
          state: _getGameState(state),
        ),
      _ => throw const FormatException('Failed to load game for list'),
    };
  }
}
