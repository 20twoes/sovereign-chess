import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../api/websocket_service.dart' show WebsocketService;
import '../game/game.dart' show Board, FEN, Game, GameState;
import '../user.dart' show UserModel;
import 'scaffold.dart' show AppScaffold;

class GameDetailScreen extends StatelessWidget {
  final String gameId;

  GameDetailScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return GameData(gameId: gameId);
  }
}

class GameData extends StatefulWidget {
  final String gameId;

  GameData({super.key, required this.gameId});

  @override
  State<GameData> createState() => _GameDataState();
}

class _GameDataState extends State<GameData> {
  WebsocketService? _wss;

  @override
  void didChangeDependencies() {
    if (_wss == null) {
      final user = Provider.of<UserModel>(context);
      if (user.isReady()) {
        _wss = WebsocketService(gameId: widget.gameId, user: user);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: StreamBuilder<dynamic>(
        stream: _wss?.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Strack trace: ${snapshot.stackTrace}');
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Connection closed');
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                final game = _parseGame(snapshot.data);
                return _getScreen(game);
              case ConnectionState.done:
                return Text('Connection done');
            }
          }
        },
      ),
    );
  }

  Game _parseGame(String data) {
    final map = jsonDecode(data) as Map<String, dynamic>;
    return Game.fromJson(map);
  }

  Widget _getScreen(Game game) {
    return switch (game.state) {
      GameState.Created => GameCreatedScreen(
          game: game,
          joinGame: _wss?.joinGame,
        ),
      GameState.Accepted => GameAcceptedScreen(
          game: game,
          onPieceMove: _wss!.movePiece,
        ),
      _ => throw Exception('Implement screen for game state: ${game.state}'),
    };
  }

  @override
  void dispose() {
    _wss?.close();
    super.dispose();
  }
}

class GameCreatedScreen extends StatelessWidget {
  final Game game;
  final Function? joinGame;

  GameCreatedScreen({required this.game, required this.joinGame});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    if (user.isReady() && game.userCreatedGame(user.id as String)) {
      return _buildScreenForPlayer1(context);
    } else {
      return _buildScreenForPlayer2(context);
    }
  }

  Widget _buildScreenForPlayer1(BuildContext context) {
    return Center(
      child: SelectableText(
          'To invite someone to play, give this URL: ${Uri.base}'),
    );
  }

  Widget _buildScreenForPlayer2(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _handleJoinGame,
        child: Text('Join this game with ${game.player1}'),
      ),
    );
  }

  void _handleJoinGame() {
    if (joinGame != null) {
      joinGame!();
    }
  }
}

class GameAcceptedScreen extends StatelessWidget {
  final ValueChanged<String> onPieceMove;
  final Game game;

  GameAcceptedScreen({
    required this.onPieceMove,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Board(
      onPieceMove: (newFEN) => _handlePieceMove(context, newFEN),
      currentFEN: game.fen,
    );
  }

  void _handlePieceMove(BuildContext context, FEN newFEN) {
    // Do any additional data formatting and validation here
    onPieceMove(newFEN);
  }
}
