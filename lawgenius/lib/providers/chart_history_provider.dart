import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lawgenius/models/chat_history_item.dart';

class ChatHistoryProvider with ChangeNotifier {
  final List<ChatHistoryItem> _history = [];

  List<ChatHistoryItem> get history => _history.reversed.toList();

  void addItem(ChatHistoryItem item) {
    _history.add(item);
    _saveToPrefs();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('chat_history');
    if (jsonString != null) {
      final decoded = json.decode(jsonString);
      _history.clear();
      _history.addAll(
        (decoded as List).map((e) => ChatHistoryItem.fromJson(e)).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_history.map((e) => e.toJson()).toList());
    await prefs.setString('chat_history', encoded);
  }

  void removeItem(ChatHistoryItem item) {
    _history.removeWhere(
      (historyItem) =>
          historyItem.chatId == item.chatId &&
          historyItem.question == item.question,
    );
    notifyListeners();
  }

  // You might also want to add a method to remove by chatId only
  void removeByChatId(String chatId) {
    _history.removeWhere((historyItem) => historyItem.chatId == chatId);
    notifyListeners();
  }
}
