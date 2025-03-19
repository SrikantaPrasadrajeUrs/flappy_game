import 'dart:async' as async;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/components/pipe.dart';
import 'package:flappy/constants.dart';
import '../flappy_bird_game.dart';

import 'ground.dart';

class Bird extends SpriteComponent with CollisionCallbacks{
  late Sprite bMidFlapSprite;
  late Sprite bUpFlapSprite;
  late Sprite bDownFlapSprite;
  late Sprite yMidFlapSprite;
  late Sprite yUpFlapSprite;
  late Sprite yDownFlapSprite;

  late Sprite midFlapSprite;
  late Sprite upFlapSprite;
  late Sprite downFlapSprite;

  bool turns  = false;
  Bird():super(position: Vector2(birdStartX, birdStartY), size: Vector2(birdWidth, birdWidth));

  double velocity =0;

  void loadSprites()async{
    yMidFlapSprite = await Sprite.load("yellowbird-midflap.png");
    yUpFlapSprite = await Sprite.load("yellowbird-upflap.png");
    yDownFlapSprite = await Sprite.load("yellowbird-downflap.png");
    bMidFlapSprite = await Sprite.load("bluebird-midflap.png");
    bUpFlapSprite = await Sprite.load("bluebird-upflap.png");
    bDownFlapSprite = await Sprite.load("bluebird-downflap.png");
  }

  @override
  async.FutureOr<void> onLoad() async{
    midFlapSprite = await Sprite.load("bluebird-midflap.png");
    upFlapSprite = await Sprite.load("bluebird-upflap.png");
    downFlapSprite = await Sprite.load("bluebird-downflap.png");
    loadSprites();
    sprite = midFlapSprite;
    add(RectangleHitbox());
    async.Timer.periodic(const Duration(seconds: backgroundChangeInterval), (timer) {
      midFlapSprite = turns?yMidFlapSprite:bMidFlapSprite;
      upFlapSprite = turns?yUpFlapSprite:bUpFlapSprite;
      downFlapSprite = turns?yDownFlapSprite:bDownFlapSprite;
      sprite = midFlapSprite;
      turns = !turns;
    });
  }

  void flap()async{
    velocity = jumpStrength;
  }

  @override
  void update(double dt){
    velocity +=gravity*dt;
    position.y +=velocity*dt;
    if (velocity < 0) {
      sprite = downFlapSprite;
    } else if (velocity>0) {
      sprite = upFlapSprite;
    } else {
      sprite = midFlapSprite;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);
    if(other is Ground||other is Pipe){
      (parent as FlappyBirdGame).gameOver();
    }
  }
}