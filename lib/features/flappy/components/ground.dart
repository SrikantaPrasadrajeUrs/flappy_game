import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/core/managers/game_speed_manager.dart';
import '../../../core/config/game_constants.dart';
import '../../../core/resources/game_assets.dart';
import '../views/flappy_bird_game.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Ground() : super();

  static Future<void> initGround() async {
    GameAssets.base = await Sprite.load("base.png");
  }

  @override
  FutureOr<void> onLoad() async {
    position = Vector2(0, gameRef.size.y - GameConstants.groundHeight);
    size = Vector2(2 * gameRef.size.x, GameConstants.groundHeight);
    sprite = GameAssets.base;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= GameSpeedManager.groundSpeed * dt;
    if ((position.x + size.x / 2) <= 0) {
      position.x = 0;
    }
  }
}
