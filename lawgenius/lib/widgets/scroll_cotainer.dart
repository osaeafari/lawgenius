import 'package:flutter/material.dart';
import 'package:lawgenius/widgets/history_list_widget.dart';

class ScrollContainer extends StatelessWidget {
  const ScrollContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 193, 185, 200).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: HistoryListWidget(),
      ),
    );
  }
}
