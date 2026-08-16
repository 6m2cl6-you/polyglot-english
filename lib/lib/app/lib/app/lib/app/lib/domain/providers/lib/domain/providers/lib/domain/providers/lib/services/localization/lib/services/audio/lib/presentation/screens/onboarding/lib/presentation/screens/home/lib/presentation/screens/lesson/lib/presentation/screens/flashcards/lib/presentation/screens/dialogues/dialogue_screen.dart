import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/audio/hybrid_audio_service.dart';
import '../../../domain/providers/progress_provider.dart';

class DialogueScreen extends ConsumerStatefulWidget {
  final String dialogueId;
  final String userId;

  const DialogueScreen({
    super.key,
    required this.dialogueId,
    required this.userId,
  });

  @override
  ConsumerState<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends ConsumerState<DialogueScreen> {
  final List<Map<String, String>> _dialogueLines = [
    {
      'speaker': 'Sarah',
      'text': 'Hello Alex! How are you doing today?',
      'translation': 'مرحباً أليكس! كيف حالك اليوم؟',
      'isUser': 'false',
    },
    {
      'speaker': 'Alex',
      'text': 'Hi Sarah! I am doing great, thank you. How about you?',
      'translation': 'أهلاً سارة! أنا بخير شكراً لك، وماذا عنك؟',
      'isUser': 'true',
    },
    {
      'speaker': 'Sarah',
      'text': 'I am learning English with this app, it is amazing!',
      'translation': 'أنا أتعلم الإنجليزية مع هذا التطبيق، إنه رائع!',
      'isUser': 'false',
    },
    {
      'speaker': 'Alex',
      'text': 'That sounds wonderful. Keep up the good work!',
      'translation': 'هذا رائع حقاً، استمري في هذا العمل الجيد!',
      'isUser': 'true',
    },
  ];

  int _playingIndex = -1;

  @override
  Widget build(BuildContext context) {
    final audio = ref.watch(hybridAudioServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogue Practice'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _dialogueLines.length,
        itemBuilder: (context, index) {
          final line = _dialogueLines[index];
          final isUser = line['isUser'] == 'true';

          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(14.0),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF2563EB) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    line['speaker']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUser ? Colors.white70 : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    line['text']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: isUser ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    line['translation']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white60 : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      _playingIndex == index
                          ? Icons.volume_up
                          : Icons.volume_mute,
                      color: isUser ? Colors.white : const Color(0xFF2563EB),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() => _playingIndex = index);
                      audio.speakText(line['text']!);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            ref.read(userXpProvider.notifier).state += 15;
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Complete Dialogue (+15 XP)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
