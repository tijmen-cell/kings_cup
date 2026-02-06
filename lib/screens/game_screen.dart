import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:playing_cards/playing_cards.dart';
import '../models/game_state.dart';
import '../models/language_provider.dart';
import '../constants/style.dart';
import '../constants/rules.dart';
import '../widgets/active_rules_drawer.dart';
import '../widgets/flippable_card.dart';
import '../services/audio_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _gameOverController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _gameOverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Slow animation
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _gameOverController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _gameOverController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _gameOverController.dispose();
    super.dispose();
  }

  void _startGameOverAnimation() {
    if (!_animationStarted) {
      setState(() {
        _animationStarted = true;
      });
      _gameOverController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LanguageProvider>(
          builder: (context, lang, _) => Text(lang.translate('app_title'), style: AppTextStyles.title),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const ActiveRulesDrawer(),
      body: SafeArea(
        child: Consumer<GameState>(
          builder: (context, game, child) {
            // Trigger animation if game over
            if (game.status == GameStatus.gameOver) {
              return _buildGameOverOrAnimation(context, game);
            }

            if (game.status == GameStatus.gameOver) {
              return _buildGameOverOrAnimation(context, game);
            }

            final currentRank = game.currentCard != null ? _getRank(game.currentCard!) : null;
            final rule = currentRank != null ? game.currentRules[currentRank] : null;
            final remaining = game.cardsRemaining;

            return Column(
              children: [
                // Top Status Bar (Cups + Progress)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kings Progress
                       Row(
                        children: List.generate(4, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              Icons.sports_bar,
                              color: index < game.kingsCount ? AppColors.secondary : AppColors.cardBackground,
                              size: 24,
                            ),
                          );
                        }),
                      ),
                      // Card Progress
                      Consumer<LanguageProvider>(
                        builder: (context, lang, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "$remaining ${lang.translate('cards_remaining')}",
                              style: AppTextStyles.label,
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 100,
                              child: LinearProgressIndicator(
                                value: (52 - remaining) / 52,
                                backgroundColor: AppColors.cardBackground,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 280, 
                      height: 392,
                      child: FlippableCard(
                        card: game.currentCard,
                        showBack: game.currentCard == null,
                        onTap: () => _handleDraw(context, game),
                      ),
                    ),
                  ),
                ),

                // Rule Display
                Consumer<LanguageProvider>(
                  builder: (context, lang, _) {
                    String title = rule?.title ?? "";
                    String description = rule?.description ?? "";
                    
                    if (rule?.translationKey != null) {
                      title = lang.translate("${rule!.translationKey}_title");
                      description = lang.translate("${rule!.translationKey}_desc");
                    }

                    return AnimatedOpacity(
                      opacity: game.currentCard != null ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.title.copyWith(color: AppColors.primary, fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              description,
                              style: AppTextStyles.body.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            if (game.snakeEyesActive && _getRank(game.currentCard ?? PlayingCard(Suit.spades, CardValue.ace)) == 6)
                              Container(
                                 margin: const EdgeInsets.only(top: 8),
                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                 decoration: BoxDecoration(
                                   color: AppColors.secondary,
                                   borderRadius: BorderRadius.circular(8),
                                 ),
                                 child: Text(
                                   lang.translate('snake_eyes_active'), 
                                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                 ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int _getRank(PlayingCard c) {
    switch (c.value) {
      case CardValue.ace: return 1;
      case CardValue.two: return 2;
      case CardValue.three: return 3;
      case CardValue.four: return 4;
      case CardValue.five: return 5;
      case CardValue.six: return 6;
      case CardValue.seven: return 7;
      case CardValue.eight: return 8;
      case CardValue.nine: return 9;
      case CardValue.ten: return 10;
      case CardValue.jack: return 11;
      case CardValue.queen: return 12;
      case CardValue.king: return 13;
      default: return 0;
    }
  }

  void _handleDraw(BuildContext context, GameState game) {
    if (game.status == GameStatus.gameOver) return;

    AudioService.playDrawCard();
    game.drawCard();
    
    // Check game over
    if (game.status == GameStatus.gameOver) {
       AudioService.playGameOver();
       AudioService.playGameOver();
       _startGameOverAnimation(); // Start animation safely outside build
       return;  
    }

    if (game.currentCard != null) {
       final rank = _getRank(game.currentCard!);
       final rule = game.currentRules[rank];
       
       if (rule?.type == RuleType.input) {
          Future.delayed(const Duration(milliseconds: 600), () {
             if (context.mounted) _showInputDialog(context, game, rank);
          });
       }
    }
  }

  void _showInputDialog(BuildContext context, GameState game, int rank) {
     AudioService.playNewRule();
     final lang = context.read<LanguageProvider>();
     final title = rank == 8 ? lang.translate('general_rule') : lang.translate('drinking_rule');
     final controller = TextEditingController();
     
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (ctx) => AlertDialog(
         backgroundColor: AppColors.surface,
         title: Text(title, style: AppTextStyles.title),
         content: TextField(
           controller: controller,
           style: AppTextStyles.body,
           decoration: InputDecoration(
             hintText: lang.translate('enter_rule'),
             hintStyle: const TextStyle(color: AppColors.textFaint),
             enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textFaint)),
             focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
           ),
         ),
         actions: [
           TextButton(
             onPressed: () {
               if (controller.text.isNotEmpty) {
                 game.addCustomRule(controller.text, "${lang.translate('card')} $rank");
                 Navigator.pop(ctx);
               }
             },
             child: Text(lang.translate('save'), style: const TextStyle(color: AppColors.primary)),
           )
         ],
       ),
     );
  }

  Widget _buildGameOverOrAnimation(BuildContext context, GameState game) {
    // If just started, we show the card (King) slowly animating?
    // Actually the game state already has the last card as currentCard.
    // We want to emphasize it.
    
    return Stack(
      children: [
        // Background - maybe fade to black?
        AnimatedBuilder(
          animation: _gameOverController,
          builder: (context, child) {
             return Container(
               color: Colors.black.withOpacity(_fadeAnimation.value * 0.8),
             );
          },
        ),
        
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               // The Card
               ScaleTransition(
                 scale: _scaleAnimation,
                 child: SizedBox(
                    width: 280, 
                    height: 392,
                    child: PlayingCardView(card: game.currentCard ?? PlayingCard(Suit.spades, CardValue.king), elevation: 12),
                 ),
               ),
               
               const SizedBox(height: 48),

               // Text
               FadeTransition(
                 opacity: _fadeAnimation,
                 child: Column(
                    children: [
                         Consumer<LanguageProvider>(
                           builder: (context, lang, _) => Text(
                             lang.translate('game_over'),
                             style: AppTextStyles.display.copyWith(
                               fontSize: 48, 
                               color: AppColors.secondary,
                               letterSpacing: 8,
                             )
                           ),
                         ),
                       const SizedBox(height: 16),
                         Consumer<LanguageProvider>(
                           builder: (context, lang, _) => Text(
                             lang.translate('drink_up'), 
                             style: AppTextStyles.title.copyWith(fontSize: 32, fontWeight: FontWeight.w300)
                           ),
                         ),
                       const SizedBox(height: 64),
                       ElevatedButton(
                          onPressed: () {
                            game.startNewGame();
                            setState(() {
                              _animationStarted = false;
                              _gameOverController.reset();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary, 
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                          ),
                           child: Consumer<LanguageProvider>(
                             builder: (context, lang, _) => Text(lang.translate('new_game')),
                           ),
                       ),
                    ],
                 ),
               ),
            ],
          ),
        ),
      ],
    );
  }
}
