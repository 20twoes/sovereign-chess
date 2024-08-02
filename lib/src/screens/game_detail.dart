import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../api/websocket_service.dart' show WebsocketService;
import '../game/game.dart' show Board, FEN, Game, GameState;
import '../game/piece.dart' show Role, roleNotations;
import '../user.dart' show UserModel;
import 'scaffold.dart' show AppScaffold;

class GameDetailScreen extends StatelessWidget {
  final String gameId;

  GameDetailScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return GameData(gameId: gameId);
  }
}

class GameData extends StatefulWidget {
  final String gameId;

  GameData({super.key, required this.gameId});

  @override
  State<GameData> createState() => _GameDataState();
}

class _GameDataState extends State<GameData> {
  WebsocketService? _wss;
  Game? _gameCache;

  @override
  void didChangeDependencies() {
    if (_wss == null) {
      final user = Provider.of<UserModel>(context);
      if (user.isReady()) {
        _wss = WebsocketService(gameId: widget.gameId, user: user);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: StreamBuilder<dynamic>(
        stream: _wss?.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Strack trace: ${snapshot.stackTrace}');
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Connection closed');
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                return _buildScreen(snapshot.data);
              case ConnectionState.done:
                return Text('Connection done/closed');
            }
          }
        },
      ),
    );
  }

  Widget _buildScreen(String data) {
    final json = jsonDecode(data) as Map<String, dynamic>;

    // Check for error messages
    final error = _getError(json);

    if (error != null) {
      // Don't update the board.  Show previous board state, along with error message.
      return Stack(
        children: <Widget>[
          _getScreen(_gameCache as Game),
          Container(
            child: Text(
              error,
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.8)),
            padding: const EdgeInsets.all(4),
          ),
        ],
      );
    } else {
      final game = Game.fromJson(json);
      _gameCache = game;
      return _getScreen(game);
    }
  }

  String? _getError(Map<String, dynamic> json) {
    return json['message'];
  }

  Widget _getScreen(Game game) {
    return switch (game.state) {
      GameState.Created => GameCreatedScreen(
          game: game,
          joinGame: _wss?.joinGame,
        ),
      GameState.Accepted => GameAcceptedScreen(
          game: game,
          onPieceMove: _wss!.makeFirstMove,
        ),
      GameState.FirstMove => GameFirstMoveScreen(
          game: game,
          onAcceptFirstMove: _wss!.acceptFirstMove,
          onRejectFirstMove: _wss!.rejectFirstMove,
        ),
      GameState.InProgress => GameInProgressScreen(
          game: game,
          onPieceMove: _wss!.movePiece,
        ),
      _ => throw Exception('Implement screen for game state: ${game.state}'),
    };
  }

  @override
  void dispose() {
    _wss?.close();
    super.dispose();
  }
}

class GameCreatedScreen extends StatelessWidget {
  final Game game;
  final Function? joinGame;

  GameCreatedScreen({required this.game, required this.joinGame});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    if (user.isReady() && game.userCreatedGame(user.id as String)) {
      return _buildScreenForPlayer1(context);
    } else {
      return _buildScreenForPlayer2(context);
    }
  }

  Widget _buildScreenForPlayer1(BuildContext context) {
    return Center(
      child: SelectableText(
          'To invite someone to play, give this URL: ${Uri.base}'),
    );
  }

  Widget _buildScreenForPlayer2(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _handleJoinGame,
        child: Text('Join this game with ${game.player1}'),
      ),
    );
  }

  void _handleJoinGame() {
    if (joinGame != null) {
      joinGame!();
    }
  }
}

class GameAcceptedScreen extends StatelessWidget {
  final ValueChanged<Map<String, String>> onPieceMove;
  final Game game;

  GameAcceptedScreen({
    required this.onPieceMove,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Board(
      onPieceMove: (data) => _handlePieceMove(context, data),
      currentFEN: game.fen,
    );
  }

  void _handlePieceMove(BuildContext context, String san) {
    // Do any additional data formatting and validation here
    onPieceMove(buildWebsocketMessage(san));
  }
}

class GameFirstMoveScreen extends StatelessWidget {
  final Game game;
  final void Function() onAcceptFirstMove;
  final void Function() onRejectFirstMove;

  GameFirstMoveScreen({
    required this.game,
    required this.onAcceptFirstMove,
    required this.onRejectFirstMove,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (!user.isReady()) {
      return Text('Loading...');
    }

    final isPlayer1 = game.userCreatedGame(user.id as String);

    return Stack(
      children: <Widget>[
        Board(
          onPieceMove: (data) => null,
          currentFEN: game.fen,
        ),
        if (isPlayer1) _getPlayer1Dialog(),
        if (!isPlayer1) _getPlayer2Dialog(),
      ],
    );
  }

  Widget _getPlayer1Dialog() {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text(
            'Waiting on Player 2 to decide whether they want to play as white or black...'),
      ),
    );
  }

  Widget _getPlayer2Dialog() {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text(
            'Do you want to accept the first move and play as white? Or reject the first move and play as black?'),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text('Accept'),
            onPressed: () {
              onAcceptFirstMove();
            }),
        TextButton(
            child: const Text('Reject'),
            onPressed: () {
              onRejectFirstMove();
            }),
      ],
    );
  }
}

class GameInProgressScreen extends StatefulWidget {
  final ValueChanged<Map<String, String>> onPieceMove;
  final Game game;

  GameInProgressScreen({
    required this.onPieceMove,
    required this.game,
  });

  @override
  State<GameInProgressScreen> createState() => _GameInProgressScreenState();
}

class _GameInProgressScreenState extends State<GameInProgressScreen> {
  bool _showPromotionDialog = false;
  String? _promotionSAN;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Board(
          onPieceMove: (data) => _handlePieceMove(context, data),
          currentFEN: widget.game.fen,
          onPromotion: _handlePromotion,
        ),
        if (_showPromotionDialog) _promotionDialog(),
      ],
    );
  }

  void _handlePieceMove(BuildContext context, String san) {
    // Do any additional data formatting and validation here
    widget.onPieceMove(buildWebsocketMessage(san));
  }

  void _handlePromotion(String san) {
    setState(() {
      _showPromotionDialog = true;
      _promotionSAN = san;
    });
  }

  Widget _promotionDialog() {
    final roles = <Role>[
      Role.queen,
      Role.king,
      Role.knight,
      Role.rook,
      Role.bishop,
    ];

    return AlertDialog(
      content: Text('Promote pawn to:'),
      actions: roles
          .map((role) => TextButton(
                child: Text("${role.name}"),
                onPressed: () {
                  setState(() {
                    _showPromotionDialog = false;
                    final san = "${_promotionSAN}=${roleNotations[role]}";
                    print(san);
                    widget.onPieceMove(buildWebsocketMessage(san));
                  });
                },
              ))
          .toList(),
    );
  }
}

Map<String, String> buildWebsocketMessage(String san) {
  return {
    'san': san,
  };
}
