import 'package:flutter/material.dart';
import 'package:lawgenius/widgets/appbar_withBack_button_widget.dart';

class ResultsScreen extends StatelessWidget {
  final String? initialMessage;
  final String? chatId;

  const ResultsScreen({super.key, required this.chatId, this.initialMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(screenTitle: 'Results Screen'),
      body: Column(children: [
        ]
      ),
    );
  }
}

class ChatBubble {
  final String text;
  final bool isUser;

  ChatBubble({required this.text, required this.isUser});

  Map<String, dynamic> toJson() => {'text': text, 'isUser': isUser};

  factory ChatBubble.fromJson(Map<String, dynamic> json) =>
      ChatBubble(text: json['text'], isUser: json['isUser']);
}
