import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'board.dart';

export 'board.dart';

typedef Games = List<Game>;

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

  String get fen => moves.last.fen;
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

const apiUrlGames = "${String.fromEnvironment('API_HOST', defaultValue: 'http://127.0.0.1:3000/api')}/games";

Future<Games> fetchGames() async {
  final response = await http.get(Uri.parse(apiUrlGames));

  if (response.statusCode == 200) {
    final games = jsonDecode(response.body) as List<dynamic>;
    return games.map((game) => Game.fromJson(game)).toList(growable: false);
  } else {
    throw Exception('Failed to load game');
  }
}

Future<Game> createGame() async {
  final response = await http.post(
    Uri.parse(apiUrlGames),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Game.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create game.');
  }
}
