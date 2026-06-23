import 'package:flame_audio/flame_audio.dart';

class AudioSystem {
  static bool _initialised = false;

  static Future<void> init() async {
    if (_initialised) return;
    await FlameAudio.audioCache.loadAll([
      'jump.wav',
      'death.wav',
      'score.wav',
      'milestone.wav',
    ]);
    _initialised = true;
  }

  static void jump() {
    if (!_initialised) return;
    FlameAudio.play('jump.wav', volume: 0.5);
  }

  static void death() {
    if (!_initialised) return;
    FlameAudio.play('death.wav', volume: 0.6);
  }

  static void score() {
    if (!_initialised) return;
    FlameAudio.play('score.wav', volume: 0.3);
  }

  static void milestone() {
    if (!_initialised) return;
    FlameAudio.play('milestone.wav', volume: 0.5);
  }
}
