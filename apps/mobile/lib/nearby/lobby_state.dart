import 'package:hexwild_rules/hexwild_rules.dart';

typedef LobbyChanged = void Function(LobbyState state);

class LobbyPlayer {
  LobbyPlayer({
    required this.id,
    required this.displayName,
    required this.color,
    this.ready = false,
  });

  final String id;
  final String displayName;
  final PlayerColor color;
  bool ready;

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'color': color.name,
        'ready': ready,
      };
}

class LobbyState {
  LobbyState({
    required this.roomCode,
    required this.hostAddress,
    required this.port,
    required this.players,
    this.phase = GamePhase.waitingForPlayers,
    this.board,
    this.isDemo = false,
  });

  final String roomCode;
  final String hostAddress;
  final int port;
  final List<LobbyPlayer> players;
  final GamePhase phase;
  final BoardLayout? board;

  /// Web demo lobby (no LAN host socket).
  final bool isDemo;

  Map<String, dynamic> toJson() => {
        'roomCode': roomCode,
        'hostAddress': hostAddress,
        'port': port,
        'players': players.map((p) => p.toJson()).toList(),
        'phase': phase.name,
        'isDemo': isDemo,
        if (board != null) 'board': board!.toJson(),
      };
}
