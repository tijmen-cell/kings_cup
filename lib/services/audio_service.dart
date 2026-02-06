import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playDrawCard() async {
    try {
      await _player.play(AssetSource('audio/card_flip.mp3'));
    } catch (e) {
      // Ignore errors if file missing
    }
  }

  static Future<void> playGameOver() async {
    try {
      await _player.play(AssetSource('audio/game_over.mp3'));
    } catch (e) {
      // Ignore
    }
  }

  static Future<void> playNewRule() async {
    try {
      await _player.play(AssetSource('audio/new_rule.mp3'));
    } catch (e) {
      // Ignore
    }
  }
}
