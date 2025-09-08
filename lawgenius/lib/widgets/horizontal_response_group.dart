import 'package:flutter/material.dart';
import 'package:lawgenius/views/chat/chat_screen.dart';

class HorizontalResponseGroup extends StatelessWidget {
  final List<ChatBubble> responses;

  const HorizontalResponseGroup({super.key, required this.responses});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // align at the top
        children: responses.map((msg) {
          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: msg.source == "openai-1"
                  ? Colors.blue[100]
                  : msg.source == "openai-2"
                  ? Colors.green[100]
                  : Colors.purple[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(msg.text, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }
}
