import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'src/fen.dart' as fen;
import 'src/game.dart';

void main() {
  runApp(SochessApp());
}

class SochessApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SochessAppState();
}

class _SochessAppState extends State<SochessApp> {
  GameRouterDelegate _routerDelegate = GameRouterDelegate();
  GameRouteInformationParser _routerInformationParser = GameRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sovereign Chess',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
        useMaterial3: true,
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routerInformationParser,
    );
  }
}

class GameRouteInformationParser extends RouteInformationParser<GameRoutePath> {
  @override
  Future<GameRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return GameRoutePath.home();
    }

    // Handle '/game/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'game') {
        return GameRoutePath.unknown();
      }
      var id = uri.pathSegments[1];
      if (id == null) {
        return GameRoutePath.unknown();
      }
      return GameRoutePath.details(id);
    }

    // Handle unknown routes
    return GameRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(GameRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/game/${path.id}');
    }
    return null;
  }
}

class GameRouterDelegate extends RouterDelegate<GameRoutePath>
  with ChangeNotifier, PopNavigatorRouterDelegateMixin<GameRoutePath> {
    final GlobalKey<NavigatorState> navigatorKey;

  GameForList? _selectedGame;
  bool show404 = false;

  GameRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  GameRoutePath get currentConfiguration {
    if (show404) {
      return GameRoutePath.unknown();
    }
    return _selectedGame == null
      ? GameRoutePath.home()
      : GameRoutePath.details(_selectedGame!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('GamesListPage'),
          child: GamesListScreen(
            onTapped: _handleGameTapped,
          ),
        ),
        if (show404)
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if (_selectedGame != null)
          GameDetailsPage(game: _selectedGame),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _selectedGame = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(GameRoutePath path) async {
    if (path.isUnknown) {
      _selectedGame = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      // TODO: If id is not valid return 404
      //_selectedGame = games[path.id]; // TODO
      //_selectedGame = games[0]; // TODO
    } else {
      _selectedGame = null;
    }

    show404 = false;
  }

  void _handleGameTapped(GameForList game) {
    _selectedGame = game;
    notifyListeners();
  }
}

class GameDetailsPage extends Page {
  final GameForList? game;

  GameDetailsPage({
    required this.game,
  }) : super(key: ValueKey(game));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return GameDetailsScreen(game: game);
      },
    );
  }
}

class GameRoutePath {
  final String? id;
  final bool isUnknown;

  GameRoutePath.home() : id = null, isUnknown = false;

  GameRoutePath.details(this.id) : isUnknown = false;

  GameRoutePath.unknown() : id = null, isUnknown = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}

class GamesListScreen extends StatefulWidget {
  final ValueChanged<GameForList> onTapped;

  const GamesListScreen({super.key, required this.onTapped});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  late Future<List<GameForList>> _futureGames;

  @override
  void initState() {
    super.initState();
    _futureGames = fetchGames();
  }

  void _createGame() async {
    final newGame = await createGame();
    final currentGames = await _futureGames;
    // Don't need to use setState since we navigate to another page
    _futureGames = Future.value([...currentGames, newGame]);
    widget.onTapped(newGame);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Sovereign Chess'),
      ),
      body: FutureBuilder<List<GameForList>>(
        future: _futureGames,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                for (var game in snapshot.data!)
                  GestureDetector(
                    child: GameListItem(game),
                    onTap: () => widget.onTapped(game),
                  )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createGame,
        tooltip: 'Start a new game',
        child: const Text('Play'),
      ),
    );
  }
}

class GameListItem extends StatelessWidget {
  final GameForList game;

  GameListItem(this.game);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: StaticBoard(fenStr: game.fen),
          ),
          Expanded(
            child: Text(game.id),
          ),
        ],
      ),
    );
  }
}

class GameDetailsScreen extends StatefulWidget {
  final GameForList? game;

  GameDetailsScreen({
    super.key,
    this.game,
  });

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

const WS_URI = String.fromEnvironment('WS_URI', defaultValue: 'ws://127.0.0.1:3000/ws');

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  late WebSocketChannel _channel;
  fen.FEN _fen = fen.initialFEN;

  @override
  void initState() {
    super.initState();
    // TODO: Handle case when game is null.  Is this case even posssible?
    _channel = WebSocketChannel.connect(
      Uri.parse(WS_URI + '/v0/play/' + widget.game!.id),
    );
    _channel.stream.listen(_handleMessage);
  }

  void _handleMessage(message) {
    // TODO: Consider using StreamBuilder to have the UI automatically update
    // in response to incoming messages
    print('message received: $message');
    setState(() {
      _fen = message;
    });
  }

  void _handleFENUpdate(fen.FEN newFEN) {
    _channel.sink.add(newFEN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Board(
        onPieceMove: _handleFENUpdate,
        currentFEN: _fen,
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(status.normalClosure);
    super.dispose();
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}
