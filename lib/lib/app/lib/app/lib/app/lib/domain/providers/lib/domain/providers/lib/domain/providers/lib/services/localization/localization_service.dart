import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages
enum SupportedLanguage {
  english('en', 'English'),
  arabic('ar', 'العربية'),
  spanish('es', 'Español'),
  french('fr', 'Français'),
  german('de', 'Deutsch');

  final String code;
  final String displayName;

  const SupportedLanguage(this.code, this.displayName);

  static SupportedLanguage fromCode(String code) {
    return SupportedLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => SupportedLanguage.english,
    );
  }
}

/// Localization service for multilingual UI
class LocalizationService {
  final SharedPreferences _preferences;
  Map<String, String> _translations = {};
  SupportedLanguage _currentLanguage = SupportedLanguage.english;
  String _fallbackLanguage = 'en';
  bool _isLoaded = false;

  LocalizationService({required SharedPreferences preferences}) 
      : _preferences = preferences {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedCode = _preferences.getString('app_language') ?? 'en';
    _currentLanguage = SupportedLanguage.fromCode(savedCode);
    _loadLanguageSync(_currentLanguage);
  }

  void _loadLanguageSync(SupportedLanguage language) {
    try {
      final jsonString = rootBundle.loadStringSync('assets/locales/${language.code}.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      _translations = jsonData.map((key, value) => MapEntry(key, value.toString()));
      _currentLanguage = language;
      _isLoaded = true;
    } catch (e) {
      print('Failed to load language ${language.code}: $e');
      if (language.code != 'en') {
        _loadLanguageSync(SupportedLanguage.english);
      } else {
        _translations = _getHardcodedTranslations('en');
        _isLoaded = true;
      }
    }
  }

  /// Load translations for a specific language
  Future<void> loadLanguage(SupportedLanguage language) async {
    if (_currentLanguage == language && _isLoaded) return;
    _loadLanguageSync(language);
    await _preferences.setString('app_language', language.code);
  }

  /// Get translation for a key
  String translate(String key, [Map<String, String>? params]) {
    if (!_isLoaded) {
      return _getFallbackText(key);
    }

    String? translation = _translations[key];
    if (translation == null) {
      return _getFallbackText(key);
    }

    // Replace parameters
    if (params != null) {
      params.forEach((paramKey, value) {
        translation = translation?.replaceAll('{$paramKey}', value);
      });
    }

    return translation;
  }

  String _getFallbackText(String key) {
    final fallbacks = _getHardcodedTranslations(_fallbackLanguage);
    return fallbacks[key] ?? key;
  }

  Map<String, String> _getHardcodedTranslations(String language) {
    if (language == 'ar') {
      return {
        'app_title': 'PolyglotMaster English',
        'hello': 'مرحباً',
        'goodbye': 'وداعاً',
        'thank_you': 'شكراً لك',
        'yes': 'نعم',
        'no': 'لا',
        'lesson': 'درس',
        'lessons': 'دروس',
        'vocabulary': 'مفردات',
        'flashcards': 'بطاقات تعليمية',
        'dialogues': 'حوارات',
        'podcasts': 'بودكاست',
        'profile': 'الملف الشخصي',
        'settings': 'الإعدادات',
        'continue': 'متابعة',
        'start': 'ابدأ',
        'complete': 'أكمل',
        'progress': 'التقدم',
        'score': 'النتيجة',
        'xp': 'نقاط الخبرة',
        'streak': 'سلسلة متتالية',
        'hearts': 'قلوب',
        'level': 'المستوى',
        'achievements': 'الإنجازات',
        'daily_goals': 'الأهداف اليومية',
        'available': 'متاح',
        'locked': 'مغلق',
        'completed': 'مكتمل',
        'correct': 'صحيح',
        'incorrect': 'غير صحيح',
        'skip': 'تخطي',
        'submit': 'إرسال',
        'next': 'التالي',
        'hint': 'تلميح',
        'explanation': 'شرح',
        'translation': 'ترجمة',
        'pronunciation': 'النطق',
        'example': 'مثال',
        'grammar_tip': 'نصيحة نحوية',
        'home': 'الرئيسية',
        'learn': 'تعلم',
        'practice': 'تمرن',
        'skip_introduction': 'تخطي المقدمة',
        'get_started': 'ابدأ الآن',
        'loading_content': 'جاري تحميل المحتوى...',
        'retry': 'إعادة المحاولة',
      };
    }
    // Default English
    return {
      'app_title': 'PolyglotMaster English',
      'hello': 'Hello',
      'goodbye': 'Goodbye',
      'thank_you': 'Thank you',
      'yes': 'Yes',
      'no': 'No',
      'lesson': 'Lesson',
      'lessons': 'Lessons',
      'vocabulary': 'Vocabulary',
      'flashcards': 'Flashcards',
      'dialogues': 'Dialogues',
      'podcasts': 'Podcasts',
      'profile': 'Profile',
      'settings': 'Settings',
      'continue': 'Continue',
      'start': 'Start',
      'complete': 'Complete',
      'progress': 'Progress',
      'score': 'Score',
      'xp': 'XP',
      'streak': 'Streak',
      'hearts': 'Hearts',
      'level': 'Level',
      'achievements': 'Achievements',
      'daily_goals': 'Daily Goals',
      'available': 'Available',
      'locked': 'Locked',
      'completed': 'Completed',
      'correct': 'Correct',
      'incorrect': 'Incorrect',
      'skip': 'Skip',
      'submit': 'Submit',
      'next': 'Next',
      'hint': 'Hint',
      'explanation': 'Explanation',
      'translation': 'Translation',
      'pronunciation': 'Pronunciation',
      'example': 'Example',
      'grammar_tip': 'Grammar Tip',
      'home': 'Home',
      'learn': 'Learn',
      'practice': 'Practice',
      'skip_introduction': 'Skip introduction',
      'get_started': 'Get Started',
      'loading_content': 'Loading content...',
      'retry': 'Retry',
    };
  }

  /// Get current language
  SupportedLanguage getCurrentLanguage() => _currentLanguage;

  /// Change language
  Future<void> setLanguage(SupportedLanguage language) async {
    if (language == _currentLanguage) return;
    await loadLanguage(language);
  }

  /// Check if localization is loaded
  bool get isLoaded => _isLoaded;
}
