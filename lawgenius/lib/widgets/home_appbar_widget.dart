import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_colors.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  final String userName = 'Kwame Osae Afari';

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      backgroundColor: AppColors.background,
      shadowColor: Theme.of(context).shadowColor,

      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56, // radius * 2 + border
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage(
                          'assets/images/profile-pic/profilePic.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
