import 'package:flutter/material.dart';
import 'package:lawgenius/providers/chart_history_provider.dart';
import 'package:lawgenius/routes/app_routes.dart';
import 'package:lawgenius/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final chatHistoryProvider = ChatHistoryProvider();
  await chatHistoryProvider.loadFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatHistoryProvider>.value(
          value: chatHistoryProvider,
        ),
      ],
      child: const LawGenius(),
    ),
  );
}

class LawGenius extends StatelessWidget {
  const LawGenius({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.router,
      title: 'Law Genius',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
          error: AppColors.red,
          secondary: AppColors.accent,
        ),
      ),
    );
  }
}
