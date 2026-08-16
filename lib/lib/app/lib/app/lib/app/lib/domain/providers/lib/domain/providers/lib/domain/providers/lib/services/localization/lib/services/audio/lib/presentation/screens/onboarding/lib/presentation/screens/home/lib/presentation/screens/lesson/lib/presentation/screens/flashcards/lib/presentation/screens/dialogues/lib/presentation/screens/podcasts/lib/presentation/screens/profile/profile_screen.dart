import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/providers/progress_provider.dart';
import '../../../domain/providers/localization_provider.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translateProvider);
    final xp = ref.watch(userXpProvider);
    final streak = ref.watch(userStreakProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF2563EB),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Polyglot Learner',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('XP', '$xp', Icons.stars, Colors.amber),
                _buildStatCard('Streak', '$streak Days', Icons.local_fire_department, Colors.orange),
              ],
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.workspace_premium, color: Color(0xFF2563EB)),
              title: Text(tr('achievements')),
              trailing: const Text('Level 1 Explorer', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text('Native Language'),
              trailing: const Text('العربية', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
