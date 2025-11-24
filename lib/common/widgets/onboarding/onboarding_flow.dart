// lib/common/widgets/onboarding/onboarding_flow.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../text/body_text.dart';
import '../text/heading_large.dart';
import '../../styles/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🎨 **ONBOARDING FLOW - FIRST-TIME USER GUIDANCE**
///
/// Comprehensive onboarding flow for first-time users
/// Provides step-by-step guidance through key features
class OnboardingFlow extends StatefulWidget {
  final OnboardingType type;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const OnboardingFlow({
    this.type = OnboardingType.guest,
    this.onComplete,
    this.onSkip,
    super.key,
  });

  static Future<bool> shouldShowOnboarding(OnboardingType type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'onboarding_${type.name}_completed';
    return !(prefs.getBool(key) ?? false);
  }

  static Future<void> markOnboardingComplete(OnboardingType type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'onboarding_${type.name}_completed';
    await prefs.setBool(key, true);
  }

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();
    _pages = _getPagesForType(widget.type);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<OnboardingPage> _getPagesForType(OnboardingType type) {
    switch (type) {
      case OnboardingType.guest:
        return [
          OnboardingPage(
            title: 'Welcome to Atitia!',
            description:
                'Find the perfect PG accommodation with ease. Browse, book, and manage everything in one place.',
            icon: Icons.home,
            image: null,
          ),
          OnboardingPage(
            title: 'Search & Filter',
            description:
                'Use advanced filters to find PGs that match your preferences. Search by location, price, amenities, and more.',
            icon: Icons.search,
            image: null,
          ),
          OnboardingPage(
            title: 'Easy Booking',
            description:
                'Send booking requests to PG owners. Track your requests and get notified when approved.',
            icon: Icons.book_online,
            image: null,
          ),
          OnboardingPage(
            title: 'Manage Payments',
            description:
                'Pay rent securely, view payment history, and keep track of all your transactions.',
            icon: Icons.payment,
            image: null,
          ),
        ];
      case OnboardingType.owner:
        return [
          OnboardingPage(
            title: 'Welcome, Owner!',
            description:
                'Manage your PG properties efficiently. Track guests, payments, and occupancy all in one dashboard.',
            icon: Icons.dashboard,
            image: null,
          ),
          OnboardingPage(
            title: 'Add Your PG',
            description:
                'Create your first PG listing with detailed information, photos, and pricing.',
            icon: Icons.add_home,
            image: null,
          ),
          OnboardingPage(
            title: 'Manage Bookings',
            description:
                'Approve or reject booking requests, assign rooms and beds, and track guest status.',
            icon: Icons.manage_accounts,
            image: null,
          ),
          OnboardingPage(
            title: 'Track Revenue',
            description:
                'Monitor payments, view analytics, and get insights into your PG performance.',
            icon: Icons.analytics,
            image: null,
          ),
        ];
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    OnboardingFlow.markOnboardingComplete(widget.type);
    widget.onSkip?.call();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _completeOnboarding() {
    OnboardingFlow.markOnboardingComplete(widget.type);
    widget.onComplete?.call();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: BodyText(
                      text: 'Skip',
                      color: ThemeColors.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], theme);
                },
              ),
            ),
            
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildIndicator(index == _currentPage),
                ),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: SecondaryButton(
                        onPressed: _previousPage,
                        label: 'Previous',
                      ),
                    ),
                  if (_currentPage > 0)
                    const SizedBox(width: AppSpacing.paddingM),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: _nextPage,
                      label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      icon: _currentPage == _pages.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor.withValues(alpha: 0.1),
            ),
            child: Icon(
              page.icon,
              size: 64,
              color: theme.primaryColor,
            ),
          ),
          
          const SizedBox(height: AppSpacing.paddingXL * 2),
          
          // Title
          HeadingLarge(
            text: page.title,
            align: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.paddingL),
          
          // Description
          BodyText(
            text: page.description,
            align: TextAlign.center,
            color: ThemeColors.getTextSecondary(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final String? image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    this.image,
  });
}

enum OnboardingType {
  guest,
  owner,
}

