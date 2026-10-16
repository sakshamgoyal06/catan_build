import 'package:hexwild_rules/hexwild_rules.dart';

import 'lobby_state.dart';

export 'lobby_state.dart';

/// In-browser demo lobby (no LAN host — browsers cannot accept peer WebSockets).
class LanHostService {
  LanHostService({this.port = 8765});

  final int port;
  LobbyState? _state;
  LobbyChanged? onLobbyChanged;

  bool get supportsLanHosting => false;

  LobbyState? get state => _state;

  Future<LobbyState> start({
    required String hostAddress,
    required String hostDisplayName,
  }) async {
    await stop();
    final hostId = 'demo-host';
    _state = LobbyState(
      roomCode: 'DEMO',
      hostAddress: hostAddress,
      port: port,
      isDemo: true,
      players: [
        LobbyPlayer(
          id: hostId,
          displayName: hostDisplayName,
          color: PlayerColor.crimson,
          ready: true,
        ),
      ],
    );
    onLobbyChanged?.call(_state!);
    return _state!;
  }

  Future<void> stop() async {
    _state = null;
  }

  void startGameIfReady() {
    if (_state == null) return;
    final board = generateRandomBoard();
    _state = LobbyState(
      roomCode: _state!.roomCode,
      hostAddress: _state!.hostAddress,
      port: _state!.port,
      players: _state!.players,
      phase: GamePhase.setupOutpostFirst,
      board: board,
      isDemo: true,
    );
    onLobbyChanged?.call(_state!);
  }
}
