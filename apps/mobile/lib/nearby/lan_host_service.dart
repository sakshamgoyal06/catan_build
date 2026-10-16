import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hexwild_rules/hexwild_rules.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  });

  final String roomCode;
  final String hostAddress;
  final int port;
  final List<LobbyPlayer> players;
  final GamePhase phase;
  final BoardLayout? board;

  Map<String, dynamic> toJson() => {
        'roomCode': roomCode,
        'hostAddress': hostAddress,
        'port': port,
        'players': players.map((p) => p.toJson()).toList(),
        'phase': phase.name,
        if (board != null) 'board': board!.toJson(),
      };
}

/// Host-authoritative LAN session for nearby MVP (WebSocket over local Wi‑Fi).
class LanHostService {
  LanHostService({this.port = 8765});

  final int port;
  HttpServer? _server;
  final _clients = <WebSocketChannel>[];
  final _players = <String, LobbyPlayer>{};
  LobbyState? _state;
  LobbyChanged? onLobbyChanged;

  LobbyState? get state => _state;

  Future<LobbyState> start({
    required String hostAddress,
    required String hostDisplayName,
  }) async {
    await stop();
    final roomCode = _generateRoomCode();
    final hostId = 'host-${DateTime.now().millisecondsSinceEpoch}';
    _players.clear();
    _players[hostId] = LobbyPlayer(
      id: hostId,
      displayName: hostDisplayName,
      color: PlayerColor.crimson,
      ready: true,
    );

    _state = LobbyState(
      roomCode: roomCode,
      hostAddress: hostAddress,
      port: port,
      players: _players.values.toList(),
    );

    final handler = webSocketHandler((WebSocketChannel channel) {
      _clients.add(channel);
      channel.stream.listen(
        (data) => _handleClientMessage(channel, data),
        onDone: () => _clients.remove(channel),
      );
    });

    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
    _broadcastLobby();
    return _state!;
  }

  Future<void> stop() async {
    for (final c in _clients) {
      await c.sink.close();
    }
    _clients.clear();
    await _server?.close(force: true);
    _server = null;
  }

  void _handleClientMessage(WebSocketChannel channel, dynamic data) {
    try {
      final json = jsonDecode(data as String) as Map<String, dynamic>;
      final message = GameMessage.fromJson(json);
      switch (message.type) {
        case GameMessageType.hello:
          _registerGuest(channel, message.payload);
        case GameMessageType.startGame:
          startGameIfReady();
        case GameMessageType.welcome:
        case GameMessageType.lobbyUpdate:
        case GameMessageType.gameSnapshot:
        case GameMessageType.error:
          break;
      }
    } catch (_) {
      _send(
        channel,
        GameMessage(
          type: GameMessageType.error,
          payload: {'message': 'Invalid message'},
        ),
      );
    }
  }

  void _registerGuest(WebSocketChannel channel, Map<String, dynamic> payload) {
    final name = (payload['displayName'] as String?)?.trim();
    if (name == null || name.isEmpty) {
      _send(
        channel,
        GameMessage(
          type: GameMessageType.error,
          payload: {'message': 'Display name required'},
        ),
      );
      return;
    }

    if (_players.length >= 4) {
      _send(
        channel,
        GameMessage(
          type: GameMessageType.error,
          payload: {'message': 'Lobby is full'},
        ),
      );
      return;
    }

    final id = 'guest-${DateTime.now().microsecondsSinceEpoch}';
    final color = PlayerColor.values[_players.length % PlayerColor.values.length];
    _players[id] = LobbyPlayer(
      id: id,
      displayName: name,
      color: color,
    );

    _refreshStatePlayers();
    _send(
      channel,
      GameMessage(
        type: GameMessageType.welcome,
        payload: {'playerId': id, 'lobby': _state!.toJson()},
      ),
    );
    _broadcastLobby();
  }

  void startGameIfReady() {
    if (_state == null || _players.length < 3) return;
    final board = generateRandomBoard();
    _state = LobbyState(
      roomCode: _state!.roomCode,
      hostAddress: _state!.hostAddress,
      port: _state!.port,
      players: _state!.players,
      phase: GamePhase.setupOutpostFirst,
      board: board,
    );
    _broadcast(
      GameMessage(
        type: GameMessageType.startGame,
        payload: {'lobby': _state!.toJson()},
      ),
    );
    onLobbyChanged?.call(_state!);
  }

  void _refreshStatePlayers() {
    _state = LobbyState(
      roomCode: _state!.roomCode,
      hostAddress: _state!.hostAddress,
      port: _state!.port,
      players: _players.values.toList(),
      phase: _state!.phase,
      board: _state!.board,
    );
  }

  void _broadcastLobby() {
    onLobbyChanged?.call(_state!);
    _broadcast(
      GameMessage(
        type: GameMessageType.lobbyUpdate,
        payload: {'lobby': _state!.toJson()},
      ),
    );
  }

  void _broadcast(GameMessage message) {
    for (final client in List<WebSocketChannel>.from(_clients)) {
      _send(client, message);
    }
  }

  void _send(WebSocketChannel channel, GameMessage message) {
    channel.sink.add(jsonEncode(message.toJson()));
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final now = DateTime.now().millisecondsSinceEpoch;
    return List.generate(6, (i) => chars[(now + i * 17) % chars.length]).join();
  }
}
