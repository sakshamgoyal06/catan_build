enum GamePhase {
  waitingForPlayers,
  setupOutpostFirst,
  setupTrailFirst,
  setupOutpostSecond,
  setupTrailSecond,
  activeTurn,
  finished,
}

extension GamePhaseDisplay on GamePhase {
  String get label => switch (this) {
        GamePhase.waitingForPlayers => 'Waiting for explorers',
        GamePhase.setupOutpostFirst => 'Place first outpost',
        GamePhase.setupTrailFirst => 'Place first trail',
        GamePhase.setupOutpostSecond => 'Place second outpost',
        GamePhase.setupTrailSecond => 'Place second trail',
        GamePhase.activeTurn => 'In play',
        GamePhase.finished => 'Finished',
      };
}
