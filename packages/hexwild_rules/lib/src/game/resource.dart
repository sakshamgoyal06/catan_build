enum Resource {
  timber,
  clay,
  wool,
  grain,
  iron,
}

extension ResourceDisplay on Resource {
  String get label => switch (this) {
        Resource.timber => 'Timber',
        Resource.clay => 'Clay',
        Resource.wool => 'Wool',
        Resource.grain => 'Grain',
        Resource.iron => 'Iron',
      };

  /// Standard starting bank supply per resource (base game).
  int get bankStartingCount => 19;
}
