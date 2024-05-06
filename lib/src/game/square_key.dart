// Square name: File + Rank
typedef Key = String;

const rowLength = 16;

enum File {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h,
  i,
  j,
  k,
  l,
  m,
  n,
  o,
  p,
}

final files = File.values.map((f) => f.name);

final ranks = List<String>.generate(
  16,
  (int index) => '${index + 1}',
  growable: false,
);

List<String> buildKeys() {
  var result = <String>[];
  for (final file in files) {
    final row = ranks.map((r) => file + r);
    result = [...result, ...row];
  }
  return result;
}

final allKeys = buildKeys();

Key posToKey(int col, int row) => allKeys[rowLength * col + row];
