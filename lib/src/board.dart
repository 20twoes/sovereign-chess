import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'config.dart';
import 'fen.dart' as fen;
import 'piece.dart' as plib;
import 'square.dart';
import 'square_key.dart';

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
    Uri.parse('ws://localhost:3000'),
  );

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: files.length,
      children: _generateSquares(),
    );
  }

  List<Widget> _generateSquares() {
    List<Widget> list = [];

    final pieces = fen.read(fen.initialFEN);

    for (final (rankIndex, rank) in ranks.reversed.indexed) {
      for (var (fileIndex, file) in files.indexed) {
        final name = '${file}${rank}';
        plib.Piece? piece = pieces[name];

        list.add(SquareNode(
          name: name,
          color: getBackgroundColor(rankIndex, fileIndex, name),
          piece: piece,
          dragKey: _draggableKey,
          onChange: _handlePieceMove,
        ));
      }
    }
    return list;
  }

  void _handlePieceMove() {
    _channel.sink.add('test send');
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
