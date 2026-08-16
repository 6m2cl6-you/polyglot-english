import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hybrid audio service with TTS fallback
class HybridAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isTTSEnabled = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Function(Duration)? _onPositionChanged;
  VoidCallback? _onCompletion;
  
  // Speech status
  bool _isSpeaking = false;
  String? _currentText;
  Timer? _ttsTimer;

  HybridAudioService() {
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);
      
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        if (_onCompletion != null) {
          _onCompletion!();
        }
      });
      
      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        print('TTS Error: $msg');
      });
      
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize TTS: $e');
      _isTTSEnabled = false;
    }
  }

  /// Play audio from asset or use TTS fallback
  Future<void> playAudio({
    required String? audioPath,
    required String fallbackText,
    Function(Duration)? onPositionChanged,
    VoidCallback? onCompletion,
  }) async {
    _onPositionChanged = onPositionChanged;
    _onCompletion = onCompletion;

    // Try to play audio file first
    if (audioPath != null && await _audioFileExists(audioPath)) {
      await _playAudioFile(audioPath);
      return;
    }

    // Fallback to TTS
    if (_isTTSEnabled) {
      await _speakWithTTS(fallbackText);
    } else {
      throw Exception('No audio available and TTS is disabled');
    }
  }

  Future<bool> _audioFileExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _playAudioFile(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      _totalDuration = _audioPlayer.duration ?? Duration.zero;
      
      _audioPlayer.positionStream.listen((position) {
        _currentPosition = position;
        if (_onPositionChanged != null) {
          _onPositionChanged!(position);
        }
      });
      
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          if (_onCompletion != null) {
            _onCompletion!();
          }
        }
      });
      
      await _audioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      print('Failed to play audio file: $e');
      throw Exception('Failed to play audio: $e');
    }
  }

  Future<void> _speakWithTTS(String text) async {
    if (!_isTTSEnabled) {
      throw Exception('TTS is not available');
    }

    try {
      _isSpeaking = true;
      _currentText = text;
      
      final estimatedDuration = Duration(milliseconds: text.length * 80);
      _totalDuration = estimatedDuration;
      
      int progress = 0;
      final step = 50;
      _ttsTimer?.cancel();
      _ttsTimer = Timer.periodic(Duration(milliseconds: step), (timer) {
        progress += step;
        if (progress < estimatedDuration.inMilliseconds) {
          _currentPosition = Duration(milliseconds: progress);
          if (_onPositionChanged != null) {
            _onPositionChanged!(_currentPosition);
          }
        } else {
          timer.cancel();
          _isSpeaking = false;
          if (_onCompletion != null) {
            _onCompletion!();
          }
        }
      });
      
      await _flutterTts.speak(text);
    } catch (e) {
      _isSpeaking = false;
      print('TTS speak failed: $e');
      throw Exception('Failed to speak text: $e');
    }
  }

  /// Speak a single word or phrase
  Future<void> speakText(String text) async {
    if (!_isTTSEnabled) return;
    
    try {
      await stop();
      await _flutterTts.speak(text);
    } catch (e) {
      print('TTS speak failed: $e');
    }
  }

  /// Pause playback
  Future<void> pause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    }
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
      _ttsTimer?.cancel();
    }
  }

  /// Stop playback
  Future<void> stop() async {
    await _audioPlayer.stop();
    await _flutterTts.stop();
    _isPlaying = false;
    _isSpeaking = false;
    _ttsTimer?.cancel();
    _currentPosition = Duration.zero;
  }

  /// Set playback speed
  Future<void> setSpeed(double speed) async {
    if (_isPlaying) {
      await _audioPlayer.setSpeed(speed);
    }
    await _flutterTts.setSpeechRate(speed * 0.5);
  }

  /// Get current position
  Duration get currentPosition => _currentPosition;

  /// Get total duration
  Duration get totalDuration => _totalDuration;

  /// Check if playing
  bool get isPlaying => _isPlaying || _isSpeaking;

  /// Check if TTS is available
  bool get isTTSAvailable => _isTTSEnabled;

  /// Dispose resources
  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
    _ttsTimer?.cancel();
  }
}

/// Provider for hybrid audio service
final hybridAudioServiceProvider = Provider<HybridAudioService>((ref) {
  return HybridAudioService();
});
