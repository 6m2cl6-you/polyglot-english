import 'package:flutter/material.dart';

import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/lesson/lesson_screen.dart';
import '../presentation/screens/flashcards/flashcard_screen.dart';
import '../presentation/screens/dialogues/dialogue_screen.dart';
import '../presentation/screens/podcasts/podcast_player_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String lesson = '/lesson';
  static const String flashcards = '/flashcards';
  static const String dialogue = '/dialogue';
  static const String podcast = '/podcast';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingScreen(),
    home: (context) => const HomeScreen(userId: 'default_user'),
    profile: (context) => const ProfileScreen(userId: 'default_user'),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case lesson:
        return MaterialPageRoute(
          builder: (context) => LessonScreen(
            lessonId: args?['lessonId'] ?? '',
            userId: args?['userId'] ?? 'default_user',
          ),
        );
      
      case flashcards:
        return MaterialPageRoute(
          builder: (context) => FlashcardScreen(
            userId: args?['userId'] ?? 'default_user',
            languageCode: args?['languageCode'] ?? 'en',
          ),
        );
      
      case dialogue:
        return MaterialPageRoute(
          builder: (context) => DialogueScreen(
            dialogueId: args?['dialogueId'] ?? '',
            userId: args?['userId'] ?? 'default_user',
          ),
        );
      
      case podcast:
        return MaterialPageRoute(
          builder: (context) => PodcastPlayerScreen(
            podcastId: args?['podcastId'] ?? '',
            userId: args?['userId'] ?? 'default_user',
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
