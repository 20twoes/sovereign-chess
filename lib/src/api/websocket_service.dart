import 'dart:convert';

import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../game/game.dart' show FEN, Game;
import '../user.dart' show UserModel;

const WS_URI =
    String.fromEnvironment('WS_URI', defaultValue: 'ws://127.0.0.1:3000/ws');

class WebsocketService {
  final WebSocketChannel _channel;
  final UserModel _user;

  WebsocketService({required String gameId, required UserModel user})
      : _user = user,
        _channel = WebSocketChannel.connect(
          Uri.parse(WS_URI + '/v0/play/' + gameId + '?user=' + user.id!),
        );

  Stream get stream => _channel.stream;

  void _send(Map<String, dynamic> data) {
    _channel.sink.add(jsonEncode(data));
  }

  void close() {
    _channel.sink.close(ws_status.normalClosure);
  }

  void joinGame() {
    final data = {'t': 'join'};
    _send(data);
  }

  void makeFirstMove(Map moveData) {
    final data = {
      't': 'first_move',
      'd': moveData,
    };
    _send(data);
  }

  void movePiece(Map moveData) {
    final data = {
      't': 'move',
      'd': moveData,
    };
    _send(data);
  }

  void acceptFirstMove() {
    final data = {
      't': 'first_move_choice',
      'd': 'accept',
    };
    _send(data);
  }

  void rejectFirstMove() {
    final data = {
      't': 'first_move_choice',
      'd': 'reject',
    };
    _send(data);
  }

  void defect(String color) {
    final data = {
      't': 'defect',
      'd': color,
    };
    _send(data);
  }
}
