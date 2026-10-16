import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import 'host_lobby_screen.dart';
import 'join_lobby_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HexwildLexicon.gameTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kIsWeb
                    ? 'Install this app on your home screen — it updates automatically when GitHub deploys.'
                    : 'Claim the frontier with friends nearby — same Wi‑Fi, no account.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                  height: 1.4,
                ),
              ),
              if (kIsWeb) ...[
                const SizedBox(height: 12),
                const _InstallHint(),
              ],
              const Spacer(),
              _PrimaryAction(
                label: kIsWeb ? 'Try demo table' : 'Host nearby table',
                subtitle: kIsWeb
                    ? 'Random board preview on this device'
                    : 'Start a lobby on this device',
                icon: Icons.wifi_tethering_rounded,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const HostLobbyScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _PrimaryAction(
                label: 'Join nearby table',
                subtitle: kIsWeb
                    ? 'Connect to a native host on your Wi‑Fi'
                    : 'Enter host IP and room code',
                icon: Icons.join_inner_rounded,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const JoinLobbyScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                kIsWeb
                    ? 'Native Android/iOS builds support full nearby hosting.'
                    : 'Online play comes in phase 2 — nearby LAN first.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstallHint extends StatelessWidget {
  const _InstallHint();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.install_mobile_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'iPhone: Share → Add to Home Screen. '
                'Android: Menu → Install app (or Add to Home screen). '
                'Reopen after updates to load the latest version.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.45,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.55),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
