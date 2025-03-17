import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/components/pipe.dart';
import 'package:flappy/constants.dart';
import 'package:flappy/game.dart';

import 'ground.dart';

class Bird extends SpriteComponent with CollisionCallbacks{
  Bird():super(position: Vector2(birdStartX, birdStartY), size: Vector2(birdWidth, birdWidth));

  double velocity =0;

  @override
  FutureOr<void> onLoad() async{
    sprite = await Sprite.load("bluebird-upflap.png");
    add(RectangleHitbox());
  }

  void flap(){
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    velocity +=gravity*dt;
    position.y +=velocity*dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);
    if(other is Ground||other is Pipe){
      (parent as FlappyBirdGame).gameOver();
    }

  }
}