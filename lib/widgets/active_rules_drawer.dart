import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/language_provider.dart';
import '../constants/style.dart';

class ActiveRulesDrawer extends StatelessWidget {
  const ActiveRulesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Consumer<LanguageProvider>(
          builder: (context, lang, child) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(lang.translate('active_rules'), style: AppTextStyles.title),
              ),
              const Divider(color: AppColors.textFaint),
              if (game.snakeEyesActive)
                ListTile(
                   leading: const Icon(Icons.remove_red_eye, color: AppColors.secondary),
                   title: Text(lang.translate('snake_eyes'), style: AppTextStyles.body),
                   subtitle: Text(lang.translate('eye_contact_drink'), style: AppTextStyles.label),
                ),
              if (game.questionMasterActive)
                 ListTile(
                   leading: const Icon(Icons.help, color: AppColors.primary),
                   title: Text(lang.translate('question_master'), style: AppTextStyles.body),
                   subtitle: Text(lang.translate('no_questions'), style: AppTextStyles.label),
                ),
              if (!game.snakeEyesActive && !game.questionMasterActive && game.activeRules.isEmpty)
                 Padding(
                   padding: const EdgeInsets.all(16),
                   child: Text(lang.translate('no_active_rules'), style: AppTextStyles.label),
                 ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: game.activeRules.length,
                  itemBuilder: (context, index) {
                     final rule = game.activeRules[index];
                     return ListTile(
                       leading: const Icon(Icons.edit, color: AppColors.accent),
                       title: Text(rule.description, style: AppTextStyles.body),
                       subtitle: Text(rule.source, style: AppTextStyles.label),
                     );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
