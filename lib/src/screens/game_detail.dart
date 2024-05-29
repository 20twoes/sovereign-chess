import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../game/game.dart' show Board, Game, GameState;
import '../user.dart' show UserModel;
import 'scaffold.dart' show AppScaffold;

const WS_URI = String.fromEnvironment('WS_URI', defaultValue: 'ws://127.0.0.1:3000/ws');

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
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse(WS_URI + '/v0/play/' + widget.gameId),
    );
  }

  void _sendMessage(String message) {
    _channel.sink.add(message);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: StreamBuilder<dynamic>(
        stream: _channel.stream,
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
          sendMessage: _sendMessage,
          game: game,
      ),
      _ => throw Exception('Implement screen for game state: ${game.state}'),
    };
  }

  @override
  void dispose() {
    _channel.sink.close(ws_status.normalClosure);
    super.dispose();
  }
}

class GameCreatedScreen extends StatelessWidget {
  final ValueChanged<String> sendMessage;
  final Game game;

  GameCreatedScreen({required this.sendMessage, required this.game});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserModel>(context).id;
    if (userId != null && game.hasJoinedGame(userId as String)) {
      return _buildScreenForPlayer1(context);
    } else {
      return _buildScreenForPlayer2(context);
    }
  }

  Widget _buildScreenForPlayer1(BuildContext context) {
    return Center(
      child: SelectableText('To invite someone to play, give this URL: ${Uri.base}'),
    );
  }

  Widget _buildScreenForPlayer2(BuildContext context) {
    final userId = Provider.of<UserModel>(context).id;
    return Center(
      child: ElevatedButton(
        // TODO: Implement this handler
        onPressed: () => print('joining game'),
        child: Text('Join this game with $userId'),
      ),
    );
  }
}

class TempScreen extends StatelessWidget {
  final ValueChanged<String> onPieceMove;
  final Game game;

  TempScreen({
    required this.onPieceMove,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Board(
      onPieceMove: onPieceMove,
      currentFEN: game.fen,
    );
  }
}
