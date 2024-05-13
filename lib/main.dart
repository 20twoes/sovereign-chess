import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, Provider;
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'src/data/user.dart' show getUser;
import 'src/game/game.dart' as game;
import 'src/screens/game_detail.dart' show GameDetailScreen;
import 'src/screens/home.dart' show HomeScreen;
import 'src/user.dart' show UserModel;

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(key: Key('home screen')),
      routes: [
        GoRoute(
          path: 'play/:game_id',
          builder: (BuildContext context, GoRouterState state) {
            return GameDetailScreen(
              gameId: state.pathParameters['game_id']!,
            );
          },
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true,
);

void main() {
  usePathUrlStrategy();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: const SochessApp(),
    ),
  );
}

class SochessApp extends StatefulWidget {
  const SochessApp({super.key});

  @override
  State<StatefulWidget> createState() => _SochessAppState();
}

class _SochessAppState extends State<SochessApp> {
  late Future<UserModel> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = getUser();
    _futureUser.then((user) {
      Provider.of<UserModel>(context, listen: false).setUser(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _futureUser,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        return MaterialApp.router(
          routerConfig: _router,
        );
      },
    );
  }
}
