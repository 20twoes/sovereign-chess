import 'package:flutter/material.dart';

import 'config.dart';
import 'types.dart';

class Board extends StatelessWidget {
  final GlobalKey _draggableKey = GlobalKey();

  Board({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: files.length,
      children: _generateSquares(),
    );
  }

  List<Widget> _generateSquares() {
    List<Widget> list = [];
    final getColor = (r, c) {
      if (c % 2 != 0) {
        return r % 2 == 0 ? 'dark' : 'light';
      } else {
        return r % 2 == 0 ? 'light' : 'dark';
      }
    };

    for (final (rankIndex, rank) in ranks.reversed.indexed) {
      for (var (fileIndex, file) in files.indexed) {
        final name = '${file}${rank}';
        Piece? piece = pieces[name];

        list.add(SquareNode(
          name: name,
          color: getColor(rankIndex, fileIndex),
          piece: piece,
          dragKey: _draggableKey,
        ));
      }
    }
    return list;
  }
}

const textStyle = TextStyle(
  color: Colors.pinkAccent,
  decoration: TextDecoration.none,
  fontSize: 10,
  fontWeight: FontWeight.normal,
);

class SquareNode extends StatefulWidget {
  final String color;
  final String name;
  Piece? piece;
  final GlobalKey dragKey;

  SquareNode({
    super.key,
    required this.color,
    required this.name,
    this.piece,
    required this.dragKey,
  });

  @override
  State<SquareNode> createState() => _SquareNodeState();
}

class _SquareNodeState extends State<SquareNode> {
  @override
  Widget build(BuildContext context) {
    Color? bgColor = getSquareColor(widget.name);
    if (bgColor == null) {
      bgColor = widget.color == 'dark' ? colors.darkSquare : colors.lightSquare;
    }

    return widget.piece == null ? _buildSquareNode(bgColor) : _buildPieceNode(bgColor);
  }

  Widget _buildSquareNode(Color? bgColor) {
    return DragTarget<Piece>(
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
            color: bgColor,
          ),
        );
      },
      onAccept: (Piece piece) {
        print(piece.role);
        setState(() {
          widget.piece = piece;
        });
      },
    );
  }

  Widget _buildPieceNode(Color? bgColor) {
    return Container(
      child: Column(
        children: [
          Text(
            widget.name,
            style: textStyle,
          ),
          Draggable<Piece>(
            data: widget.piece,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            maxSimultaneousDrags: 1,
            onDragCompleted: () {
              setState(() {
                widget.piece = null;
              });
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
                ),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0.0, color: Colors.black26),
        color: bgColor,
      ),
    );
  }
}

class DraggingPiece extends StatelessWidget {
  final GlobalKey dragKey;
  final Piece? piece;

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
      ),
    );
  }
}
