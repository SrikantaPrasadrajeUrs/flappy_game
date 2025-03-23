import 'dart:developer';
import '../config/game_constants.dart';

class GameSpeedManager {
  static double jumpStrength = GameConstants.jumpStrength;
  static double groundSpeed = GameConstants.groundScrollingSpeed;
  static double pipeSpeed = GameConstants.groundScrollingSpeed;
  static const double speedIncrease = 30;

  static void increaseSpeed() {
    groundSpeed += speedIncrease;
    pipeSpeed += speedIncrease;
    jumpStrength-=speedIncrease/3.2;
    log("Ground Speed: $groundSpeed, Pipe Speed: $pipeSpeed");
  }

  static void resetSpeed() {
    jumpStrength = GameConstants.jumpStrength;
    groundSpeed = GameConstants.groundScrollingSpeed;
    pipeSpeed = GameConstants.groundScrollingSpeed;
  }


}
