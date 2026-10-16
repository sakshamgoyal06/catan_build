import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import '../nearby/lobby_state.dart';
import '../widgets/hex_board_painter.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key, required this.lobby});

  factory TableScreen.fromLobbyJson(Map<String, dynamic> json) {
    final boardJson = json['board'] as Map<String, dynamic>;
    return TableScreen(
      lobby: LobbyState(
        roomCode: json['roomCode'] as String,
        hostAddress: json['hostAddress'] as String,
        port: json['port'] as int,
        players: (json['players'] as List<dynamic>).map((p) {
          final m = p as Map<String, dynamic>;
          return LobbyPlayer(
            id: m['id'] as String,
            displayName: m['displayName'] as String,
            color: PlayerColor.values.byName(m['color'] as String),
            ready: m['ready'] as bool? ?? false,
          );
        }).toList(),
        phase: GamePhase.values.byName(json['phase'] as String),
        board: BoardLayout.fromJson(boardJson),
        isDemo: json['isDemo'] as bool? ?? false,
      ),
    );
  }

  final LobbyState lobby;

  @override
  Widget build(BuildContext context) {
    final board = lobby.board!;
    return Scaffold(
      appBar: AppBar(
        title: Text(lobby.isDemo ? 'Demo board' : 'Room ${lobby.roomCode}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                lobby.phase.label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: HexBoardView(board: board)),
          _ActionTray(phase: lobby.phase),
        ],
      ),
    );
  }
}

class _ActionTray extends StatelessWidget {
  const _ActionTray({required this.phase});

  final GamePhase phase;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Setup phase preview',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Turn rules and building arrive in the next sprint — board generation and nearby lobby are live.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _TrayButton(label: 'Roll', icon: Icons.casino_outlined, enabled: false),
              _TrayButton(label: 'Build', icon: Icons.construction_outlined, enabled: false),
              _TrayButton(label: 'Trade', icon: Icons.swap_horiz_rounded, enabled: false),
              _TrayButton(
                label: 'Fortune',
                icon: Icons.style_outlined,
                enabled: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrayButton extends StatelessWidget {
  const _TrayButton({
    required this.label,
    required this.icon,
    required this.enabled,
  });

  final String label;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton.tonal(
          onPressed: enabled ? () {} : null,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
