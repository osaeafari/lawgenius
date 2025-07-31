import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Smart Review. Trusted Guidance.',
      'subtitle':
          'Compare AI responses, evaluate quality, and deliver the most suitable legal answer',
      //'image': 'assets/images/onboarding_1.jpg',
    },
    {
      'title': 'AI Meets Accountability',
      'subtitle':
          'Every response is scored and explained using expert-tuned models trained on Ghanaian legal data.',
      //'image': 'assets/images/onboarding_4.jpg',
    },
    {
      'title': 'From Question to Qualified Response',
      'subtitle':
          'Automatically assess AI-generated legal answers for accuracy, relevance, and clarity.',
      //'image': 'assets/images/onboarding_4.jpg',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _welcome();
    }
  }

  void _welcome() {
    context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Stack(
          children: [
            // Foreground UI
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (_, index) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Image.asset(page['image']!, height: 250),
                            const SizedBox(height: 20),
                            Text(
                              page['title']!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary, // Adjust for contrast
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              page['subtitle']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 20,
                      ),
                      height: 10,
                      width: _currentPage == index ? 20 : 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Skip Button (only show if not last page)
                      if (_currentPage != _pages.length - 1)
                        TextButton(
                          onPressed: () => context.go('/welcome'),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.lightgrey,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Welcome'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
