import 'dart:convert';

import 'package:http/http.dart' as http;

import '../game/game.dart' show Game, GameForList;
import 'common.dart' show baseApiUrl;

const apiUrl = "$baseApiUrl/games";

Future<List<GameForList>> fetchGames(String? userId) async {
  if (userId == null) {
    return [];
  }

  final response = await http.get(
    Uri.parse(apiUrl),
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
    Uri.parse(apiUrl),
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
