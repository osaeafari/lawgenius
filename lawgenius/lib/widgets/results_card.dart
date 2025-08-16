import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';

class ResultsCard extends StatelessWidget {
  final ResultsCard item;

  const ResultsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //context.push('/chat-screen?chatId=${item.chatId}');
      },
      child: Stack(
        children: [
          Container(
            // padding: const EdgeInsets.all(12),
            //margin: const EdgeInsets.symmetric(vertical: 0),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // light Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.0),
                    color: AppColors.background,
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Question + Answer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Multi agent results',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Forward Icon
                GestureDetector(
                  onTap: () {
                    //context.push('/chat-screen?chatId=${item.chatId}');
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Delete button (bottom right)
        ],
      ),
    );
  }
}
