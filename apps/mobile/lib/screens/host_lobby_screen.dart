import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import '../nearby/lan_host_service.dart';
import '../nearby/local_address.dart';
import 'table_screen.dart';

class HostLobbyScreen extends StatefulWidget {
  const HostLobbyScreen({super.key});

  @override
  State<HostLobbyScreen> createState() => _HostLobbyScreenState();
}

class _HostLobbyScreenState extends State<HostLobbyScreen> {
  final _host = LanHostService();
  final _nameController = TextEditingController(text: 'Host');
  LobbyState? _lobby;
  String? _error;
  bool _starting = false;

  @override
  void dispose() {
    _host.stop();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createLobby() async {
    setState(() {
      _error = null;
      _starting = true;
    });
    try {
      final address = await resolveLanIPv4();
      _host.onLobbyChanged = (state) {
        if (mounted) setState(() => _lobby = state);
      };
      final lobby = await _host.start(
        hostAddress: address,
        hostDisplayName: _nameController.text.trim().isEmpty
            ? 'Host'
            : _nameController.text.trim(),
      );
      if (mounted) setState(() => _lobby = lobby);
    } catch (e) {
      setState(() => _error = 'Could not start host: $e');
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  void _beginGame() {
    _host.startGameIfReady();
    final lobby = _host.state;
    if (lobby?.board != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => TableScreen(lobby: lobby!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host nearby table')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _lobby == null ? _buildSetup() : _buildLobby(context),
      ),
    );
  }

  Widget _buildSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Your name',
            border: OutlineInputBorder(),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const Spacer(),
        FilledButton(
          onPressed: _starting ? null : _createLobby,
          child: _starting
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Open lobby'),
        ),
      ],
    );
  }

  Widget _buildLobby(BuildContext context) {
    final lobby = _lobby!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Room code', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(
                  lobby.roomCode,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text('Host address: ${lobby.hostAddress}:${lobby.port}'),
                const SizedBox(height: 4),
                Text(
                  'Friends on the same Wi‑Fi can join with this IP.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Explorers (${lobby.players.length}/4)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: lobby.players.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final p = lobby.players[index];
              return ListTile(
                tileColor: Theme.of(context).cardTheme.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(p.displayName),
                subtitle: Text(p.color.label),
                trailing: Icon(
                  p.ready ? Icons.check_circle : Icons.hourglass_empty,
                  color: p.ready ? Colors.tealAccent : null,
                ),
              );
            },
          ),
        ),
        FilledButton(
          onPressed: lobby.players.length >= 3 ? _beginGame : null,
          child: Text(
            lobby.players.length >= 3
                ? 'Begin expedition'
                : 'Need ${3 - lobby.players.length} more explorer(s)',
          ),
        ),
      ],
    );
  }
}
