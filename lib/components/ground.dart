
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/game.dart';

import '../constants.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBirdGame>,CollisionCallbacks{
  Ground():super();

  @override
  FutureOr<void> onLoad() async{
    position = Vector2(0, gameRef.size.y-200);
    size = Vector2(2*gameRef.size.x, groundHeight);
    sprite = await Sprite.load("base.png");
    add(RectangleHitbox());
  }

  @override
  void update(double dt){
    position.x -=groundScrollingSpeed*dt;
    if((position.x+size.x/2)<=0){
     position.x = 0;
    }
  }
}