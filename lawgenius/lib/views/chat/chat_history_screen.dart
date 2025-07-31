import 'package:flutter/material.dart';
import 'package:lawgenius/providers/chart_history_provider.dart';
import 'package:lawgenius/widgets/chat_history_list.dart';
import 'package:provider/provider.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatHistoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              chatProvider.clearHistory();
            },
          ),
        ],
      ),
      body: const ChatHistoryList(),
    );
  }
}
