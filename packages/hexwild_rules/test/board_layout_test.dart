import 'dart:math';

import 'package:hexwild_rules/hexwild_rules.dart';
import 'package:test/test.dart';

void main() {
  test('standard island has 19 hexes', () {
    expect(standardIslandCoords.length, 19);
  });

  test('random board assigns 18 production tokens', () {
    final board = generateRandomBoard(random: Random(42));
    final withTokens = board.tiles.where((t) => t.productionDie > 0).length;
    expect(withTokens, 18);
    expect(
      board.tiles.where((t) => t.kind == TerrainKind.badlands).length,
      1,
    );
  });
}
