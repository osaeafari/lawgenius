import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:lawgenius/core/constants/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final uuid = Uuid();

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    final generatedChatId = uuid.v4();
    final searchQuery = text.trim();

    // Pass both chatId and the search query as initialMessage
    context.push(
      '/chat-screen?chatId=$generatedChatId&initialMessage=${Uri.encodeComponent(searchQuery)}',
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.background,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2.0),
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: _handleSubmit,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _handleSubmit(_controller.text),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 5.0,
                            ),
                            color: AppColors.primary,
                          ),
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
