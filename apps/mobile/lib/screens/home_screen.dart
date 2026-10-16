import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import '../navigation/open_demo_table.dart';
import '../widgets/app_background.dart';
import '../widgets/hero_hex_cluster.dart';
import 'join_lobby_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          HexwildLexicon.gameTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HeroHexCluster(),
                      const SizedBox(height: 8),
                      Text(
                        'Claim the frontier',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        kIsWeb
                            ? 'Play a demo board in one tap. Install to your home screen for an app-like experience.'
                            : 'Play with friends on the same Wi‑Fi — no account needed.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.68),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => openDemoTable(context),
                        icon: const Icon(Icons.hive_rounded),
                        label: const Text('Play demo board'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const JoinLobbyScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.groups_2_outlined),
                        label: const Text('Join nearby table'),
                      ),
                      if (kIsWeb) ...[
                        const SizedBox(height: 20),
                        const _InstallHint(),
                      ],
                      const SizedBox(height: 28),
                      _FeatureRow(
                        icon: Icons.map_outlined,
                        title: 'Living hex map',
                        subtitle: 'Pinch to zoom, rich terrain tiles',
                      ),
                      const SizedBox(height: 10),
                      _FeatureRow(
                        icon: Icons.wifi_rounded,
                        title: 'Nearby tables',
                        subtitle: 'Native app hosts; web joins when allowed',
                      ),
                    ],
                  ),
                ),
              );
            },
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
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.install_mobile_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Install: iPhone (Safari → Share → Add to Home Screen). '
                'Android (Chrome → Install app). After updates on GitHub, fully close and reopen the app.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
