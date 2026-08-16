import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for app settings
final appSettingsProvider = FutureProvider<Map<String, String>>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  
  return {
    'user_id': prefs.getString('user_id') ?? 'default_user',
    'default_language': prefs.getString('default_language') ?? 'en',
    'audio_speed': prefs.getString('audio_speed') ?? '1.0',
    'auto_play': prefs.getString('auto_play') ?? 'true',
    'reminders': prefs.getString('reminders') ?? 'true',
    'has_completed_onboarding': prefs.getString('has_completed_onboarding') ?? 'false',
  };
});

/// Provider for saving settings
final saveSettingProvider = FutureProvider.family<void, SettingUpdate>((ref, update) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  await prefs.setString(update.key, update.value);
});

/// Provider to get a specific setting
final settingProvider = FutureProvider.family<String?, String>((ref, key) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString(key);
});

class SettingUpdate {
  final String key;
  final String value;
  
  SettingUpdate({required this.key, required this.value});
}
