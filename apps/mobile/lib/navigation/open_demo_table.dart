import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import '../nearby/lobby_state.dart';
import '../screens/table_screen.dart';

/// Opens a solo demo board (one tap — no lobby WebSocket).
void openDemoTable(BuildContext context, {String playerName = 'Explorer'}) {
  final board = generateRandomBoard();
  final lobby = LobbyState(
    roomCode: 'DEMO',
    hostAddress: 'local',
    port: 0,
    isDemo: true,
    phase: GamePhase.setupOutpostFirst,
    board: board,
    players: [
      LobbyPlayer(
        id: 'demo',
        displayName: playerName,
        color: PlayerColor.crimson,
        ready: true,
      ),
    ],
  );
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => TableScreen(lobby: lobby),
    ),
  );
}
