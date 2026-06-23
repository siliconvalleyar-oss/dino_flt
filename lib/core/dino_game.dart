import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/entities/dino.dart';
import 'package:behabior/core/entities/obstacle.dart';
import 'package:behabior/core/entities/ground.dart';
import 'package:behabior/core/entities/cloud.dart';
import 'package:behabior/core/systems/score_system.dart';
import 'package:behabior/core/systems/audio_system.dart';

class DinoGame extends FlameGame {
  late Dino _dino;
  late Ground _ground;
  late ScoreSystem _scoreSystem;
  final List<Obstacle> _obstacles = [];
  final List<Cloud> _clouds = [];
  double _spawnTimer = 0;
  bool _gameOver = false;
  bool _started = false;
  final Random _random = Random();
  bool _initialised = false;
  int _lastMilestone = 0;

  bool get gameStarted => _started;
  bool get gameOver => _gameOver;
  ScoreSystem get scoreSystem => _scoreSystem;

  @override
  Color backgroundColor() => const Color(0xFFF7F7F7);

  @override
  Future<void> onLoad() async {
    if (_initialised) return;
    _initialised = true;
    _scoreSystem = ScoreSystem();
    _ground = Ground();
    add(_ground);
    _dino = Dino();
    add(_dino);
    _spawnCloud();
  }

  void _spawnCloud() {
    final cloud = Cloud(speed: _scoreSystem.speed);
    _clouds.add(cloud);
    add(cloud);
  }

  void _spawnObstacle() {
    final obstacle = Obstacle.random(_scoreSystem.speed);
    _obstacles.add(obstacle);
    add(obstacle);
  }

  void handleTap() {
    if (!_initialised) return;
    if (!_started) {
      startGame();
      return;
    }
    if (_gameOver) {
      startGame();
      return;
    }
    _dino.jump();
    AudioSystem.jump();
  }

  void handleRelease() {
    if (!_initialised || !_started || _gameOver) return;
    _dino.releaseJump();
  }

  void startGame() {
    _started = true;
    _gameOver = false;
    _scoreSystem.reset();
    _obstacles.clear();
    _clouds.clear();
    _spawnTimer = 1.5;
    _lastMilestone = 0;
    removeAll(children);

    _ground = Ground();
    _dino = Dino();
    add(_ground);
    add(_dino);
    _spawnCloud();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_initialised || !_started || _gameOver) return;

    _scoreSystem.update(dt);
    _ground.scroll(_scoreSystem.speed, dt);
    _dino.updatePhysics(dt);

    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnTimer = _random.nextDouble() * (GameConfig.obstacleSpawnMax - GameConfig.obstacleSpawnMin) +
          GameConfig.obstacleSpawnMin;
      _spawnObstacle();
    }

    for (final o in _obstacles) {
      o.move(_scoreSystem.speed, dt);
    }
    _obstacles.removeWhere((o) {
      if (o.isOffScreen) {
        o.removeFromParent();
        return true;
      }
      return false;
    });

    for (final c in _clouds) {
      c.move(_scoreSystem.speed, dt);
    }
    _clouds.removeWhere((c) {
      if (c.isOffScreen) {
        c.removeFromParent();
        return true;
      }
      return false;
    });

    if (_clouds.length < 3 && _random.nextDouble() < 0.008) {
      _spawnCloud();
    }

    _checkCollisions();

    for (final o in _obstacles) {
      if (!o.passed && o.x + o.width < GameConfig.dinoX) {
        o.passed = true;
        _scoreSystem.score += 10;
        AudioSystem.score();
        final currentMilestone = _scoreSystem.score ~/ 100;
        if (currentMilestone > _lastMilestone) {
          _lastMilestone = currentMilestone;
          AudioSystem.milestone();
        }
      }
    }
  }

  void _checkCollisions() {
    final dinoBox = Rect.fromLTWH(
      _dino.x + 14,
      _dino.y + 10,
      _dino.width - 28,
      _dino.height - 20,
    );

    for (final o in _obstacles) {
      final obsBox = Rect.fromLTWH(
        o.x + 8,
        o.y + 8,
        o.width - 16,
        o.height - 16,
      );
      if (dinoBox.overlaps(obsBox)) {
        _gameOver = true;
        _dino.die();
        _scoreSystem.checkHighScore();
        AudioSystem.death();
        break;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (!_initialised) return;

    final textStyle = TextStyle(
      fontSize: 22,
      color: const Color(0xFF535353),
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
    );

    if (_started) {
      if (_scoreSystem.highScore > 0) {
        final hi = TextPainter(
          text: TextSpan(text: 'HI ${_scoreSystem.highScore.toString().padLeft(5, '0')}', style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        hi.paint(canvas, Offset(size.x - hi.width - 10, 14));
      }
      final score = TextPainter(
        text: TextSpan(text: _scoreSystem.score.toString().padLeft(5, '0'), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      score.paint(canvas, Offset(size.x - score.width - 10, 42));
    }

    if (!_started) {
      final tap = TextPainter(
        text: TextSpan(text: 'TAP TO START', style: textStyle.copyWith(fontSize: 26)),
        textDirection: TextDirection.ltr,
      )..layout();
      tap.paint(canvas, Offset((size.x - tap.width) / 2, (size.y - tap.height) / 2 + 20));
    }

    if (_gameOver) {
      final go = TextPainter(
        text: TextSpan(text: 'GAME OVER', style: textStyle.copyWith(fontSize: 30)),
        textDirection: TextDirection.ltr,
      )..layout();
      final goY = (GameConfig.groundY + size.y) / 2 - go.height / 2;
      go.paint(canvas, Offset((size.x - go.width) / 2, goY));

      final restart = TextPainter(
        text: TextSpan(text: 'TAP TO RESTART', style: textStyle.copyWith(fontSize: 20)),
        textDirection: TextDirection.ltr,
      )..layout();
      restart.paint(canvas, Offset((size.x - restart.width) / 2, goY + go.height + 14));
    }
  }
}
