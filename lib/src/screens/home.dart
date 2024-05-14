import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show Consumer, Provider;

import '../data/game.dart' show fetchGames;
import '../game/game.dart' show GameForList, StaticBoard, fetchGames;
import '../user.dart' show UserModel;
import 'scaffold.dart' show AppScaffold;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          return GamesData(userModel: userModel);
        },
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
    return ListView(
      children: [
        for (var g in games)
          GestureDetector(
            child: GameListItem(g),
            onTap: () => context.go('/play/' + g.id),
          )
      ],
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
      padding: const EdgeInsets.all(16),
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

