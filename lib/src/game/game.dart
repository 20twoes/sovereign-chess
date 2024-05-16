import 'board.dart';

export 'board.dart';
export 'fen.dart' show FEN, initialFEN;

typedef Games = List<Game>;

enum GameState {
  Created,
  Accepted,
  FirstMove,
  P2Decided,
  InProgress,
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
  List<Move> moves;

  Game({
    required this.id,
    required this.moves,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'pid': String id,
        'moves': List<dynamic> moves,
      } =>
        Game(
          id: id,
          moves: [for (var move in moves) Move.fromJson(move)],
        ),
      _ => throw const FormatException('Failed to load game.'),
    };
  }

  //String get fen => moves.last.fen;
}

class Move {
  final String fen;
  final int ply;

  Move({required this.fen, required this.ply});

  factory Move.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'fen': String fen,
        'ply': int ply,
      } =>
        Move(fen: fen, ply: ply),
      _ => throw const FormatException('Failed to load move'),
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
