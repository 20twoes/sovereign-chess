import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show Consumer, Provider;
import 'package:url_launcher/url_launcher.dart';

import '../api/game_service.dart' show GameService;
import '../game/game.dart' show GameForList, GameState, StaticBoard;
import '../user.dart' show UserModel;
import 'scaffold.dart' show AppScaffold;

final Uri _learnUrl = Uri.parse('https://www.infinitepigames.com/sc-rules');

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _createGame(BuildContext context) async {
    final newGame = await Provider.of<GameService>(context, listen: false).createGame();
    if (newGame?.id != null) {
      context.go('/play/${newGame?.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          const Hero(),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: TextButton(
              onPressed: () => launchUrl(_learnUrl),
              child: Text('Learn the rules'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              right: 16.0,
              bottom: 48.0,
            ),
            child: ElevatedButton(
              onPressed: () => _createGame(context),
              child: Text('Create a game'),
            ),
          ),
          Expanded(
            child: GameList(),
          ),
        ],
      ),
    );
  }
}

class Hero extends StatelessWidget {
  const Hero({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: 16.0,
        ),
        child: const Logo(),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sovereign Chess',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 32,
        foreground: Paint()
          ..shader = ui.Gradient.linear(
            const Offset(0, 20),
            const Offset(300, 20),
            <Color>[
              Colors.pink,
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.cyan,
              Colors.blue,
              Colors.purple,
            ],
            [
              0.1,
              0.2,
              0.3,
              0.4,
              0.5,
              0.6,
              0.7,
              0.8,
            ],
            TileMode.repeated,
          )
      ),
    );
  }
}

class GameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GameForList>>(
      stream: Provider.of<GameService>(context).games,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildList(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildList(List<GameForList> games) {
    if (games.length == 0) {
      return Text('');
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      color: Colors.pink[50],
      child: Column(
        children: [
          Container(
            color: Colors.pink[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Your games'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: games.length,
              itemBuilder: (BuildContext context, int index) {
                final game = games[index];
                return GestureDetector(
                  child: GameListTile(game),
                  onTap: () => context.go('/play/' + game.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GameListTile extends StatelessWidget {
  final GameForList currentGame;

  GameListTile(this.currentGame);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          StaticBoard(fenStr: currentGame.fen),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GameInfo(game: currentGame),
            ),
          ),
        ],
      ),
    );
  }
}

class GameInfo extends StatelessWidget {
  final GameForList game;

  GameInfo({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_getStatus()),
        Text(
          'ID: ${game.id}',
          style: TextStyle(
            fontSize: 10,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  String _getStatus() {
    return switch (game.state) {
      GameState.Created => 'Challenge',
      _ => 'TODO: Need to implement',
    };
  }
}
