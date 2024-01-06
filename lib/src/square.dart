import 'package:flutter/material.dart';

import 'config.dart';
import 'piece.dart' as plib;

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

const textStyle = TextStyle(
  color: Colors.pinkAccent,
  decoration: TextDecoration.none,
  fontSize: 10,
  fontWeight: FontWeight.normal,
);

class SquareNode extends StatefulWidget {
  final Color? color;
  final String name;
  plib.Piece? piece;
  final GlobalKey dragKey;
  final void Function() onChange;

  SquareNode({
    super.key,
    required this.color,
    required this.name,
    this.piece,
    required this.dragKey,
    required this.onChange,
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
              Text(
                widget.name,
                style: textStyle,
              ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 0.0, color: Colors.black26),
            color: widget.color,
          ),
        );
      },
      onAccept: (plib.Piece piece) {
        print(piece.role);
        setState(() {
          widget.piece = piece;
        });
      },
    );
  }

  Widget _buildPieceNode() {
    return Container(
      child: Column(
        children: [
          Text(
            widget.name,
            style: textStyle,
          ),
          Draggable<plib.Piece>(
            data: widget.piece,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            maxSimultaneousDrags: 1,
            onDragCompleted: () {
              setState(() {
                widget.piece = null;
              });
              widget.onChange();
            },
            feedback: DraggingPiece(
              dragKey: widget.dragKey,
              piece: widget.piece,
            ),
            childWhenDragging: Text(' '),
            child: Center(
              child: Text(
                '${widget.piece?.name}',
                style: TextStyle(
                  color: pieceColors[widget.piece?.color],
                  decoration: TextDecoration.none,
                  fontSize: 24,
                ),
              ),
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
}

class DraggingPiece extends StatelessWidget {
  final GlobalKey dragKey;
  final plib.Piece? piece;

  const DraggingPiece({
    super.key,
    required this.dragKey,
    required this.piece,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${piece?.name}',
      style: TextStyle(
        color: pieceColors[piece?.color],
        decoration: TextDecoration.none,
        fontSize: 24,
      ),
    );
  }
}
