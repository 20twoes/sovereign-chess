import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'config.dart';
import 'fen.dart' as fen;
import 'piece.dart' as plib;
import 'square.dart';
import 'square_key.dart' as sk;

final coloredSquares = {
  'h09': colors.whiteSquare,
  'i08': colors.whiteSquare,
  'h08': colors.blackSquare,
  'i09': colors.blackSquare,
  'g07': colors.ashSquare,
  'j10': colors.ashSquare,
  'g10': colors.slateSquare,
  'j07': colors.slateSquare,
  'h11': colors.pinkSquare,
  'i06': colors.pinkSquare,
  'e12': colors.redSquare,
  'l05': colors.redSquare,
  'f09': colors.orangeSquare,
  'k08': colors.orangeSquare,
  'f11': colors.yellowSquare,
  'k06': colors.yellowSquare,
  'f06': colors.greenSquare,
  'k11': colors.greenSquare,
  'f08': colors.cyanSquare,
  'k09': colors.cyanSquare,
  'e05': colors.navySquare,
  'l12': colors.navySquare,
  'h06': colors.violetSquare,
  'i11': colors.violetSquare,
};

Color getBackgroundColor(row, col, name) {
  var bgColor = coloredSquares[name];

  if (bgColor == null) {
    if (col % 2 != 0) {
      bgColor = row % 2 == 0 ? colors.darkSquare : colors.lightSquare;
    } else {
      bgColor = row % 2 == 0 ? colors.lightSquare : colors.darkSquare;
    }
  }

  return bgColor as Color;
}

String _parseFen(String fen) {
  // Only interested in the first field which contains the piece placements (board FEN)
  return fen.split(' ')[0];
}

class StaticBoard extends StatelessWidget {
  final String fenStr;
  late plib.Pieces _pieces;

  StaticBoard({super.key, required this.fenStr}) {
    _pieces = fen.read(_parseFen(fenStr));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> squares = _generateSquares();
    List<List<Widget>> files = _splitIntoFiles(squares);

    return Row(
      children: <Widget>[
        for (final file in files)
          Column(
            children: file.reversed.toList(),
          ),
      ],
    );
  }

  List<Widget> _generateSquares() {
    List<Widget> squares = [];
    var isLightColorSquare = false;

    Color getColor(String key) {
      final color = isLightColorSquare ? colors.lightSquare : colors.darkSquare;
      return color as Color;
    }

    final lastRank = sk.rowLength.toString();

    for (final key in sk.allKeys) {
      plib.Piece? piece = _pieces[key];
      Color color = coloredSquares[key] ?? getColor(key);

      // When we get to the end of a file, don't change colors
      if (!key.endsWith(lastRank)) {
        isLightColorSquare = !isLightColorSquare;
      }

      squares.add(StaticSquareNode(
        color: color,
        piece: piece,
      ));
    }

    return squares;
  }

  List<List<Widget>> _splitIntoFiles(List<Widget> squares) {
    List<Widget> copy = List.from(squares);
    var files = <List<Widget>>[];
    final colLen = sk.rowLength;

    while (copy.length > 0) {
      Iterable<Widget> file = copy.take(colLen);
      files.add(file.toList());
      copy.removeRange(0, colLen);
    }

    return files;
  }
}

class Board extends StatefulWidget {
  final ValueChanged<Map<String, String>> onPieceMove;
  final fen.FEN currentFEN;
  late plib.Pieces _pieces;

  Board({
    super.key,
    required this.onPieceMove,
    required this.currentFEN,
  }) : _pieces = fen.read(currentFEN);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final GlobalKey _draggableKey = GlobalKey();
  sk.Key? _movingSquare;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: sk.files.length,
      children: _generateSquares(),
    );
  }

  List<Widget> _generateSquares() {
    List<Widget> list = [];

    for (final (rankIndex, rank) in sk.ranks.reversed.indexed) {
      for (var (fileIndex, file) in sk.files.indexed) {
        final name = '${file}${rank}';
        plib.Piece? piece = widget._pieces[name];

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
      if (_movingSquare == squareKey) {
        print('$piece from $_movingSquare to $squareKey - same square');
        return;
      }
      widget._pieces.remove(_movingSquare);
      widget._pieces[squareKey] = piece;
      final newFEN = fen.write(widget._pieces);
      print('$piece from $_movingSquare to $squareKey');
      print('Updated FEN: $newFEN');
      final moveData = {
        'fen': newFEN,
        'san': '${piece.notation}$_movingSquare$squareKey',
      };
      widget.onPieceMove(moveData);
    });
  }
}
