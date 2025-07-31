import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:lawgenius/providers/chart_history_provider.dart';
import 'package:lawgenius/widgets/history_card_widget.dart';
import 'package:provider/provider.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<ChatHistoryProvider>().history;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: history.isEmpty
          ? const Center(child: Text("No chat history yet."))
          : Column(
              children: [
                // Create individual cards with dividers
                ...List.generate(history.length * 2 - 1, (index) {
                  if (index.isEven) {
                    // Card
                    final dataIndex = index ~/ 2;
                    return HistoryCard(item: history[dataIndex]);
                  } else {
                    // Divider between cards
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Divider(
                        color: AppColors.primary,
                        thickness: 0,
                        height: 0,
                      ),
                    );
                  }
                }),
              ],
            ),
    );
  }
}
