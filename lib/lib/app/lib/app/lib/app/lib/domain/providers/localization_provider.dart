import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/localization/localization_service.dart';

/// Provider for localization service
final localizationServiceProvider = Provider<LocalizationService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalizationService(preferences: prefs);
});

/// Provider for current language
final currentLanguageProvider = Provider<SupportedLanguage>((ref) {
  return ref.watch(localizationServiceProvider).getCurrentLanguage();
});

/// Provider for translation function
final translateProvider = Provider<LocalizationFunction>((ref) {
  final service = ref.watch(localizationServiceProvider);
  return (String key, [Map<String, String>? params]) {
    return service.translate(key, params);
  };
});

typedef LocalizationFunction = String Function(String key, [Map<String, String>? params]);

/// Extension for easy translation in widgets
extension TranslateExtension on WidgetRef {
  String tr(String key, [Map<String, String>? params]) {
    return watch(translateProvider)(key, params);
  }
}
