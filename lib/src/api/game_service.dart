import 'dart:async';

import 'package:flutter/foundation.dart';

import 'api.dart' show Api;
import '../game/game.dart' show Game, GameForList;
import '../user.dart' show UserModel;

class GameService {
  final Api api;
  final UserModel userModel;

  GameService({required this.api, required this.userModel});

  StreamController<List<GameForList>> _gamesController =
      StreamController<List<GameForList>>.broadcast();

  Stream<List<GameForList>> get games => _gamesController.stream;

  void fetchGames() async {
    if (userModel.isReady()) {
      final games = await api.fetchGames(userModel.id!);
      _gamesController.add(games);
    }
  }

  Future<Game>? createGame() async {
    if (userModel.isReady()) {
      final game = await api.createGame(userModel.id!);
      return game;
    }
  }
}
