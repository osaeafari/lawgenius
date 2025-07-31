import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:lawgenius/core/constants/app_text_styles.dart';

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String screenTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const BackButtonAppBar({super.key, required this.screenTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary, // Border color
              width: 2.0, // Adjust thickness as needed
            ),
            color: AppColors.background, // Purple background
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primary, // Icon color
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      title: Text(screenTitle, style: AppTextStyles.sectionTitle),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }
}
