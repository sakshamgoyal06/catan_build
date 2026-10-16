import 'dart:math';

import '../game/game_config.dart';
import 'hex_coord.dart';
import 'terrain.dart';

/// Standard 19-hex island (3-4-5-4-3 rows), same topology as classic Catan.
const standardIslandCoords = [
  HexCoord(0, -2),
  HexCoord(1, -2),
  HexCoord(2, -2),
  HexCoord(-1, -1),
  HexCoord(0, -1),
  HexCoord(1, -1),
  HexCoord(2, -1),
  HexCoord(-2, 0),
  HexCoord(-1, 0),
  HexCoord(0, 0),
  HexCoord(1, 0),
  HexCoord(2, 0),
  HexCoord(-2, 1),
  HexCoord(-1, 1),
  HexCoord(0, 1),
  HexCoord(1, 1),
  HexCoord(-2, 2),
  HexCoord(-1, 2),
  HexCoord(0, 2),
];

/// Production tokens for base game (one of each except 7).
const standardProductionTokens = [
  2, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9, 10, 10, 11, 11, 12,
];

class BoardLayout {
  BoardLayout({required this.tiles, required this.raiderAt});

  final List<TerrainTile> tiles;
  final HexCoord raiderAt;

  Map<String, dynamic> toJson() => {
        'tiles': tiles
            .map(
              (t) => {
                'coord': t.coord.toJson(),
                'kind': t.kind.name,
                'productionDie': t.productionDie,
              },
            )
            .toList(),
        'raiderAt': raiderAt.toJson(),
      };

  static BoardLayout fromJson(Map<String, dynamic> json) {
    final rawTiles = json['tiles'] as List<dynamic>;
    return BoardLayout(
      tiles: rawTiles.map((raw) {
        final m = raw as Map<String, dynamic>;
        return TerrainTile(
          coord: HexCoord.fromJson(m['coord'] as Map<String, dynamic>),
          kind: TerrainKind.values.byName(m['kind'] as String),
          productionDie: m['productionDie'] as int,
        );
      }).toList(),
      raiderAt: HexCoord.fromJson(json['raiderAt'] as Map<String, dynamic>),
    );
  }
}

BoardLayout generateRandomBoard({
  GameConfig config = const GameConfig(),
  Random? random,
}) {
  final rng = random ?? Random();
  final terrains = <TerrainKind>[
    TerrainKind.timber,
    TerrainKind.timber,
    TerrainKind.timber,
    TerrainKind.timber,
    TerrainKind.clay,
    TerrainKind.clay,
    TerrainKind.clay,
    TerrainKind.wool,
    TerrainKind.wool,
    TerrainKind.wool,
    TerrainKind.wool,
    TerrainKind.grain,
    TerrainKind.grain,
    TerrainKind.grain,
    TerrainKind.grain,
    TerrainKind.iron,
    TerrainKind.iron,
    TerrainKind.iron,
    TerrainKind.badlands,
  ]..shuffle(rng);

  final tokens = List<int>.from(standardProductionTokens)..shuffle(rng);
  var tokenIndex = 0;

  final tiles = <TerrainTile>[];
  for (var i = 0; i < standardIslandCoords.length; i++) {
    final coord = standardIslandCoords[i];
    final kind = terrains[i];
    final die = kind == TerrainKind.badlands ? 0 : tokens[tokenIndex++];
    tiles.add(TerrainTile(coord: coord, kind: kind, productionDie: die));
  }

  final badlands = tiles.firstWhere((t) => t.kind == TerrainKind.badlands);
  return BoardLayout(tiles: tiles, raiderAt: badlands.coord);
}
