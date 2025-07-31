import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/widgets/buttom_navbar_widget.dart';
import 'package:lawgenius/widgets/home_appbar_widget.dart';

class ShellNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellNavigationScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navigationShell.currentIndex == 0
          ? HomeAppbar()
          : null, // Only show custom app bar on home tab
      body: navigationShell,
      bottomNavigationBar: BottomNavbar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
