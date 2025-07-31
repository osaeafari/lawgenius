import 'package:flutter/material.dart';
import 'package:lawgenius/models/chat_history_item.dart';
import 'package:lawgenius/widgets/appbar_withBack_button_widget.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatHistoryItem item;

  const ChatDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(screenTitle: 'Chat History'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Question:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(item.question, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              "Answer:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(item.answer, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
