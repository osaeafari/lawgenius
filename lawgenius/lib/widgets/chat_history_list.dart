import 'package:flutter/material.dart';
import 'package:lawgenius/providers/chart_history_provider.dart';
import 'package:provider/provider.dart';

class ChatHistoryList extends StatelessWidget {
  const ChatHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<ChatHistoryProvider>().history;

    if (history.isEmpty) {
      return const Center(child: Text('No chat history yet.'));
    }

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return ListTile(
          leading: Icon(item.icon),
          title: Text(item.question),
          subtitle: Text(item.answer),
          trailing: Text(
            _formatTimestamp(item.timestamp),
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
