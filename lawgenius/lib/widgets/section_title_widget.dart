import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:lawgenius/core/constants/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String sectionTitle;
  final bool showSeeAll;

  const SectionTitle({
    super.key,
    required this.sectionTitle,
    this.showSeeAll = true,
  }); // default: show it

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(sectionTitle, style: AppTextStyles.sectionTitle),
          if (showSeeAll)
            Text('See All', style: TextStyle(color: AppColors.primary)),
        ],
      ),
    );
  }
}
