import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:uuid/uuid.dart';

class SuggestionTextCardWidget extends StatelessWidget {
  const SuggestionTextCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      'What are my rights during an arrest?',
      'Can I get bail for a minor offense?',
      'How do I report police misconduct?',
      'What does legal aid cover?',
      'What are the steps in a civil case?',
    ];

    final uuid = Uuid();

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) => Container(
          width: 120,
          margin: EdgeInsets.only(left: index == 0 ? 0 : 0, right: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Stack(
            children: [
              // Centered main text
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  suggestions[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: AppColors.background,
                    height: 1.4,
                  ),
                ),
              ),
              // Arrow icon
              Positioned(
                bottom: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    final generatedChatId = uuid.v4();
                    final suggestionText = suggestions[index];

                    context.push(
                      '/chat-screen?chatId=$generatedChatId&initialMessage=${Uri.encodeComponent(suggestionText)}',
                    );
                  },
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
