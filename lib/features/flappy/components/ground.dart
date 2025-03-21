import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/core/managers/game_speed_manager.dart';
import '../../../core/config/game_constants.dart';
import '../views/flappy_bird_game.dart';

class Ground extends SpriteComponent
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Ground() : super();

  @override
  FutureOr<void> onLoad() async {
    position = Vector2(0, gameRef.size.y - GameConstants.groundHeight);
    size = Vector2(2 * gameRef.size.x, GameConstants.groundHeight);
    sprite = await Sprite.load("base.png");
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
