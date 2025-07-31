import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_colors.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavbar({super.key, this.currentIndex = 0, this.onTap});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(BottomNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      items: [
        BottomNavigationBarItem(
          icon: AnimatedScale(
            scale: widget.currentIndex == 0 ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.home_rounded),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: AnimatedScale(
            scale: widget.currentIndex == 1 ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.gavel),
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: AnimatedScale(
            scale: widget.currentIndex == 2 ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.manage_accounts_rounded),
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
