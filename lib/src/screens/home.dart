import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show Consumer, Provider;
import 'package:url_launcher/url_launcher.dart';

import '../data/game.dart' show createGame, fetchGames;
import '../game/game.dart' show GameForList, GameState, StaticBoard;
import '../user.dart' show UserModel;
import 'scaffold.dart' show AppScaffold;

final Uri _learnUrl = Uri.parse('https://www.infinitepigames.com/sc-rules');

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _createGame(BuildContext context, UserModel userModel) async {
    final newGame = await createGame(userModel.id!);
    context.go('/play/' + newGame.id);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          return Column(
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
                  onPressed: () => _createGame(context, userModel),
                  child: Text('Create a game'),
                ),
              ),
              Expanded(
                child: GamesData(userModel: userModel),
              ),
            ],
          );
        },
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

class GamesData extends StatefulWidget {
  final UserModel userModel;

  GamesData({required this.userModel, super.key});

  @override
  State<StatefulWidget> createState() => _GamesDataState();
}

class _GamesDataState extends State<GamesData> {
  late Future<List<GameForList>> _futureGames;

  @override
  void initState() {
    super.initState();
    _futureGames = fetchGames(widget.userModel.id);
  }

  @override
  void didUpdateWidget(GamesData oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _futureGames = fetchGames(widget.userModel.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GameForList>>(
      future: _futureGames,
      builder: (context, snapshot) {
        if (widget.userModel.id == null) {
          print('userid == null: ${widget.userModel.id}');
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          print('snapshot.hasData: ${widget.userModel.id} ${snapshot.data}');
          return GameList(games: snapshot.data!);
        } else if (snapshot.hasError) {
          print('snapshot.hasError: ${widget.userModel.id}');
          return Text('${snapshot.error}');
        }

        print('else: ${widget.userModel.id}');
        return const CircularProgressIndicator();
      }
    );
  }
}

class GameList extends StatelessWidget {
  final List<GameForList> games;

  GameList({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    if (games.length == 0) {
      return Text('You have no active games');
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
