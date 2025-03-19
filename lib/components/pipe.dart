import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../flappy_bird_game.dart';
import '../constants.dart';

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
    position.x -=groundScrollingSpeed*dt;
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