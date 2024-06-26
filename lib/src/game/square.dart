import 'package:flutter/material.dart';

import 'config.dart';
import 'piece.dart' as plib;
import 'square_key.dart' as sk;

class StaticSquareNode extends StatelessWidget {
  final Color color;
  plib.Piece? piece;

  StaticSquareNode({
    super.key,
    required this.color,
    this.piece,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 10,
        height: 10,
        child: piece != null ? _PieceWidget(piece: piece) : null,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0.0, color: Colors.black26),
        color: color,
      ),
    );
  }
}

class SquareNode extends StatefulWidget {
  final Color color;
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
    return DragTarget<plib.Piece>(
      builder: (BuildContext context, List<dynamic> candidateData,
          List<dynamic> rejectedData) {
        final backgroundColor =
            (candidateData.length > 0) ? hoverColor : widget.color;

        return Container(
          child: Stack(
            children: [
              _Label(name: widget.name),
              if (widget.piece != null)
                Positioned.fill(
                  child: Draggable<plib.Piece>(
                    data: widget.piece,
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    maxSimultaneousDrags: 1,
                    onDragStarted: _handleDragStarted,
                    feedback: _DraggingPiece(
                      dragKey: widget.dragKey,
                      piece: widget.piece,
                    ),
                    childWhenDragging: Container(),
                    child: Container(
                      child: _PieceWidget(piece: widget.piece),
                    ),
                  ),
                ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 0.0, color: Colors.black26),
            color: backgroundColor,
          ),
        );
      },
      onAccept: (plib.Piece piece) {
        _handleMoveCompleted(piece);
      },
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
    final pieceRenderer = plib.PieceRenderer(piece as plib.Piece);
    return pieceRenderer.asWidget();
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
