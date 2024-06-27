import 'dart:convert';

import 'package:http/http.dart' as http;

import '../user.dart' show UserModel;
import '../game/game.dart' show Game, GameForList;

// Network requests for the app
class Api {
  static const baseUrl =
      "${String.fromEnvironment('API_HOST', defaultValue: 'http://127.0.0.1:3000/api')}";
  static const userEndpoint = "$baseUrl/users";
  static const gameEndpoint = "$baseUrl/games";

  Future<UserModel> createUser() async {
    final response = await http.post(
      Uri.parse(userEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<List<GameForList>> fetchGames(String userId) async {
    final response = await http.get(
      Uri.parse(gameEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // TODO: Use a proper JWT token or similar
        'Authorization': 'Temp $userId',
      },
    );

    if (response.statusCode == 200) {
      final games = jsonDecode(response.body) as List<dynamic>;
      return games.map((game) => GameForList.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load game');
    }
  }

  Future<Game> createGame(String userId) async {
    final response = await http.post(
      Uri.parse(gameEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Temp $userId',
      },
    );

    if (response.statusCode == 200) {
      return Game.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create game.');
    }
  }
}
