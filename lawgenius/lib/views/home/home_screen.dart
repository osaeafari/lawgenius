import 'package:flutter/material.dart';
import 'package:lawgenius/core/constants/app_text_styles.dart';
import 'package:lawgenius/widgets/scroll_cotainer.dart';
import 'package:lawgenius/widgets/search_bar_widget.dart';
import 'package:lawgenius/widgets/section_title_widget.dart';
import 'package:lawgenius/widgets/suggestion_text_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'Looking for accurate legal guidance? Ask away.',
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const SearchBarWidget(),
            const SizedBox(height: 16),
            const SuggestionTextCardWidget(),
            const SizedBox(height: 16),
            const SectionTitle(sectionTitle: 'History', showSeeAll: false),
            const SizedBox(height: 8),

            SizedBox(child: ScrollContainer()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
