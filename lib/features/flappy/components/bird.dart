import 'dart:async' as async;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/constants.dart';
import 'package:flappy/core/managers/game_speed_manager.dart';
import '../views/flappy_bird_game.dart';
import 'flappy_components.dart';

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

  bool isYellowBird  = false;
  Bird():super(position: Vector2(birdStartX, birdStartY), size: Vector2(birdWidth, birdWidth));

  double velocity =0;

  DateTime? _lastFlapTime;
  double currentJumpStrength = GameSpeedManager.jumpStrength;

  @override
  async.FutureOr<void> onLoad() async{
    await _loadSprites();
    _setBlueBird();
    add(RectangleHitbox());
    async.Timer.periodic(const Duration(seconds: backgroundChangeInterval), (timer) {
     _toggleBirdColor();
    });
  }

  Future<void> _loadSprites() async {
    yMidFlapSprite = await Sprite.load("yellowbird-midflap.png");
    yUpFlapSprite = await Sprite.load("yellowbird-upflap.png");
    yDownFlapSprite = await Sprite.load("yellowbird-downflap.png");
    bMidFlapSprite = await Sprite.load("bluebird-midflap.png");
    bUpFlapSprite = await Sprite.load("bluebird-upflap.png");
    bDownFlapSprite = await Sprite.load("bluebird-downflap.png");
  }

  void _setBlueBird() {
    midFlapSprite = bMidFlapSprite;
    upFlapSprite = bUpFlapSprite;
    downFlapSprite = bDownFlapSprite;
    sprite = midFlapSprite;
  }

  void _setYellowBird() {
    midFlapSprite = yMidFlapSprite;
    upFlapSprite = yUpFlapSprite;
    downFlapSprite = yDownFlapSprite;
    sprite = midFlapSprite;
  }

  void _toggleBirdColor() {
    isYellowBird = !isYellowBird;
    isYellowBird ? _setYellowBird() : _setBlueBird();
  }

  void flap()async{
    final now = DateTime.now();
    if(_lastFlapTime!=null){
      int diff = now.difference(_lastFlapTime!).inMilliseconds;
      if(diff<=200){
        currentJumpStrength = currentJumpStrength*1.3;
      }else if(diff>200&&diff<=500){
        currentJumpStrength = currentJumpStrength*1.2;
      }else{
        currentJumpStrength = GameSpeedManager.jumpStrength;
      }
    }else{
      currentJumpStrength = GameSpeedManager.jumpStrength;
    }

    if(currentJumpStrength>GameSpeedManager.jumpStrength*1.5){
      currentJumpStrength = GameSpeedManager.jumpStrength;
    }
    _lastFlapTime = DateTime.now();
    velocity = currentJumpStrength;

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