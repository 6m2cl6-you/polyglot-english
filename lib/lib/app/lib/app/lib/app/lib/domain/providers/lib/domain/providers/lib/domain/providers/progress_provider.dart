import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for current user ID
final currentUserIdProvider = Provider<String>((ref) {
  return 'default_user';
});

/// Provider for user XP points
final userXpProvider = StateProvider<int>((ref) => 0);

/// Provider for user streak count
final userStreakProvider = StateProvider<int>((ref) => 1);

/// Provider for user hearts count
final userHeartsProvider = StateProvider<int>((ref) => 5);
