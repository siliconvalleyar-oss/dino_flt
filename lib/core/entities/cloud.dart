import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class Cloud extends PositionComponent {
  final double _speed;
  final double _w;
  final double _h;

  Cloud({required double speed})
      : _speed = speed * 0.15,
        _w = 50 + Random().nextDouble() * 30,
        _h = 16 + Random().nextDouble() * 8,
        super() {
    final rand = Random();
    x = 900 + rand.nextDouble() * 150;
    y = 20 + rand.nextDouble() * 50;
    size = Vector2(_w, _h);
  }

  void move(double speed, double dt) {
    x -= _speed * dt * 60;
  }

  bool get isOffScreen => x < -100;

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC).withAlpha(120);
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(0, 0, _w, _h), _h / 2, _h / 2),
      paint,
    );
    canvas.drawCircle(Offset(_w * 0.3, _h * 0.5), _h * 0.6, paint);
    canvas.drawCircle(Offset(_w * 0.7, _h * 0.5), _h * 0.5, paint);
  }
}
