import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/core/managers/game_speed_manager.dart';
import '../views/flappy_bird_game.dart';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef<FlappyBirdGame>{
 final bool isBottomPipe;
  Pipe(Vector2 position,Vector2 size,{required this.isBottomPipe}):super(size: size, position: position);

  @override
  FutureOr<void> onLoad() async{
    sprite = await Sprite.load(isBottomPipe?"pipe-green_up.png":"pipe-green_down.png");
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -=GameSpeedManager.pipeSpeed*dt;
    if(position.x+size.x<0){
     removeFromParent();
    }
  }

  @override
  void onRemove(){
    super.onRemove();
    children.whereType<RectangleHitbox>().forEach((hitbox) {
      hitbox.removeFromParent();
    });
  }
}