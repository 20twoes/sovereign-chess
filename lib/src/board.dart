import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'config.dart';
import 'fen.dart' as fen;
import 'piece.dart' as plib;
import 'square.dart';
import 'square_key.dart' as sk;

final coloredSquares = {
  'h9': colors.whiteSquare,
  'i8': colors.whiteSquare,
  'h8': colors.blackSquare,
  'i9': colors.blackSquare,
  'g7': colors.ashSquare,
  'j10': colors.ashSquare,
  'g10': colors.slateSquare,
  'j7': colors.slateSquare,
  'h11': colors.pinkSquare,
  'i6': colors.pinkSquare,
  'e12': colors.redSquare,
  'l5': colors.redSquare,
  'f9': colors.orangeSquare,
  'k8': colors.orangeSquare,
  'f11': colors.yellowSquare,
  'k6': colors.yellowSquare,
  'f6': colors.greenSquare,
  'k11': colors.greenSquare,
  'f8': colors.cyanSquare,
  'k9': colors.cyanSquare,
  'e5': colors.navySquare,
  'l12': colors.navySquare,
  'h6': colors.violetSquare,
  'i11': colors.violetSquare,
};

// TODO: Not sure how to make this return type Color and not Color?
Color? getBackgroundColor(row, col, name) {
  var bgColor = coloredSquares[name];

  if (bgColor == null) {
    if (col % 2 != 0) {
      bgColor = row % 2 == 0 ? colors.darkSquare : colors.lightSquare;
    } else {
      bgColor = row % 2 == 0 ? colors.lightSquare : colors.darkSquare;
    }
  }

  return bgColor;
}

class Board extends StatefulWidget {
  Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final GlobalKey _draggableKey = GlobalKey();
  final _channel = WebSocketChannel.connect(
    Uri.parse(const String.fromEnvironment('WS_URI', defaultValue: 'http://127.0.0.1:3000')),
  );
  plib.Pieces _pieces = fen.read(fen.initialFEN);
  sk.Key? _movingSquare;

  @override
  void initState() {
    super.initState();
    _channel.stream.listen(_handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: sk.files.length,
      scrollDirection: Axis.horizontal,
      children: _generateSquares(),
    );
  }

  List<Widget> _generateSquares() {
    List<Widget> list = [];

    for (final (rankIndex, rank) in sk.ranks.reversed.indexed) {
      for (var (fileIndex, file) in sk.files.indexed) {
        final name = '${file}${rank}';
        plib.Piece? piece = _pieces[name];

        list.add(SquareNode(
          name: name,
          color: getBackgroundColor(rankIndex, fileIndex, name),
          piece: piece,
          dragKey: _draggableKey,
          onMoveCompleted: _handleMoveCompleted,
          onMoveStarted: _handleMoveStarted,
        ));
      }
    }
    return list;
  }

  void _handleMoveStarted(sk.Key squareKey) {
    setState(() {
      _movingSquare = squareKey;
    });
  }

  void _handleMoveCompleted(plib.Piece piece, sk.Key squareKey) {
    setState(() {
      _pieces.remove(_movingSquare);
      _pieces[squareKey] = piece;
      final newFEN = fen.write(_pieces);
      print('$piece from $_movingSquare to $squareKey');
      print('Updated FEN: $newFEN');
      _channel.sink.add(newFEN);
    });
  }

  void _handleMessage(message) {
    // TODO: Consider using StreamBuilder to have the UI automatically update
    // in response to incoming messages
    print('message received: $message');
    setState(() {
      _pieces = fen.read(message);
    });
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }
}
