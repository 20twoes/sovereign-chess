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

  void send(String message) {
    _channel.sink.add(message);
  }

  void close() {
    _channel.sink.close(ws_status.normalClosure);
  }

  void joinGame() {
    final data = {'t': 'join'};
    send(jsonEncode(data));
  }

  void makeFirstMove(Map moveData) {
    final data = {
      't': 'first_move',
      'd': moveData,
    };
    send(jsonEncode(data));
  }

  void movePiece(Map moveData) {
    final data = {
      't': 'move',
      'd': moveData,
    };
    send(jsonEncode(data));
  }

  void acceptFirstMove() {
    final data = {
      't': 'first_move_choice',
      'd': 'accept',
    };
    send(jsonEncode(data));
  }

  void rejectFirstMove() {
    final data = {
      't': 'first_move_choice',
      'd': 'reject',
    };
    send(jsonEncode(data));
  }
}
