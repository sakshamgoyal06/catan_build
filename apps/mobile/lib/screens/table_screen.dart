import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import '../nearby/lobby_state.dart';
import '../navigation/open_demo_table.dart';
import '../widgets/app_background.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(lobby.isDemo ? 'Demo expedition' : 'Room ${lobby.roomCode}'),
        actions: [
          if (lobby.isDemo)
            TextButton(
              onPressed: () => openDemoTable(context),
              child: const Text('New map'),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Chip(
                label: Text(lobby.phase.label),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  'Pinch to explore the island · ${lobby.players.length} explorer(s)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.55),
                      ),
                ),
              ),
              Expanded(child: HexBoardView(board: board)),
              _ActionTray(phase: lobby.phase),
            ],
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF141B24).withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            phase.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Roll, trade, and build arrive next — demo map and lobby are live.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.58),
                ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _TrayButton(label: 'Roll', icon: Icons.casino_outlined),
              _TrayButton(label: 'Build', icon: Icons.construction_outlined),
              _TrayButton(label: 'Trade', icon: Icons.swap_horiz_rounded),
              _TrayButton(
                label: 'Fortune',
                icon: Icons.style_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrayButton extends StatelessWidget {
  const _TrayButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label — coming in the next update'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 4),
                  Text(label, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
