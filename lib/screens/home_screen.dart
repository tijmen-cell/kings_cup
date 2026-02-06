import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/language_provider.dart';
import '../constants/translations.dart';
import '../constants/style.dart';
import 'game_screen.dart';
import 'rules_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.3, // "High opacity" to keep readable means low alpha for bg in this context usually
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Consumer<LanguageProvider>(
              builder: (context, lang, child) => Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    // Crown
                    Center(
                      child: Image.asset(
                        'assets/images/crown.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lang.translate('app_title'),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.primary,
                        fontSize: 48,
                        letterSpacing: 4,
                        shadows: [
                          const Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lang.translate('app_subtitle'),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMain,
                        shadows: [
                          const Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _buildButton(
                      context,
                      lang.translate('new_game'),
                      AppColors.primary,
                      Colors.black,
                      () {
                        context.read<GameState>().startNewGame();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                      }
                    ),
                    const SizedBox(height: 16),
                    Consumer<GameState>(
                      builder: (context, game, _) {
                        if (game.status == GameStatus.playing) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildButton(
                              context,
                              lang.translate('resume_game'),
                              AppColors.cardBackground,
                              AppColors.textMain,
                              () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                              }
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    _buildButton(
                      context,
                      lang.translate('game_rules'),
                      AppColors.cardBackground,
                      AppColors.textMain,
                      () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => const RulesScreen()));
                      }
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          // Language Selector
          Positioned(
            top: 48,
            right: 16,
            child: Consumer<LanguageProvider>(
              builder: (context, lang, _) => PopupMenuButton<AppLanguage>(
                icon: Text(
                  _getFlag(lang.currentLanguage),
                  style: const TextStyle(fontSize: 32),
                ),
                color: AppColors.surface,
                onSelected: (AppLanguage newLang) {
                  lang.setLanguage(newLang);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<AppLanguage>>[
                  const PopupMenuItem<AppLanguage>(
                    value: AppLanguage.dutch,
                    child: Text("🇳🇱 Dutch"),
                  ),
                  const PopupMenuItem<AppLanguage>(
                    value: AppLanguage.english,
                    child: Text("🇺🇸 English"),
                  ),
                  const PopupMenuItem<AppLanguage>(
                    value: AppLanguage.danish,
                    child: Text("🇩🇰 Danish"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color bg, Color fg, VoidCallback onTap) {
    return SizedBox(
      width: 200, // Fixed width for consistent look
      child: ElevatedButton(
        onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        shadowColor: bg.withValues(alpha: 0.4),
      ),
      child: Text(
        text,
        style: AppTextStyles.title.copyWith(fontSize: 18, color: fg),
      ),
      ),
    );
  }
  String _getFlag(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.dutch: return "🇳🇱";
      case AppLanguage.english: return "🇺🇸";
      case AppLanguage.danish: return "🇩🇰";
    }
  }
}
