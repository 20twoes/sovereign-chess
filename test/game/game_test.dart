import 'package:test/test.dart';

import 'package:sovereign_chess/src/game/game.dart';

void main() {
  group('Move', () {
    test('.fromJson should work', () {
      final json = {
        'fen': '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16 1 - - - - 0',
        "ts": {
          r"$date": {
            r"$numberLong": "1724000795653",
          },
        },
      };

      final result = Move.fromJson(json);

      expect(result.fen, '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16');
      expect(result.rawFEN,
          '16/16/16/16/16/16/16/16/16/16/16/16/16/16/16/16 1 - - - - 0');
      expect(result.timestamp,
          DateTime.fromMillisecondsSinceEpoch(1724000795653, isUtc: true));
    });
  });
}
