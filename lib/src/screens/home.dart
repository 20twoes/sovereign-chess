import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show Consumer, Provider;

import '../data/game.dart' show createGame, fetchGames;
import '../game/game.dart' show GameForList, StaticBoard;
import '../user.dart' show UserModel;
import 'scaffold.dart' show AppScaffold;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _createGame(BuildContext context, UserModel userModel) async {
    final newGame = await createGame(userModel.id!);
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
                  onPressed: () { },
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
    print('GamesData initState: ${widget.userModel.id}');
    _futureGames = fetchGames(widget.userModel.id);
  }

  @override
  void didUpdateWidget(GamesData oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('GamesData didUpdateWidget: ${widget.userModel.id}');
    setState(() {
      _futureGames = fetchGames(widget.userModel.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('GamesData build: ${widget.userModel.id}');
    return FutureBuilder<List<GameForList>>(
      future: _futureGames,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GameList(games: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

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
          Flexible(
            child: Container(
              color: Colors.pink[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Your games'),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (var g in games)
                  GestureDetector(
                    child: GameListItem(g),
                    onTap: () => context.go('/play/' + g.id),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//class GamesListScreen extends StatefulWidget {
//  final ValueChanged<game.GameForList> onTapped;
//
//  const GamesListScreen({super.key, required this.onTapped});
//
//  @override
//  State<GamesListScreen> createState() => _GamesListScreenState();
//}
//
//class _GamesListScreenState extends State<GamesListScreen> {
//  late Future<List<game.GameForList>> _futureGames;
//
//  @override
//  void initState() {
//    super.initState();
//    _futureGames = game.fetchGames();
//  }
//
//  void _createGame() async {
//    final newGame = await game.createGame();
//    final currentGames = await _futureGames;
//    // Don't need to use setState since we navigate to another page
//    _futureGames = Future.value([...currentGames, newGame]);
//    widget.onTapped(newGame);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//        title: Text('Sovereign Chess'),
//      ),
//      body: FutureBuilder<List<game.GameForList>>(
//        future: _futureGames,
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            return ListView(
//              children: [
//                for (var g in snapshot.data!)
//                  GestureDetector(
//                    child: GameListItem(g),
//                    onTap: () => widget.onTapped(g),
//                  )
//              ],
//            );
//          } else if (snapshot.hasError) {
//            return Text('${snapshot.error}');
//          }
//
//          return const CircularProgressIndicator();
//        },
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _createGame,
//        tooltip: 'Start a new game',
//        child: const Text('Play'),
//      ),
//    );
//  }
//}

class GameListItem extends StatelessWidget {
  final GameForList currentGame;

  GameListItem(this.currentGame);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: StaticBoard(fenStr: currentGame.fen),
          ),
          Expanded(
            child: Text(currentGame.id),
          ),
        ],
      ),
    );
  }
}
