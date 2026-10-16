enum PlayerColor {
  crimson,
  cobalt,
  amber,
  jade,
}

extension PlayerColorDisplay on PlayerColor {
  String get label => switch (this) {
        PlayerColor.crimson => 'Crimson',
        PlayerColor.cobalt => 'Cobalt',
        PlayerColor.amber => 'Amber',
        PlayerColor.jade => 'Jade',
      };
}
