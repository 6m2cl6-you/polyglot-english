import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/providers/localization_provider.dart';
import '../../../domain/providers/progress_provider.dart';

class HomeScreen extends ConsumerWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translateProvider);
    final xp = ref.watch(userXpProvider);
    final streak = ref.watch(userStreakProvider);
    final hearts = ref.watch(userHeartsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('app_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange),
              const SizedBox(width: 4),
              Text('$streak', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              const Icon(Icons.favorite, color: Colors.red),
              const SizedBox(width: 4),
              Text('$hearts', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 4),
              Text('$xp', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            color: const Color(0xFF2563EB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr('hello'),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('onboarding_title_1'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2563EB),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/lesson',
                        arguments: {'lessonId': 'lesson_1_1', 'userId': userId},
                      );
                    },
                    child: Text(tr('start')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            tr('practice'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context: context,
            icon: Icons.style,
            color: Colors.purple,
            title: tr('flashcards'),
            onTap: () => Navigator.pushNamed(
              context,
              '/flashcards',
              arguments: {'userId': userId, 'languageCode': 'en'},
            ),
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            context: context,
            icon: Icons.chat_bubble_outline,
            color: Colors.green,
            title: tr('dialogues'),
            onTap: () => Navigator.pushNamed(
              context,
              '/dialogue',
              arguments: {'dialogueId': 'dia_1', 'userId': userId},
            ),
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            context: context,
            icon: Icons.podcasts,
            color: Colors.orange,
            title: tr('podcasts'),
            onTap: () => Navigator.pushNamed(
              context,
              '/podcast',
              arguments: {'podcastId': 'pod_1', 'userId': userId},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
