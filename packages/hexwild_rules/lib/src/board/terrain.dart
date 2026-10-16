import '../game/resource.dart';
import 'hex_coord.dart';

enum TerrainKind {
  timber,
  clay,
  wool,
  grain,
  iron,
  badlands,
}

extension TerrainKindDisplay on TerrainKind {
  String get label => switch (this) {
        TerrainKind.timber => 'Timberlands',
        TerrainKind.clay => 'Clay flats',
        TerrainKind.wool => 'High pastures',
        TerrainKind.grain => 'Grain fields',
        TerrainKind.iron => 'Iron hills',
        TerrainKind.badlands => 'Badlands',
      };

  Resource? get produces => switch (this) {
        TerrainKind.timber => Resource.timber,
        TerrainKind.clay => Resource.clay,
        TerrainKind.wool => Resource.wool,
        TerrainKind.grain => Resource.grain,
        TerrainKind.iron => Resource.iron,
        TerrainKind.badlands => null,
      };
}

class TerrainTile {
  const TerrainTile({
    required this.coord,
    required this.kind,
    this.productionDie = 0,
  });

  final HexCoord coord;
  final TerrainKind kind;

  /// Number token (2–12, excluding 7). Zero on badlands.
  final int productionDie;

  bool get producesResources => kind.produces != null && productionDie > 0;
}
