import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:lawgenius/models/chat_history_item.dart';
import 'package:lawgenius/providers/chart_history_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class HistoryCard extends StatelessWidget {
  final ChatHistoryItem item;

  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/chat-screen?chatId=${item.chatId}');
      },
      child: Stack(
        children: [
          Container(
            // padding: const EdgeInsets.all(12),
            //margin: const EdgeInsets.symmetric(vertical: 0),
            decoration: BoxDecoration(
              // color: AppColors.background,
              // border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              // borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // History Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.0),
                    color: AppColors.background,
                  ),
                  child: const Icon(
                    Icons.history,
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
                        item.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.answer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Forward Icon
                GestureDetector(
                  onTap: () {
                    context.push('/chat-screen?chatId=${item.chatId}');
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
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showDeleteDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.white,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Chat History'),
          content: const Text(
            'Are you sure you want to delete this chat history? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final historyProvider = Provider.of<ChatHistoryProvider>(
                  context,
                  listen: false,
                );
                historyProvider.removeItem(item);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
