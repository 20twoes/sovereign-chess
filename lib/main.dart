import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'
    show MultiProvider, Provider, ProxyProvider, ProxyProvider2, StreamProvider;
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'src/api/api.dart' show Api;
import 'src/api/auth_service.dart' show AuthService;
import 'src/api/game_service.dart' show GameService;
import 'src/game/game.dart' show GameForList;
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
    MultiProvider(
      providers: [
        Provider.value(value: Api()),
        ProxyProvider<Api, AuthService>(
          update: (context, api, authService) {
            final service = AuthService(api: api);
            service.getUser();
            return service;
          },
        ),
        StreamProvider<UserModel>(
          create: (context) =>
              Provider.of<AuthService>(context, listen: false).user,
          initialData: UserModel(),
        ),
        ProxyProvider2<Api, UserModel, GameService>(
            update: (context, api, userModel, gameService) {
          final service = GameService(api: api, userModel: userModel);
          service.fetchGames();
          return service;
        }),
        StreamProvider<List<GameForList>>(
          create: (context) =>
              Provider.of<GameService>(context, listen: false).games,
          initialData: [],
        ),
      ],
      child: const SochessApp(),
    ),
  );
}

class SochessApp extends StatelessWidget {
  const SochessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
