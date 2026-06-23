import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

enum ObstacleType { cactus, cactusDouble, pterodactyl }

class Obstacle extends PositionComponent {
  final ObstacleType type;
  bool passed = false;
  Sprite? _aveSprite;
  double _wingTimer = 0;
  final double _wingSpeed = 8;

  Obstacle({required this.type});

  factory Obstacle.random(double speed) {
    final rand = Random();
    final types = [
      ObstacleType.cactus,
      ObstacleType.cactus,
      ObstacleType.cactusDouble,
      if (speed > 8) ObstacleType.pterodactyl,
      if (speed > 11) ObstacleType.pterodactyl,
    ];
    return Obstacle(type: types[rand.nextInt(types.length)]);
  }

  @override
  Future<void> onLoad() async {
    switch (type) {
      case ObstacleType.cactus:
        size.setValues(28, 56);
        break;
      case ObstacleType.cactusDouble:
        size.setValues(52, 56);
        break;
      case ObstacleType.pterodactyl:
        size.setValues(60, 40);
        try {
          _aveSprite = await Sprite.load('dino/ave.png');
        } catch (_) {
          _aveSprite = null;
        }
        break;
    }
    y = GameConfig.groundY - height;
    if (type == ObstacleType.pterodactyl) {
      y -= 20 + Random().nextDouble() * 30;
    }
    x = GameConfig.worldWidth + 50;
  }

  void move(double speed, double dt) {
    x -= speed * dt * 60;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (type == ObstacleType.pterodactyl) {
      _wingTimer += dt;
    }
  }

  bool get isOffScreen => x < -100;

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    switch (type) {
      case ObstacleType.cactus:
        paint.color = const Color(0xFF4CAF50);
        canvas.drawRRect(
          RRect.fromRectXY(Rect.fromLTWH(2, 0, 24, 56), 4, 4),
          paint,
        );
        paint.color = const Color(0xFF388E3C);
        canvas.drawRect(Rect.fromLTWH(4, 12, 20, 3), paint);
        canvas.drawRect(Rect.fromLTWH(4, 28, 20, 3), paint);
        paint.color = const Color(0xFF66BB6A);
        canvas.drawRect(Rect.fromLTWH(0, 16, 6, 5), paint);
        canvas.drawRect(Rect.fromLTWH(22, 32, 6, 5), paint);

      case ObstacleType.cactusDouble:
        paint.color = const Color(0xFF388E3C);
        canvas.drawRRect(
          RRect.fromRectXY(Rect.fromLTWH(2, 0, 22, 56), 4, 4),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectXY(Rect.fromLTWH(28, 0, 22, 50), 4, 4),
          paint,
        );
        paint.color = const Color(0xFF2E7D32);
        canvas.drawRect(Rect.fromLTWH(4, 12, 18, 3), paint);
        canvas.drawRect(Rect.fromLTWH(4, 28, 18, 3), paint);
        canvas.drawRect(Rect.fromLTWH(30, 10, 18, 3), paint);
        canvas.drawRect(Rect.fromLTWH(30, 26, 18, 3), paint);
        paint.color = const Color(0xFF66BB6A);
        canvas.drawRect(Rect.fromLTWH(0, 16, 6, 5), paint);
        canvas.drawRect(Rect.fromLTWH(24, 32, 6, 5), paint);

      case ObstacleType.pterodactyl:
        final wingScale = 1.0 + sin(_wingTimer * _wingSpeed) * 0.25;
        final drawH = size.y * wingScale;
        final drawY = (size.y - drawH) / 2;
        if (_aveSprite != null) {
          canvas.save();
          canvas.translate(0, drawY);
          _aveSprite!.render(canvas, size: Vector2(size.x, drawH));
          canvas.restore();
        } else {
          paint.color = const Color(0xFF757575);
          canvas.drawRRect(
            RRect.fromRectXY(Rect.fromLTWH(0, 6, 60, 28), 6, 6),
            paint,
          );
          paint.color = const Color(0xFF9E9E9E);
          canvas.drawRect(Rect.fromLTWH(2, 6, 56, 28), paint);

          final wingUp = (DateTime.now().millisecondsSinceEpoch ~/ 200).isEven;
          final wingPath = Path();
          if (wingUp) {
            wingPath.moveTo(12, 6);
            wingPath.lineTo(26, -12);
            wingPath.lineTo(38, 6);
          } else {
            wingPath.moveTo(12, 6);
            wingPath.lineTo(26, -4);
            wingPath.lineTo(38, 6);
          }
          wingPath.close();
          paint.color = const Color(0xFF9E9E9E);
          canvas.drawPath(wingPath, paint);

          paint.color = const Color(0xFFFFCC00);
          canvas.drawCircle(const Offset(8, 16), 3, paint);
          paint.color = const Color(0xFF222222);
          canvas.drawCircle(const Offset(8, 16), 1.5, paint);

          paint.color = const Color(0xFFFF6600);
          final beak = Path()
            ..moveTo(0, 16)
            ..lineTo(-6, 14)
            ..lineTo(-6, 18)
            ..close();
          canvas.drawPath(beak, paint);
        }
    }
  }
}
