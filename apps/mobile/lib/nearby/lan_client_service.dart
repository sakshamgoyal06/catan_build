import 'dart:async';
import 'dart:convert';

import 'package:hexwild_rules/hexwild_rules.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef ClientMessageHandler = void Function(GameMessage message);

class LanClientService {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  Future<void> connect({
    required String host,
    required int port,
    required String displayName,
    required ClientMessageHandler onMessage,
  }) async {
    await disconnect();
    final uri = Uri.parse('ws://$host:$port');
    _channel = WebSocketChannel.connect(uri);
    _subscription = _channel!.stream.listen(
      (data) {
        final json = jsonDecode(data as String) as Map<String, dynamic>;
        onMessage(GameMessage.fromJson(json));
      },
      onError: (_) {
        onMessage(
          GameMessage(
            type: GameMessageType.error,
            payload: {'message': 'Connection lost'},
          ),
        );
      },
    );

    _send(
      GameMessage(
        type: GameMessageType.hello,
        payload: {'displayName': displayName},
      ),
    );
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    _subscription = null;
    _channel = null;
  }

  void requestStartGame() {
    _send(GameMessage(type: GameMessageType.startGame));
  }

  void _send(GameMessage message) {
    _channel?.sink.add(jsonEncode(message.toJson()));
  }
}
