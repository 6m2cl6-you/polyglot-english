import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/routes.dart';
import 'app/theme.dart';
import 'domain/providers/progress_provider.dart';
import 'domain/providers/settings_provider.dart';
import 'domain/providers/localization_provider.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PolyglotMasterApp(),
    ),
  );
}

class PolyglotMasterApp extends ConsumerWidget {
  const PolyglotMasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load localization and check onboarding status
    final localizationService = ref.watch(localizationServiceProvider);
    final hasCompletedOnboarding = ref.watch(hasCompletedOnboardingProvider);
    final contentLoad = ref.watch(loadContentProvider);
    
    // Show loading screen while content loads
    if (contentLoad.isLoading) {
      return MaterialApp(
        title: 'PolyglotMaster',
        theme: AppTheme.lightTheme(),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  semanticsLabel: 'Loading content...',
                ),
                SizedBox(height: 16),
                Text('Loading your learning content...'),
              ],
            ),
          ),
        ),
      );
    }
    
    return MaterialApp(
      title: 'PolyglotMaster English',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      initialRoute: hasCompletedOnboarding.valueOrDefault(false) ? '/' : '/onboarding',
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: hasCompletedOnboarding.valueOrDefault(false)
          ? const HomeScreen(userId: 'default_user')
          : const OnboardingScreen(),
      locale: Locale(localizationService.getCurrentLanguage().code),
      supportedLocales: SupportedLanguage.values.map((lang) => Locale(lang.code)),
      localizationsDelegates: const [],
    );
  }
}

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Should be overridden in main');
});

/// Provider for onboarding status
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('has_completed_onboarding') ?? false;
});
