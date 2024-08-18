enum Player {
  p1,
  p2,
}

Player charToPlayer(String ch) {
  return switch (ch) {
    '1' => Player.p1,
    '2' => Player.p2,
    _ => throw Exception('Invalid Player')
  };
}
