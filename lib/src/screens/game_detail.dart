import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../game/game.dart' show Board, FEN, initialFEN;
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
  FEN _fen = initialFEN;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse(WS_URI + '/v0/play/' + widget.gameId),
    );
    _channel.stream.listen(_handleMessage);
  }

  void _handleMessage(message) {
    print('message received: $message');
    setState(() {
      _fen = message;
    });
  }

  void _handleFENUpdate(FEN newFEN) {
    _channel.sink.add(newFEN);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Board(
        onPieceMove: _handleFENUpdate,
        currentFEN: _fen,
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(ws_status.normalClosure);
    super.dispose();
  }
}
