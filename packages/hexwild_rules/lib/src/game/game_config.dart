class GameConfig {
  const GameConfig({
    this.minPlayers = 3,
    this.maxPlayers = 4,
    this.victoryPointsToWin = 10,
  });

  final int minPlayers;
  final int maxPlayers;
  final int victoryPointsToWin;

  Map<String, dynamic> toJson() => {
        'minPlayers': minPlayers,
        'maxPlayers': maxPlayers,
        'victoryPointsToWin': victoryPointsToWin,
      };

  static GameConfig fromJson(Map<String, dynamic> json) => GameConfig(
        minPlayers: json['minPlayers'] as int? ?? 3,
        maxPlayers: json['maxPlayers'] as int? ?? 4,
        victoryPointsToWin: json['victoryPointsToWin'] as int? ?? 10,
      );
}
