import 'package:flutter/material.dart';
import 'package:lawgenius/core/services/openai_services.dart';
import 'package:lawgenius/models/chat_history_item.dart';
import 'package:lawgenius/providers/chart_history_provider.dart';
import 'package:lawgenius/widgets/appbar_withBack_button_widget.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:lawgenius/core/services/classifier_service.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;
  final String? chatId;

  const ChatScreen({super.key, required this.chatId, this.initialMessage});
  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<ChatBubble> _messages = [];
  final openAIService = OpenAIService();
  bool _isLoading = false;
  final uuid = Uuid();
  late final String _resolvedChatId;

  @override
  void initState() {
    super.initState();
    _resolvedChatId = widget.chatId ?? uuid.v4();
    _loadMessages(); // ← Load saved messages first
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMessage(widget.initialMessage!); // Wait for context
      });
    }
  }

  Future<void> _handleMessage(String message) async {
    setState(() {
      _messages.insert(0, ChatBubble(text: message, isUser: true));
      _isLoading = true;
    });

    try {
      // 🔍 First classify the intent
      final intent = await ClassifierService.classifyQuestion(message);

      if (intent == null) {
        setState(() {
          _messages.insert(
            0,
            ChatBubble(
              text: 'Error: Could not classify the message',
              isUser: false,
            ),
          );
        });
        return;
      }

      String response;

      // 🤖 Handle based on intent
      if (intent == 'legal') {
        response = await openAIService.sendMessage(message); // Use legal model
      } else {
        response =
            'This is a general message. We can add support for this later.';
      }

      setState(() {
        _messages.insert(0, ChatBubble(text: response, isUser: false));
      });

      final historyProvider = Provider.of<ChatHistoryProvider>(
        context,
        listen: false,
      );

      final existing = historyProvider.history
          .where((e) => e.chatId == _resolvedChatId)
          .toList();

      if (existing.isEmpty) {
        historyProvider.addItem(
          ChatHistoryItem(
            icon: Icons.history,
            question: message,
            answer: response,
            timestamp: DateTime.now(),
            chatId: _resolvedChatId,
          ),
        );
      }

      await _saveMessages();
    } catch (e) {
      setState(() {
        _messages.insert(0, ChatBubble(text: 'Error: $e', isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    _handleMessage(text);
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('chat_messages_$_resolvedChatId');
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      setState(() {
        _messages.addAll(
          decoded.map((e) => ChatBubble.fromJson(e)).toList().reversed,
        );
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(
      _messages.reversed.map((m) => m.toJson()).toList(),
    );
    await prefs.setString('chat_messages_$_resolvedChatId', encoded);
  }

  @override
  void dispose() {
    _saveMessages(); // Persist any unsaved state
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(screenTitle: 'Law Genius'),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.black : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input field
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Type your legal question...",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      backgroundColor: _isLoading ? Colors.grey : Colors.black,
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.arrow_outward_rounded,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
