import 'piece.dart';
import 'player.dart';

class Position {
  final String boardFEN;
  final Map<Player, Color> _ownedArmies = {};
  late Map<Player, Set<Color>> _controlledArmies;
  final Player activePlayer;

  Position({required this.boardFEN, required this.activePlayer}) {
    _controlledArmies = {
      Player.p1: <Color>{},
      Player.p2: <Color>{},
    };
  }

  void addOwnedArmy(Player player, Color? army) {
    if (army != null) {
      _ownedArmies[player] = army;
    }
  }

  void addControlledArmy(Player player, Color? army) {
    if (army != null) {
      _controlledArmies[player]?.add(army);
    }
  }

  Color? ownedArmy(Player player) {
    return _ownedArmies[player];
  }

  Set<Color> controlledArmies(Player player) {
    return _controlledArmies[player] ?? <Color>{};
  }
}
