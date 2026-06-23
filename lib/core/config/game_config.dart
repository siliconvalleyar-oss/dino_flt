class GameConfig {
  GameConfig._();

  static const String gameName = 'Dino Run';

  static const double viewportWidth = 900;
  static const double viewportHeight = 400;
  static const double worldWidth = 900;
  static const double worldHeight = 400;

  static const double groundY = 340;
  static const double dinoX = 80;

  static const double jumpVelocity = -15;
  static const double gravity = 0.6;

  static const double initialSpeed = 6.0;
  static const double maxSpeed = 18.0;

  static const double obstacleSpawnMin = 1.2;
  static const double obstacleSpawnMax = 3.0;
}
