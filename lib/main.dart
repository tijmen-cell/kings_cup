import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'models/language_provider.dart';
import 'screens/home_screen.dart';
import 'constants/style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const KingsCupApp(),
    ),
  );
}

class KingsCupApp extends StatelessWidget {
  const KingsCupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'King\'s Cup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.cardBackground,
          background: AppColors.background,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
