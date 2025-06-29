import 'package:flame_audio/flame_audio.dart';

class GameConstants {
  // Bird properties
  static const double birdStartX = 100;
  static const double birdStartY = 100;
  static const double birdWidth = 40;
  static const double gravity = 340;
  static const double jumpStrength = -250;

  // Background & Environment
  static const int backgroundChangeInterval = 10;
  static const double groundHeight = 200;
  static const double groundScrollingSpeed = 100;

  static const double maxPipGap = 270;
  static const double minPipeGap = 300;
  static const double minPipeHeight = 100;
  static const double pipeWidth = 60;

  static const Map<String,AudioPlayer> audioCache = {};
}
