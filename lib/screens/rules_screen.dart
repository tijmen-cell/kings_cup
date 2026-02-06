import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/language_provider.dart';
import '../constants/rules.dart';
import '../constants/style.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, game, child) {
         final sortedKeys = game.currentRules.keys.toList()..sort();

         return Scaffold(
          appBar: AppBar(
            title: Consumer<LanguageProvider>(
              builder: (context, lang, _) => Text(lang.translate('game_rules'), style: AppTextStyles.title),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textMain),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.secondary),
                onPressed: () {
                   _confirmReset(context, game);
                },
              )
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final key = sortedKeys[index];
              final rule = game.currentRules[key]!;
              String rankStr = key.toString();
              if (key == 1) rankStr = "A";
              if (key == 11) rankStr = "J";
              if (key == 12) rankStr = "Q";
              if (key == 13) rankStr = "K";

              return Card(
                color: AppColors.cardBackground,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      rankStr,
                      style: AppTextStyles.title.copyWith(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  title: Consumer<LanguageProvider>(
                    builder: (context, lang, _) {
                      String title = rule.title;
                      if (rule.translationKey != null) {
                        title = lang.translate("${rule.translationKey}_title");
                      }
                      return Text(title, style: AppTextStyles.title.copyWith(fontSize: 18));
                    },
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Consumer<LanguageProvider>(
                      builder: (context, lang, _) {
                        String description = rule.description;
                        if (rule.translationKey != null) {
                          description = lang.translate("${rule.translationKey}_desc");
                        }
                        return Text(description, style: AppTextStyles.body.copyWith(color: AppColors.textFaint));
                      },
                    ),
                  ),
                  trailing: const Icon(Icons.edit, color: AppColors.accent, size: 20),
                  onTap: () {
                    _showEditRuleDialog(context, game, key, rule);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showEditRuleDialog(BuildContext context, GameState game, int rank, RuleDefinition currentRule) {
    final lang = context.read<LanguageProvider>();
    final titleController = TextEditingController(text: currentRule.title);
    final descController = TextEditingController(text: currentRule.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(lang.translate('edit_rule'), style: AppTextStyles.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              cursorColor: AppColors.primary,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                labelText: lang.translate('title'),
                labelStyle: const TextStyle(color: AppColors.textFaint),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textFaint)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 16),
             TextField(
              controller: descController,
              cursorColor: AppColors.primary,
              style: AppTextStyles.body,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: lang.translate('description'),
                labelStyle: const TextStyle(color: AppColors.textFaint),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textFaint)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.translate('cancel'), style: const TextStyle(color: AppColors.textFaint)),
          ),
          TextButton(
            onPressed: () {
               game.updateRule(rank, titleController.text, descController.text);
               Navigator.pop(ctx);
            },
            child: Text(lang.translate('save'), style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

   void _confirmReset(BuildContext context, GameState game) {
    final lang = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(lang.translate('reset_rules'), style: AppTextStyles.title),
        content: Text(lang.translate('reset_confirm'), style: AppTextStyles.body),
        actions: [
           TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.translate('no'), style: const TextStyle(color: AppColors.textFaint)),
          ),
          TextButton(
            onPressed: () {
               game.resetRules();
               Navigator.pop(ctx);
            },
            child: Text(lang.translate('yes'), style: const TextStyle(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }
}
