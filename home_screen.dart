import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GULLY CRICKET',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SizedBox(height: 12),
            const Text('YOUR STREET. YOUR GAME.',
                style: TextStyle(color: Color(0xFFB8F34A),
                    letterSpacing: 2, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Ready for a match?',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 22),
            _MainAction(
              icon: Icons.sports_cricket,
              title: 'Start New Match',
              subtitle: 'Set teams, overs, toss and start scoring',
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SetupPlaceholder())),
            ),
            const SizedBox(height: 12),
            _MainAction(
              icon: Icons.groups_2_outlined,
              title: 'Teams & Players',
              subtitle: 'Create squads and add players by name',
              onTap: () => _showInfo(context, 'Team management is next in the build sequence.'),
            ),
            const SizedBox(height: 12),
            _MainAction(
              icon: Icons.history,
              title: 'Match History',
              subtitle: 'Open saved matches and scorecards',
              onTap: () => _showInfo(context, 'Match history will read from the on-device database.'),
            ),
            const SizedBox(height: 12),
            _MainAction(
              icon: Icons.emoji_events_outlined,
              title: 'Awards & Records',
              subtitle: 'MVP, best batter, best bowler and achievements',
              onTap: () => _showInfo(context, 'Awards are calculated from match statistics and confirmed by the scorer.'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF142333),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(children: [
                Icon(Icons.offline_bolt, color: Color(0xFFB8F34A)),
                SizedBox(width: 12),
                Expanded(child: Text(
                  'No account. No internet needed. Your match data stays on this device.',
                  style: TextStyle(color: Colors.white70),
                )),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  static void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MainAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MainAction({required this.icon, required this.title,
    required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFF142333),
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFB8F34A).withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFFB8F34A)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(
                color: Colors.white60, fontSize: 12)),
            ])),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ]),
      ),
    ),
  );
}

class SetupPlaceholder extends StatelessWidget {
  const SetupPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('New Match')),
    body: const Center(child: Text('Match setup screen — next implementation step')),
  );
}
