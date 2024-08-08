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
  final sk.Square square;
  final Color color;
  final sk.Key name;
  plib.Piece? piece;
  final GlobalKey dragKey;
  final void Function(plib.Piece, sk.Square) onMoveCompleted;
  final void Function(sk.Square) onMoveStarted;

  SquareNode({
    super.key,
    required this.square,
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
            border: _calcBorder(),
            color: backgroundColor,
          ),
        );
      },
      onAccept: (plib.Piece piece) {
        _handleMoveCompleted(piece);
      },
    );
  }

  Border _calcBorder() {
    final defaultLine = BorderSide(width: 0.0, color: Colors.black26);
    final quadrantLine = BorderSide(width: 4.0, color: Colors.brown);
    final promotionLine = BorderSide(width: 4.0, color: Colors.black);

    return switch (widget.square) {
      // Horizontal quadrant boundary
      sk.Square.A8 ||
      sk.Square.B8 ||
      sk.Square.C8 ||
      sk.Square.D8 ||
      sk.Square.E8 ||
      sk.Square.F8 ||
      sk.Square.K8 ||
      sk.Square.L8 ||
      sk.Square.M8 ||
      sk.Square.N8 ||
      sk.Square.O8 ||
      sk.Square.P8 =>
        Border(
          top: quadrantLine,
          right: defaultLine,
          bottom: defaultLine,
          left: defaultLine,
        ),
      // Vertical quadrant boundary
      sk.Square.H1 ||
      sk.Square.H2 ||
      sk.Square.H3 ||
      sk.Square.H4 ||
      sk.Square.H5 ||
      sk.Square.H6 ||
      sk.Square.H11 ||
      sk.Square.H12 ||
      sk.Square.H13 ||
      sk.Square.H14 ||
      sk.Square.H15 ||
      sk.Square.H16 =>
        Border(
          top: defaultLine,
          right: quadrantLine,
          bottom: defaultLine,
          left: defaultLine,
        ),
      // Promotion box horizontal lines
      sk.Square.H7 || sk.Square.I7 => Border(
          top: defaultLine,
          right: defaultLine,
          bottom: promotionLine,
          left: defaultLine,
        ),
      sk.Square.H10 || sk.Square.I10 => Border(
          top: promotionLine,
          right: defaultLine,
          bottom: defaultLine,
          left: defaultLine,
        ),
      // Promotion box vertical lines
      sk.Square.G8 || sk.Square.G9 => Border(
          top: defaultLine,
          right: defaultLine,
          bottom: defaultLine,
          left: promotionLine,
        ),
      sk.Square.J8 || sk.Square.J9 => Border(
          top: defaultLine,
          right: promotionLine,
          bottom: defaultLine,
          left: defaultLine,
        ),
      // NW corner
      sk.Square.G10 => Border(
          top: promotionLine,
          right: defaultLine,
          bottom: defaultLine,
          left: promotionLine,
        ),
      // NE corner
      sk.Square.J10 => Border(
          top: promotionLine,
          right: promotionLine,
          bottom: defaultLine,
          left: defaultLine,
        ),
      // SW corner
      sk.Square.G7 => Border(
          top: defaultLine,
          right: defaultLine,
          bottom: promotionLine,
          left: promotionLine,
        ),
      // SE corner
      sk.Square.J7 => Border(
          top: defaultLine,
          right: promotionLine,
          bottom: promotionLine,
          left: defaultLine,
        ),
      _ => Border(
          top: defaultLine,
          right: defaultLine,
          bottom: defaultLine,
          left: defaultLine,
        ),
    };
  }

  void _handleDragStarted() {
    //print('${widget.piece} started moving from ${widget.name}');
    widget.onMoveStarted(widget.square);
  }

  void _handleMoveCompleted(plib.Piece piece) {
    //print('$piece moved to ${widget.name}');
    setState(() {
      widget.piece = piece;
    });
    widget.onMoveCompleted(piece, widget.square);
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
