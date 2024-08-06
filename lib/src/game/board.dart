import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'config.dart';
import 'fen.dart' as fen;
import 'piece.dart' as plib;
import 'square.dart';
import 'square_key.dart' as sk;

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
    List<Widget> squares = _generateSquares().toList();
    List<List<Widget>> ranks = List.generate(
      sk.boardWidth,
      (i) => squares.sublist(
        (i * sk.boardWidth),
        (i * sk.boardWidth) + sk.boardWidth,
      ),
      growable: false,
    );

    // NOTE: Can't seem to use GridView here
    return Column(
      children: ranks
          .map((rank) => Row(
                children: rank
                    .map(
                      (sq) => sq,
                    )
                    .toList(),
              ))
          .toList(),
    );
  }

  Iterable<Widget> _generateSquares() {
    return sk.fenIter().map((sq) {
      plib.Piece? piece = _pieces[sq];

      return StaticSquareNode(
        color: sq.backgroundColor,
        piece: piece,
      );
    });
  }
}

class Board extends StatefulWidget {
  final ValueChanged<String> onPieceMove;
  final fen.FEN currentFEN;
  final Function? onPromotion;
  late plib.Pieces _pieces;

  Board({
    super.key,
    required this.onPieceMove,
    required this.currentFEN,
    this.onPromotion,
  }) : _pieces = fen.read(currentFEN);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final GlobalKey _draggableKey = GlobalKey();
  sk.Square? _movingSquare;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: sk.boardWidth,
      children: _generateSquares(),
    );
  }

  List<Widget> _generateSquares() {
    return sk.fenIter().map((sq) {
      plib.Piece? piece = widget._pieces[sq];

      return SquareNode(
        square: sq,
        name: sq.name,
        color: sq.backgroundColor,
        piece: piece,
        dragKey: _draggableKey,
        onMoveCompleted: _handleMoveCompleted,
        onMoveStarted: _handleMoveStarted,
      );
    }).toList();
  }

  void _handleMoveStarted(sk.Square square) {
    setState(() {
      _movingSquare = square;
    });
  }

  void _handleMoveCompleted(plib.Piece piece, sk.Square square) {
    setState(() {
      if (_movingSquare == square) {
        print(
            '$piece from ${_movingSquare!.name} to ${square.name} - same square');
        return;
      }

      widget._pieces.remove(_movingSquare);
      widget._pieces[square] = piece;
      final san = '${piece.notation}${_movingSquare!.sanName}${square.sanName}';

      // Check if we're promoting a pawn first
      if (square.isPromotionSquare && piece.role == plib.Role.pawn) {
        widget.onPromotion?.call(san);
      } else {
        //final newFEN = fen.write(widget._pieces);
        //print('Updated FEN: $newFEN');
        print('$piece from $_movingSquare to ${square.name}');
        widget.onPieceMove(san);
      }
    });
  }
}
