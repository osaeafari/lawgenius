import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward(); // start animation

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // clean up the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Stack(
          children: [
            // Foreground content
            Center(
              child: ScaleTransition(
                scale: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset('assets/images/ShareoappLogo.jpg', height: 200),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _animation,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 24),
                          children: [
                            TextSpan(
                              text: 'Law',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: 'GENIUS',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom text and logo
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'by',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                            text: 'Kwame ',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: 'OSAE AFARI',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
