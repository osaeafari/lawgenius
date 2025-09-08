// Importing Flutter's core UI package
import 'package:flutter/material.dart';

// Importing custom services for API interactions.
import 'package:lawgenius/core/services/openai_services.dart';
import 'package:lawgenius/core/services/classifier_service.dart';

// Importing data models and state management providers.
import 'package:lawgenius/models/chat_history_item.dart';
import 'package:lawgenius/providers/chart_history_provider.dart';

// Importing custom UI widgets.
import 'package:lawgenius/widgets/appbar_withBack_button_widget.dart';
import 'package:lawgenius/widgets/horizontal_response_group.dart';

// Importing utility packages and Dart's built-in convert library.
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// Defines the main widget for the chat screen. It's a StatefulWidget because its state changes over time (e.g., new messages).
class ChatScreen extends StatefulWidget {
  // An optional initial message to start the chat with, passed from another screen.
  final String? initialMessage;
  // An optional ID for the chat session. If provided, it loads an existing chat. If null, a new chat is started.
  final String? chatId;

  // Constructor for the ChatScreen widget.
  const ChatScreen({super.key, required this.chatId, this.initialMessage});

  @override
  // Creates the mutable state for this widget.
  State<ChatScreen> createState() => _ChatScreenState();
}

// A data class to model a single message bubble within the chat conversation.
class ChatBubble {
  final String text; // message content
  final bool isUser; // true if sent by user
  final String? intent; // legal or general query
  final String? source; // optional tag: 'openai-1','openai-2','openai-3' etc.

  // Constructor for creating a ChatBubble instance.
  const ChatBubble({
    required this.text,
    required this.isUser,
    this.source,
    this.intent,
  });

  // Converts a ChatBubble instance into a JSON map for storage.
  Map<String, dynamic> toJson() => {
    'text': text,
    'intent': intent,
    'isUser': isUser,
    'source': source,
  };

  // Creates a ChatBubble instance from a JSON map.
  factory ChatBubble.fromJson(Map<String, dynamic> json) => ChatBubble(
    text: json['text'] ?? '',
    intent: json['intent'],
    isUser: json['isUser'] ?? false,
    source: json['source'],
  );
}

// The state class for the ChatScreen widget, where the logic and UI state reside.
class _ChatScreenState extends State<ChatScreen> {
  // Controller for the text input field to manage its content.
  final _controller = TextEditingController();
  // A list to hold all the chat messages (bubbles) displayed on the screen.
  final List<ChatBubble> _messages = [];
  // An instance of the service used to communicate with the OpenAI API.
  final openAIService = OpenAIService();

  // A boolean flag to indicate when the app is waiting for a response from the AI.
  bool _isLoading = false;
  // An instance of the Uuid package to generate unique identifiers.
  final uuid = const Uuid();
  // The resolved chat ID for the current session. It's either passed in or newly generated.
  late final String _resolvedChatId;

  final Map<ChatBubble, List<ChatBubble>> _groupedResponses = {};

  @override
  void initState() {
    super.initState();
    // Determine the chat ID to use: either the one passed via the widget or a new one.
    _resolvedChatId = widget.chatId ?? uuid.v4();
    // Load messages from local storage for the current chat session.
    _loadMessages();

    // If an initial message was passed to the widget, handle it after the UI is built.
    if ((widget.initialMessage ?? '').isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMessage(widget.initialMessage!);
      });
    }
  }

  // Determines the background color of a chat bubble based on its source.
  Color _bubbleColorForSource(String? source, String? intent, bool isUser) {
    if (isUser) return Colors.black; // user messages stay blue

    if (intent == "general") {
      // force grey for all general intent answers
      return Colors.grey.shade300;
    }

    // LEGAL intent responses
    switch (source) {
      case "openai-1":
        return Colors.green.shade100;
      case "openai-2":
        return Colors.orange.shade100;
      case "openai-3":
        return Colors.purple.shade100;
      //case "openai-group":
      //return Colors.transparent; // placeholder container (invisible)
      default:
        return Colors.grey.shade200; // fallback
    }
  }

  // Handles the entire process of sending a message and receiving responses.
  Future<void> _handleMessage(String message) async {
    // Add user bubble immediately
    setState(() {
      _messages.insert(
        0,
        ChatBubble(text: message, isUser: true, intent: null),
      );
      _isLoading = true;
    });

    try {
      final result = await ClassifierService.classifyQuestion(message);

      if (result != null) {
        debugPrint("✅ Intent: ${result.intent}");

        if (result.intent == "legal") {
          // ----------------- LEGAL CASE -----------------
          final openAIAnswer =
              result.best['answer'] ?? "No legal answer available";
          debugPrint("🎯 Legal Answer: $openAIAnswer");

          setState(() {
            _messages.insert(
              0,
              ChatBubble(
                text: "", // placeholder for grouped responses
                isUser: false,
                intent: result.intent,
                source: "openai-group",
              ),
            );

            _groupedResponses[_messages.first] = [
              ChatBubble(
                text: "OpenAI Response #1: $openAIAnswer",
                isUser: false,
                source: "openai-1",
                intent: result.intent,
              ),
              ChatBubble(
                text: "OpenAI Response #2: $openAIAnswer",
                isUser: false,
                source: "openai-2",
                intent: result.intent,
              ),
              ChatBubble(
                text: "OpenAI Response #3: $openAIAnswer",
                isUser: false,
                source: "openai-3",
                intent: result.intent,
              ),
            ];
          });

          await _saveFirstPairToHistoryIfNeeded(
            userQ: message,
            assistantA: openAIAnswer,
          );
        } else {
          // ----------------- GENERAL CASE -----------------
          final generalAnswer = (result.answers.isNotEmpty)
              ? result.answers.first['answer'] ?? "No general answer available"
              : "No general answer available";
          debugPrint("💡 General Answer: $generalAnswer");

          setState(() {
            _messages.insert(
              0,
              ChatBubble(
                text: generalAnswer,
                isUser: false,
                intent: result.intent,
                source: "general", // <- mark as general
              ),
            );
          });

          await _saveFirstPairToHistoryIfNeeded(
            userQ: message,
            assistantA: generalAnswer,
          );
        }

        await _saveMessages();
      } else {
        setState(() {
          _messages.insert(
            0,
            ChatBubble(
              text: "⚠️ No response received from backend",
              isUser: false,
              intent: '',
              source: 'error',
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatBubble(
            text: 'Error: $e',
            isUser: false,
            intent: '',
            source: 'error',
          ),
        );
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Saves the first question and answer of a new chat to the global history provider.
  Future<void> _saveFirstPairToHistoryIfNeeded({
    required String userQ,
    required String assistantA,
  }) async {
    // Get the ChatHistoryProvider instance without listening for changes.
    final historyProvider = Provider.of<ChatHistoryProvider>(
      context,
      listen: false,
    );
    // Check if a history item for this chat ID already exists.
    final existing = historyProvider.history
        .where((e) => e.chatId == _resolvedChatId)
        .toList();
    // If it's a new chat, add a new ChatHistoryItem.
    if (existing.isEmpty) {
      historyProvider.addItem(
        ChatHistoryItem(
          icon: Icons.history,
          question: userQ,
          answer: assistantA,
          timestamp: DateTime.now(),
          chatId: _resolvedChatId,
        ),
      );
    }
  }

  // Triggered when the user presses the send button or submits the text field.
  void _sendMessage() {
    // Get the text from the controller and remove leading/trailing whitespace.
    final text = _controller.text.trim();
    // If the text is empty, do nothing.
    if (text.isEmpty) return;
    // Clear the text field.
    _controller.clear();
    // Handle the sending and response process for the message.
    _handleMessage(text);
  }

  // Loads chat messages from local storage when the screen initializes.
  Future<void> _loadMessages() async {
    // Get an instance of SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the saved JSON string for the current chat ID.
    final jsonString = prefs.getString('chat_messages_$_resolvedChatId');
    // If no data is found, exit the function.
    if (jsonString == null) return;
    // Decode the JSON string into a List.
    final List decoded = json.decode(jsonString);
    // Update the state with the loaded messages, reversing them to maintain chronological order in the list.
    setState(() {
      _messages.addAll(
        decoded.map((e) => ChatBubble.fromJson(e)).toList().reversed,
      );
    });
  }

  // Saves the current list of messages to local storage.
  Future<void> _saveMessages() async {
    // Get an instance of SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    // Encode the list of ChatBubble objects to a JSON string.
    final encoded = json.encode(
      _messages.reversed.map((m) => m.toJson()).toList(),
    );
    // Save the JSON string to SharedPreferences with a key specific to the chat ID.
    await prefs.setString('chat_messages_$_resolvedChatId', encoded);
  }

  @override
  void dispose() {
    // Save messages one last time when the widget is removed from the widget tree.
    _saveMessages();
    // Clean up the text controller to prevent memory leaks.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The main UI structure for the chat screen.
    return Scaffold(
      // Use the custom app bar with a back button.
      appBar: BackButtonAppBar(screenTitle: 'Law Genius'),
      // The main body is a Column to stack the message list and the input field.
      body: Column(
        children: [
          // The message list area, which expands to fill available space.
          Expanded(
            child: ListView.builder(
              reverse: true, // To make the list start from the bottom.
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              // The number of items in the list is the number of messages.
              itemCount: _messages.length,
              // The builder function for each item in the list.
              itemBuilder: (context, index) {
                // Get the message for the current index.
                final message = _messages[index];
                // Determine the background color for the bubble.
                final bgColor = _bubbleColorForSource(
                  message.source,
                  message.intent ?? '',
                  message.isUser,
                );

                if (message.source == "openai-group") {
                  final responses = _groupedResponses[message] ?? [];
                  return HorizontalResponseGroup(responses: responses);
                }

                // If the message is from the user, display a right-aligned bubble.
                if (message.isUser) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      // Constrain the bubble's width to 70% of the screen width.
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      // Display the message text with white color for contrast.
                      child: Text(
                        message.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }

                // If the message is from the assistant, display a left-aligned bubble.
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    // Constrain the bubble's width to 70% of the screen width.
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // Display the message text.
                    child: Text(
                      message.text,
                      style: TextStyle(
                        // Set text color to black for all assistant messages.
                        color: message.source == null
                            ? Colors.black
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // The input area at the bottom of the screen.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              // A Row to hold the text field and the send button side-by-side.
              child: Row(
                children: [
                  // The text field takes up the remaining horizontal space.
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      // Set the keyboard action to "send".
                      textInputAction: TextInputAction.send,
                      // When submitted (e.g., pressing enter), send the message.
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Type your legal question...",
                        // Style the text field with a filled background and rounded corners.
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
                  // A small space between the text field and the send button.
                  const SizedBox(width: 8),
                  // The send button, wrapped in a GestureDetector to handle taps.
                  GestureDetector(
                    // Disable tap when loading.
                    onTap: _isLoading ? null : _sendMessage,
                    // A circular avatar for the button's appearance.
                    child: CircleAvatar(
                      // Change color based on loading state.
                      backgroundColor: _isLoading ? Colors.grey : Colors.black,
                      // Show a progress indicator if loading, otherwise show an arrow icon.
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                // Set the progress indicator color to white.
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          // The send icon.
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
