import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatHistoryItem {
  final IconData icon;
  final String question;
  final String answer;
  final DateTime timestamp;
  final String chatId; // Add this

  ChatHistoryItem({
    required this.icon,
    required this.question,
    required this.answer,
    required this.timestamp,
    required this.chatId,
  });

  Map<String, dynamic> toJson() => {
    'icon': icon.codePoint,
    'question': question,
    'answer': answer,
    'timestamp': timestamp.toIso8601String(),
    'chatId': chatId,
  };

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) =>
      ChatHistoryItem(
        icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
        question: json['question'] ?? '',
        answer: json['answer'] ?? '',
        timestamp: DateTime.parse(json['timestamp']),
        chatId: json['chatId'] ?? const Uuid().v4(), // fallback if null
      );
}
