import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/providers/settings_provider.dart';
import '../../../domain/providers/localization_provider.dart';
import '../../../services/localization/localization_service.dart';

/// Onboarding screen with full accessibility and Riverpod integration
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translate = ref.watch(translateProvider);
    final localizationService = ref.watch(localizationServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(translate, localizationService),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _getOnboardingPages(translate).length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final pages = _getOnboardingPages(translate);
                  final page = pages[index];
                  return _buildPageContent(page, index, pages.length, translate);
                },
              ),
            ),
            _buildBottomControls(translate, _getOnboardingPages(translate)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    LocalizationFunction translate,
    LocalizationService localizationService,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            label: translate('select_language'),
            hint: translate('change_ui_language'),
            button: true,
            child: DropdownButton<SupportedLanguage>(
              value: localizationService.getCurrentLanguage(),
              items: SupportedLanguage.values.map((language) {
                return DropdownMenuItem<SupportedLanguage>(
                  value: language,
                  child: Row(
                    children: [
                      Text(_getLanguageFlag(language)),
                      const SizedBox(width: 8),
                      Text(language.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (language) async {
                if (language != null) {
                  await localizationService.setLanguage(language);
                  setState(() {});
                }
              },
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.language),
              elevation: 4,
            ),
          ),
          Semantics(
            label: translate('skip_introduction'),
            hint: translate('skip_onboarding_hint'),
            button: true,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: Text(translate('skip')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(
    OnboardingPageData page,
    int index,
    int totalPages,
    LocalizationFunction translate,
  ) {
    return Semantics(
      label: '${translate('page')} ${index + 1} ${translate('of')} $totalPages: ${page.title}. ${page.description}',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: page.color.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: page.color.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                page.icon,
                size: 64,
                color: page.color,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              page.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              page.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalPages,
                (dotIndex) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == dotIndex ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == dotIndex
                        ? page.color
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(
    LocalizationFunction translate,
    List<OnboardingPageData> pages,
  ) {
    final isLastPage = _currentPage == pages.length - 1;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            Semantics(
              label: translate('previous'),
              hint: translate('go_to_previous_page'),
              button: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                tooltip: translate('previous'),
              ),
            )
          else
            const SizedBox(width: 48),
          Semantics(
            label: isLastPage ? translate('get_started') : translate('next'),
            hint: isLastPage 
                ? translate('start_learning') 
                : translate('go_to_next_page'),
            button: true,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePageAction,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                minimumSize: const Size(120, 48),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isLastPage ? translate('get_started') : translate('next'),
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  List<OnboardingPageData> _getOnboardingPages(LocalizationFunction translate) {
    return [
      OnboardingPageData(
        icon: Icons.school,
        title: translate('onboarding_title_1'),
        description: translate('onboarding_desc_1'),
        color: const Color(0xFF2563EB),
      ),
      OnboardingPageData(
        icon: Icons.offline_bolt,
        title: translate('onboarding_title_2'),
        description: translate('onboarding_desc_2'),
        color: const Color(0xFF16A34A),
      ),
      OnboardingPageData(
        icon: Icons.psychology,
        title: translate('onboarding_title_3'),
        description: translate('onboarding_desc_3'),
        color: const Color(0xFF7C3AED),
      ),
      OnboardingPageData(
        icon: Icons.auto_awesome,
        title: translate('onboarding_title_4'),
        description: translate('onboarding_desc_4'),
        color: const Color(0xFFF59E0B),
      ),
    ];
  }

  String _getLanguageFlag(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return '🇬🇧';
      case SupportedLanguage.arabic:
        return '🇸🇦';
      case SupportedLanguage.spanish:
        return '🇪🇸';
      case SupportedLanguage.french:
        return '🇫🇷';
      case SupportedLanguage.german:
        return '🇩🇪';
    }
  }

  void _handlePageAction() {
    if (_currentPage == _getOnboardingPages(ref.read(translateProvider)).length - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }
}

/// Onboarding page data model
class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
