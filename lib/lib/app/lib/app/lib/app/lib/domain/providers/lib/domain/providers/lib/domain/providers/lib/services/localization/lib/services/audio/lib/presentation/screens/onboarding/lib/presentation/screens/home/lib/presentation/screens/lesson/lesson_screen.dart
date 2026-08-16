import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/audio/hybrid_audio_service.dart';
import '../../../domain/providers/progress_provider.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;
  final String userId;

  const LessonScreen({
    super.key,
    required this.lessonId,
    required this.userId,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _selectedOptionIndex = -1;
  bool _isAnswered = false;
  bool _isCorrect = false;

  final String _question = "How do you say 'Hello' in English?";
  final List<String> _options = ["Hello", "Goodbye", "Thank you", "Please"];
  final int _correctIndex = 0;

  @override
  Widget build(BuildContext context) {
    final audioService = ref.watch(hybridAudioServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson: Greetings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 36, color: Color(0xFF2563EB)),
                  onPressed: () => audioService.speakText(_question),
                  tooltip: 'Listen to question',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _question,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ...List.generate(_options.length, (index) {
              final option = _options[index];
              Color buttonColor = Colors.white;
              Color borderColor = Colors.grey.shade300;

              if (_isAnswered) {
                if (index == _correctIndex) {
                  buttonColor = Colors.green.shade50;
                  borderColor = Colors.green;
                } else if (index == _selectedOptionIndex) {
                  buttonColor = Colors.red.shade50;
                  borderColor = Colors.red;
                }
              } else if (_selectedOptionIndex == index) {
                borderColor = const Color(0xFF2563EB);
                buttonColor = const Color(0xFF2563EB).withOpacity(0.05);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: _isAnswered
                      ? null
                      : () {
                          setState(() => _selectedOptionIndex = index);
                          audioService.speakText(option);
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        if (_isAnswered && index == _correctIndex)
                          const Icon(Icons.check_circle, color: Colors.green)
                        else if (_isAnswered && index == _selectedOptionIndex)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedOptionIndex == -1
                  ? null
                  : () {
                      if (!_isAnswered) {
                        setState(() {
                          _isAnswered = true;
                          _isCorrect = (_selectedOptionIndex == _correctIndex);
                          if (_isCorrect) {
                            ref.read(userXpProvider.notifier).state += 10;
                          }
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                !_isAnswered ? 'Check Answer' : (_isCorrect ? 'Awesome! Continue' : 'Got it'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
