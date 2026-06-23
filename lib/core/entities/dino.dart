import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

enum DinoState { running, jumping, dead }

class Dino extends PositionComponent {
  DinoState dinoState = DinoState.running;
  double velocityY = 0;
  int _frameIndex = 0;
  double _frameTimer = 0;
  bool _jumpHeld = false;
  double _holdTime = 0;

  bool _useSprites = false;
  Sprite? _f0;
  Sprite? _f1;
  Sprite? _f2;
  Sprite? _f3;
  final List<Vector2> _spriteSizes = [];

  Dino() : super(size: Vector2(68, 72));

  @override
  Future<void> onLoad() async {
    try {
      _f0 = await Sprite.load('dino/dino_run_00.png');
      _f1 = await Sprite.load('dino/dino_run_01.png');
      _f2 = await Sprite.load('dino/dino_run_02.png');
      _f3 = await Sprite.load('dino/dino_run_03.png');
      _useSprites = true;
      for (final s in [_f0, _f1, _f2, _f3]) {
        if (s != null) {
          _spriteSizes.add(s.srcSize.clone());
        }
      }
      double maxW = 68;
      double maxH = 72;
      for (final v in _spriteSizes) {
        if (v.x > maxW) maxW = v.x;
        if (v.y > maxH) maxH = v.y;
      }
      size.setValues(maxW, maxH);
    } catch (_) {
      _useSprites = false;
    }
    x = GameConfig.dinoX;
    y = GameConfig.groundY - height;
  }

  void jump() {
    if (dinoState != DinoState.running) return;
    dinoState = DinoState.jumping;
    velocityY = GameConfig.jumpVelocity;
    _jumpHeld = true;
    _holdTime = 0;
  }

  void releaseJump() {
    _jumpHeld = false;
  }

  void die() {
    dinoState = DinoState.dead;
  }

  void updatePhysics(double dt) {
    if (dinoState == DinoState.dead) return;

    if (dinoState == DinoState.jumping) {
      velocityY += GameConfig.gravity;
      y += velocityY;
      if (_jumpHeld) {
        _holdTime += dt;
        if (_holdTime > 0.2) {
          velocityY += GameConfig.gravity * 0.3;
        }
      }
      if (y >= GameConfig.groundY - height) {
        y = GameConfig.groundY - height;
        velocityY = 0;
        dinoState = DinoState.running;
      }
    }

    if (dinoState == DinoState.running) {
      _frameTimer += dt * 10;
      if (_frameTimer >= 1) {
        _frameTimer = 0;
        _frameIndex = (_frameIndex + 1) % 4;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_useSprites) {
      _renderSprites(canvas);
    } else {
      _renderFallback(canvas);
    }
  }

  void _renderSprites(Canvas canvas) {
    Sprite? sprite;
    if (dinoState == DinoState.dead || dinoState == DinoState.jumping) {
      sprite = _f0;
    } else {
      sprite = [_f0, _f1, _f2, _f3][_frameIndex];
    }
    if (sprite != null) {
      final srcSize = sprite.srcSize;
      sprite.render(canvas, size: srcSize);
    } else {
      _renderFallback(canvas);
    }
  }

  void _renderFallback(Canvas canvas) {
    final paint = Paint();
    paint.color = const Color(0xFF535353);
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(4, 4, 60, 64), 6, 6),
      paint,
    );
    paint.color = const Color(0xFF6B6B6B);
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(4, 4, 60, 30), 6, 4),
      paint,
    );
    paint.color = const Color(0xFF222222);
    canvas.drawCircle(const Offset(50, 20), 4, paint);
    paint.color = const Color(0xFFFFFFFF);
    canvas.drawCircle(const Offset(51, 19), 1.5, paint);
    paint.color = const Color(0xFF424242);
    canvas.drawRect(Rect.fromLTWH(6, 28, 10, 5), paint);

    if (dinoState == DinoState.dead) {
      paint.color = const Color(0xFFCC0000);
      canvas.drawCircle(const Offset(50, 20), 4, paint);
    }

    paint.color = const Color(0xFF535353);
    final legOff = (_frameIndex % 2 == 0) ? 0.0 : 4.0;
    canvas.drawRect(Rect.fromLTWH(18, 64, 8, 8), paint);
    canvas.drawRect(Rect.fromLTWH(40, 64 + legOff, 8, 8 - legOff), paint);
  }
}
