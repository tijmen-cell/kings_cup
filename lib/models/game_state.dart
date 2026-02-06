import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/rules.dart';

enum GameStatus {
  idle,
  playing,
  gameOver,
}

class ActiveRule {
  final String description;
  final String source; // e.g. "Card 8", "Card 9"

  ActiveRule(this.description, this.source);

  Map<String, dynamic> toJson() => {
    'description': description,
    'source': source,
  };

  factory ActiveRule.fromJson(Map<String, dynamic> json) {
    return ActiveRule(json['description'], json['source']);
  }
}

class GameState extends ChangeNotifier {
  List<PlayingCard> _deck = [];
  PlayingCard? _currentCard;
  GameStatus _status = GameStatus.idle;
  int _kingsCount = 0;
  List<ActiveRule> _activeRules = [];
  bool _snakeEyesActive = false;
  bool _questionMasterActive = false;
  Map<int, RuleDefinition> _currentRules = Map.from(defaultRulesMap);

  GameStatus get status => _status;
  PlayingCard? get currentCard => _currentCard;
  int get kingsCount => _kingsCount;
  List<ActiveRule> get activeRules => _activeRules;
  bool get snakeEyesActive => _snakeEyesActive;
  bool get questionMasterActive => _questionMasterActive;
  int get cardsRemaining => _deck.length;
  Map<int, RuleDefinition> get currentRules => _currentRules;

  GameState() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('game_status')) {
      // Load existing game
      final statusIndex = prefs.getInt('game_status') ?? 0;
      _status = GameStatus.values[statusIndex];
      _kingsCount = prefs.getInt('kings_count') ?? 0;
      _snakeEyesActive = prefs.getBool('snake_eyes') ?? false;
      _questionMasterActive = prefs.getBool('question_master') ?? false;

      final deckList = prefs.getStringList('deck') ?? [];
      _deck = deckList.map((s) => _parseCard(s)).toList();

      final currentCardStr = prefs.getString('current_card');
      if (currentCardStr != null) {
        _currentCard = _parseCard(currentCardStr);
      }

      final rulesJson = prefs.getString('active_rules');
      if (rulesJson != null) {
        final List<dynamic> decoded = jsonDecode(rulesJson);
        _activeRules = decoded.map((e) => ActiveRule.fromJson(e)).toList();
      }

      final customRulesJson = prefs.getString('custom_rules');
      if (customRulesJson != null) {
        final Map<String, dynamic> decodedRules = jsonDecode(customRulesJson);
        _currentRules = {};
        // Fill from default first to ensure integrity
        _currentRules.addAll(defaultRulesMap);
        // Override with saved
        decodedRules.forEach((key, value) {
          final intKey = int.tryParse(key);
          if (intKey != null) {
            _currentRules[intKey] = RuleDefinition.fromJson(value);
          }
        });
      } else {
         _currentRules = Map.from(defaultRulesMap);
      }

      notifyListeners();
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('game_status', _status.index);
    await prefs.setInt('kings_count', _kingsCount);
    await prefs.setBool('snake_eyes', _snakeEyesActive);
    await prefs.setBool('question_master', _questionMasterActive);
    await prefs.setStringList('deck', _deck.map((c) => _serializeCard(c)).toList());
    if (_currentCard != null) {
      await prefs.setString('current_card', _serializeCard(_currentCard!));
    } else {
      await prefs.remove('current_card');
    }
    await prefs.setString('active_rules', jsonEncode(_activeRules.map((e) => e.toJson()).toList()));
    
    // Convert int keys to string keys for JSON
    final rulesJsonMap = _currentRules.map((key, value) => MapEntry(key.toString(), value.toJson()));
    await prefs.setString('custom_rules', jsonEncode(rulesJsonMap));
  }

  void startNewGame() {
    _deck = standardFiftyTwoCardDeck();
    _deck.shuffle(Random());
    _currentCard = null;
    _kingsCount = 0;
    _activeRules = [];
    _snakeEyesActive = false;
    _questionMasterActive = false;
    _status = GameStatus.playing;
    _saveState();
    notifyListeners();
  }

  void drawCard() {
    if (_deck.isEmpty) return; // Should not happen with 4 kings rule usually ending it earlier or full deck usage
    
    _currentCard = _deck.removeLast();
    
    // Check for King
    if (_currentCard!.value == CardValue.king) {
      _kingsCount++;
      if (_kingsCount >= 4) {
        _status = GameStatus.gameOver;
      }
    }

    // Check for persistent flags
    int rank = _getRank(_currentCard!);
    if (rank == 6) { // Snake Eyes
      _snakeEyesActive = true;
    }
    if (rank == 12) { // Queen - Question master
      _questionMasterActive = true;
    }

    _saveState();
    notifyListeners();
  }

  void addCustomRule(String ruleText, String source) {
    _activeRules.add(ActiveRule(ruleText, source));
    _saveState();
    notifyListeners();
  }

  void updateRule(int rank, String title, String description) {
    if (_currentRules.containsKey(rank)) {
      final oldRule = _currentRules[rank]!;
      _currentRules[rank] = RuleDefinition(
        title: title,
        description: description,
        type: oldRule.type, // Preserve type
      );
      _saveState();
      notifyListeners();
    }
  }

  void resetRules() {
    _currentRules = Map.from(defaultRulesMap);
    _saveState();
    notifyListeners();
  }

  // Helpers
  String _serializeCard(PlayingCard c) {
    return "${c.suit.index}:${c.value.index}";
  }

  PlayingCard _parseCard(String s) {
    final parts = s.split(':');
    return PlayingCard(
      Suit.values[int.parse(parts[0])],
      CardValue.values[int.parse(parts[1])],
    );
  }

  int _getRank(PlayingCard c) {
    // Mapping CardValue enum to int 1-13
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
}
