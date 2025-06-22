import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/core/managers/game_speed_manager.dart';
import 'package:flappy/core/resources/game_assets.dart';
import '../views/flappy_bird_game.dart';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef<FlappyBirdGame>{
 final bool isStaticPipe;
 final bool isBottomPipe;
  Pipe(Vector2 position,Vector2 size,{required this.isBottomPipe, required this.isStaticPipe}):super(size: size, position: position);

  static initPipes()async{
    GameAssets.pipeGreenUp = await Sprite.load("pipe-green_up.png");
    GameAssets.pipeGreenDown = await Sprite.load("pipe-green_down.png");
  }

  @override
  FutureOr<void> onLoad() async{
    sprite = isBottomPipe?GameAssets.pipeGreenUp:GameAssets.pipeGreenDown;
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
    children.whereType<RectangleHitbox>().forEach((hitBox) {
      hitBox.removeFromParent();
    });
  }
}