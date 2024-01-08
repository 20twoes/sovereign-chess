import 'square_key.dart';

typedef Pieces = Map<Key, Piece>;

enum Role {
  bishop,
  king,
  knight,
  pawn,
  queen,
  rook,
}

enum Color {
  ash,
  black,
  cyan,
  green,
  navy,
  orange,
  pink,
  red,
  slate,
  violet,
  white,
  yellow,
}

class Piece {
  final Color color;
  final Role role;

  Piece({required this.color, required this.role});

  String get name => role == Role.knight ? 'N' : role.name[0].toUpperCase();

  @override
  operator ==(o) => o is Piece && o.color == color && o.role == role;

  String toString() => '${color.name} ${role.name}'.toUpperCase();
}
