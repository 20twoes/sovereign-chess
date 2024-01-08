import 'package:flutter/material.dart';

import 'config.dart';
import 'piece.dart' as plib;
import 'square_key.dart' as sk;

final pieceColors = {
  plib.Color.white: colors.whitePiece,
  plib.Color.black: colors.blackPiece,
  plib.Color.ash: colors.ashPiece,
  plib.Color.slate: colors.slatePiece,
  plib.Color.pink: colors.pinkPiece,
  plib.Color.red: colors.redPiece,
  plib.Color.orange: colors.orangePiece,
  plib.Color.yellow: colors.yellowPiece,
  plib.Color.green: colors.greenPiece,
  plib.Color.cyan: colors.cyanPiece,
  plib.Color.navy: colors.navyPiece,
  plib.Color.violet: colors.violetPiece,
};

class SquareNode extends StatefulWidget {
  final Color? color;
  final sk.Key name;
  plib.Piece? piece;
  final GlobalKey dragKey;
  final void Function(plib.Piece, sk.Key) onMoveCompleted;
  final void Function(sk.Key) onMoveStarted;

  SquareNode({
    super.key,
    required this.color,
    required this.name,
    this.piece,
    required this.dragKey,
    required this.onMoveCompleted,
    required this.onMoveStarted,
  });

  @override
  State<SquareNode> createState() => _SquareNodeState();
}

class _SquareNodeState extends State<SquareNode> {
  @override
  Widget build(BuildContext context) {
    return widget.piece == null ? _buildSquareNode() : _buildPieceNode();
  }

  Widget _buildSquareNode() {
    return DragTarget<plib.Piece>(
      builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
        return Container(
          child: Column(
            children: [
              _Label(name: widget.name),
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 0.0, color: Colors.black26),
            color: widget.color,
          ),
        );
      },
      onAccept: (plib.Piece piece) {
        _handleMoveCompleted(piece);
      },
    );
  }

  Widget _buildPieceNode() {
    return Container(
      child: Column(
        children: [
          _Label(name: widget.name),
          Draggable<plib.Piece>(
            data: widget.piece,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            maxSimultaneousDrags: 1,
            onDragStarted: _handleDragStarted,
            feedback: _DraggingPiece(
              dragKey: widget.dragKey,
              piece: widget.piece,
            ),
            childWhenDragging: Text(' '),
            child: Container(
              child: _PieceWidget(piece: widget.piece),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0.0, color: Colors.black26),
        color: widget.color,
      ),
    );
  }

  void _handleDragStarted() {
    //print('${widget.piece} started moving from ${widget.name}');
    widget.onMoveStarted(widget.name);
  }

  void _handleMoveCompleted(plib.Piece piece) {
    //print('$piece moved to ${widget.name}');
    setState(() {
      widget.piece = piece;
    });
    widget.onMoveCompleted(piece, widget.name);
  }
}

class _Label extends StatelessWidget {
  final String name;

  _Label({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        color: Colors.pinkAccent,
        decoration: TextDecoration.none,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

class _PieceWidget extends StatelessWidget {
  final plib.Piece? piece;

  _PieceWidget({
    super.key,
    this.piece,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        '${piece?.name}',
        style: TextStyle(
          color: pieceColors[piece?.color],
          decoration: TextDecoration.none,
          fontSize: 24.0,
        ),
      ),
    );
  }
}

class _DraggingPiece extends StatelessWidget {
  final GlobalKey dragKey;
  final plib.Piece? piece;

  const _DraggingPiece({
    super.key,
    required this.dragKey,
    required this.piece,
  });

  @override
  Widget build(BuildContext context) {
    return _PieceWidget(piece: piece);
  }
}
