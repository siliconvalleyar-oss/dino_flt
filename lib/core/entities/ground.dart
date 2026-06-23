import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

class Ground extends PositionComponent {
  double _scrollOffset = 0;

  Ground() : super(size: Vector2(GameConfig.worldWidth, 30));

  @override
  Future<void> onLoad() async {
    y = GameConfig.groundY;
  }

  void scroll(double speed, double dt) {
    _scrollOffset = (_scrollOffset + speed * dt * 60) % 24;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF535353);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 3), paint);

    paint.color = const Color(0xFFCCCCCC);
    for (double x = -_scrollOffset; x < size.x; x += 24) {
      canvas.drawRect(Rect.fromLTWH(x, 8, 4, 2), paint);
      canvas.drawRect(Rect.fromLTWH(x + 12, 16, 3, 2), paint);
      canvas.drawRect(Rect.fromLTWH(x + 6, 24, 2, 2), paint);
    }
  }
}
