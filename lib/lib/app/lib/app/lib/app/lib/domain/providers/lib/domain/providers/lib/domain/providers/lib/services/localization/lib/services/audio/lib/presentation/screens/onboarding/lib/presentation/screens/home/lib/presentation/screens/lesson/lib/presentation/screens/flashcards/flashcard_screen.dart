import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/audio/hybrid_audio_service.dart';
import '../../../domain/providers/progress_provider.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  final String userId;
  final String languageCode;

  const FlashcardScreen({
    super.key,
    required this.userId,
    required this.languageCode,
  });

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  int _currentIndex = 0;
  bool _showTranslation = false;

  final List<Map<String, String>> _flashcards = [
    {
      'word': 'Hello',
      'translation': 'مرحباً / سلام',
      'phonetic': '/həˈləʊ/',
      'example': 'Hello, how are you?',
    },
    {
      'word': 'Thank you',
      'translation': 'شكراً لك',
      'phonetic': '/θæŋk juː/',
      'example': 'Thank you for your help.',
    },
    {
      'word': 'Goodbye',
      'translation': 'وداعاً',
      'phonetic': '/ɡʊdˈbaɪ/',
      'example': 'Goodbye, see you tomorrow!',
    },
    {
      'word': 'Leverage',
      'translation': 'استغلال الموارد / نقطة قوة',
      'phonetic': '/ˈlev.ər.ɪdʒ/',
      'example': 'We need to leverage our strengths.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(hybridAudioServiceProvider);
    final card = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Card ${_currentIndex + 1} of ${_flashcards.length}',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showTranslation = !_showTranslation;
                  });
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 40, color: Color(0xFF2563EB)),
                            onPressed: () => audio.speakText(card['word']!),
                            tooltip: 'Listen to word',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            card['word']!,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            card['phonetic']!,
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),
                          if (_showTranslation) ...[
                            Text(
                              card['translation']!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF16A34A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              card['example']!,
                              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ] else ...[
                            const Text(
                              'Tap card to reveal translation',
                              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentIndex > 0
                      ? () {
                          setState(() {
                            _currentIndex--;
                            _showTranslation = false;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(userXpProvider.notifier).state += 5;
                    if (_currentIndex < _flashcards.length - 1) {
                      setState(() {
                        _currentIndex++;
                        _showTranslation = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(_currentIndex < _flashcards.length - 1 ? 'Next' : 'Finish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
