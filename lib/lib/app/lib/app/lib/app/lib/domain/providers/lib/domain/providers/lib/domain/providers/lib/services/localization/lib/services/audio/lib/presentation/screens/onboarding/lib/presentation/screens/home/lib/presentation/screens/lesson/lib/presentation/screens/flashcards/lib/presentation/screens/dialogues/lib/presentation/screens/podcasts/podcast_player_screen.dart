import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/audio/hybrid_audio_service.dart';
import '../../../domain/providers/progress_provider.dart';

class PodcastPlayerScreen extends ConsumerStatefulWidget {
  final String podcastId;
  final String userId;

  const PodcastPlayerScreen({
    super.key,
    required this.podcastId,
    required this.userId,
  });

  @override
  ConsumerState<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends ConsumerState<PodcastPlayerScreen> {
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;

  final String _podcastTitle = 'Episode 1: Everyday English Habits';
  final String _podcastDescription = 'Discover simple daily routines that can boost your English fluency in just 15 minutes a day.';
  final String _podcastContent = 
      "Welcome to PolyglotMaster Podcast! Today we will discuss three key habits to master English quickly. "
      "First, immerse yourself in daily listening. Even ten minutes of authentic audio builds natural rhythm. "
      "Second, speak out loud every single day. Repeat phrases, shadow native speakers, and build your confidence. "
      "Third, never be afraid of making mistakes. Consistency is the true secret of language learning success.";

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(hybridAudioServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.podcasts, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _podcastTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _podcastDescription,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _podcastContent,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionChip(
                  label: Text('${_playbackSpeed}x Speed'),
                  onPressed: () {
                    setState(() {
                      if (_playbackSpeed == 1.0) {
                        _playbackSpeed = 1.25;
                      } else if (_playbackSpeed == 1.25) {
                        _playbackSpeed = 0.75;
                      } else {
                        _playbackSpeed = 1.0;
                      }
                    });
                    audio.setSpeed(_playbackSpeed);
                  },
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF2563EB),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        audio.pause();
                        setState(() => _isPlaying = false);
                      } else {
                        audio.speakText(_podcastContent);
                        setState(() => _isPlaying = true);
                        ref.read(userXpProvider.notifier).state += 20;
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
