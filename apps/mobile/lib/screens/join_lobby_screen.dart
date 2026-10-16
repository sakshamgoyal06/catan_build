import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import '../nearby/lan_client_service.dart';
import 'table_screen.dart';

class JoinLobbyScreen extends StatefulWidget {
  const JoinLobbyScreen({super.key});

  @override
  State<JoinLobbyScreen> createState() => _JoinLobbyScreenState();
}

class _JoinLobbyScreenState extends State<JoinLobbyScreen> {
  final _client = LanClientService();
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '8765');
  final _nameController = TextEditingController(text: 'Explorer');
  String? _status;
  String? _error;
  bool _connecting = false;

  @override
  void dispose() {
    _client.disconnect();
    _hostController.dispose();
    _portController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 8765;
    final name = _nameController.text.trim();

    if (host.isEmpty || name.isEmpty) {
      setState(() => _error = 'Host IP and name are required.');
      return;
    }

    setState(() {
      _connecting = true;
      _error = null;
      _status = 'Connecting…';
    });

    try {
      await _client.connect(
        host: host,
        port: port,
        displayName: name,
        onMessage: _onMessage,
      );
    } catch (e) {
      setState(() {
        _error = 'Connection failed: $e';
        _connecting = false;
      });
    }
  }

  void _onMessage(GameMessage message) {
    switch (message.type) {
      case GameMessageType.welcome:
      case GameMessageType.lobbyUpdate:
        setState(() {
          _connecting = false;
          _status = 'In lobby — waiting for host to start';
        });
      case GameMessageType.startGame:
        final lobbyJson = message.payload['lobby'] as Map<String, dynamic>?;
        if (lobbyJson != null && mounted) {
          final boardJson = lobbyJson['board'] as Map<String, dynamic>?;
          if (boardJson != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => TableScreen.fromLobbyJson(lobbyJson),
              ),
            );
          }
        }
      case GameMessageType.error:
        setState(() {
          _error = message.payload['message'] as String? ?? 'Error';
          _connecting = false;
        });
      case GameMessageType.hello:
      case GameMessageType.gameSnapshot:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join nearby table')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (kIsWeb)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    'The installed web app is served over HTTPS. Connecting to a '
                    'home Wi‑Fi host (ws://…) may be blocked in some browsers. '
                    'Use the native app to host; try Join here if your browser allows local network access.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            if (kIsWeb) const SizedBox(height: 12),
            TextField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Host IP address',
                hintText: '192.168.1.12',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
            if (_status != null) ...[
              const SizedBox(height: 16),
              Text(_status!),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const Spacer(),
            FilledButton(
              onPressed: _connecting ? null : _connect,
              child: _connecting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Join lobby'),
            ),
          ],
        ),
      ),
    );
  }
}
