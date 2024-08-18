import 'dart:async' show Timer;

import 'package:flutter/material.dart';

import '../game.dart';
import '../player.dart';
import '../position.dart';

class StatusBar extends StatelessWidget {
  final Game game;
  final Player player;
  final Position position;

  StatusBar({required this.game, required this.player})
      : position = game.currentPosition();

  @override
  Widget build(BuildContext build) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _Name(),
        _Armies(),
        _Clock(),
      ],
    );
  }

  Widget _Name() {
    var label = switch (player) {
      Player.p1 => "Player 1: ${game.player1}",
      Player.p2 => "Player 2: ${game.player2}",
    };

    if (game.currentPlayer == player) {
      label += " - You";
    }

    return Text(label);
  }

  Widget _Armies() {
    return Column(
      children: <Widget>[
        Text("Own: ${position.ownedArmy(player)}"),
        Text("Control: ${position.controlledArmies(player)}"),
      ],
    );
  }

  Widget _Clock() {
    if (position.activePlayer == player) {
      return Clock(startTime: game.timeSinceLastMove());
    } else {
      return Text('00:00');
    }
  }
}

class Clock extends StatefulWidget {
  final DateTime startTime;

  Clock({super.key, required this.startTime});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _displayTime = "";
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();

    const interval = Duration(seconds: 1);
    _everySecond = Timer.periodic(interval, (Timer t) {
      final duration = DateTime.now().difference(widget.startTime);
      setState(() {
        _displayTime = "${duration.toString()}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayTime);
  }

  @override
  void dispose() {
    super.dispose();
    _everySecond.cancel();
  }
}
