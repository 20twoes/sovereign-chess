import 'package:flutter/material.dart';

import 'config.dart';
import 'types.dart';

class Board extends StatelessWidget {
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

    for (final (rank_index, rank) in ranks.reversed.indexed) {
      for (var (file_index, file) in files.indexed) {
        list.add(SquareWidget(
          name: '${file}${rank}',
          color: getColor(rank_index, file_index),
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

class SquareWidget extends StatelessWidget {
  final String color;
  final String name;

  const SquareWidget({
    super.key,
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    var bgColor = getSquareColor(name);
    if (bgColor == null) {
      bgColor = color == 'dark' ? colors.darkSquare : colors.lightSquare;
    }
    return Container(
      child: Text(
        name,
        style: textStyle,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0.0, color: Colors.black26),
        color: bgColor,
      ),
    );
  }
}
