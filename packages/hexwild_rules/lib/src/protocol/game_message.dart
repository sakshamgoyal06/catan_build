/// JSON messages exchanged over nearby LAN WebSocket (host-authoritative).
enum GameMessageType {
  hello,
  welcome,
  lobbyUpdate,
  startGame,
  gameSnapshot,
  error,
}

class GameMessage {
  GameMessage({required this.type, this.payload = const {}});

  final GameMessageType type;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'payload': payload,
      };

  static GameMessage fromJson(Map<String, dynamic> json) {
    return GameMessage(
      type: GameMessageType.values.byName(json['type'] as String),
      payload: Map<String, dynamic>.from(json['payload'] as Map? ?? {}),
    );
  }

  String get typeLabel => type.name;
}
