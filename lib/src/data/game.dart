import 'dart:convert';

import 'package:http/http.dart' as http;

import '../game/game.dart' show GameForList;
import 'common.dart' show baseApiUrl;

const apiUrl = "$baseApiUrl/games";

Future<List<GameForList>> fetchGames() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final games = jsonDecode(response.body) as List<dynamic>;
    return games.map((game) => GameForList.fromJson(game)).toList();
  } else {
    throw Exception('Failed to load game');
  }
}

Future<GameForList> createGame() async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return GameForList.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create game.');
  }
}
