/// Axial hex coordinates (q, r). Cube constraint: q + r + s = 0 with s = -q - r.
class HexCoord {
  const HexCoord(this.q, this.r);

  final int q;
  final int r;

  int get s => -q - r;

  @override
  bool operator ==(Object other) =>
      other is HexCoord && other.q == q && other.r == r;

  @override
  int get hashCode => Object.hash(q, r);

  @override
  String toString() => '($q,$r)';

  HexCoord neighbor(HexDirection direction) {
    return switch (direction) {
      HexDirection.east => HexCoord(q + 1, r),
      HexDirection.northEast => HexCoord(q + 1, r - 1),
      HexDirection.northWest => HexCoord(q, r - 1),
      HexDirection.west => HexCoord(q - 1, r),
      HexDirection.southWest => HexCoord(q - 1, r + 1),
      HexDirection.southEast => HexCoord(q, r + 1),
    };
  }

  Iterable<HexCoord> get neighbors sync* {
    for (final d in HexDirection.values) {
      yield neighbor(d);
    }
  }

  Map<String, int> toJson() => {'q': q, 'r': r};

  static HexCoord fromJson(Map<String, dynamic> json) =>
      HexCoord(json['q'] as int, json['r'] as int);
}

enum HexDirection {
  east,
  northEast,
  northWest,
  west,
  southWest,
  southEast,
}
