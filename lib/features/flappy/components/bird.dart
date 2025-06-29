import 'dart:async' as async;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/core/config/game_constants.dart';
import 'package:flappy/core/managers/audio_manager.dart';
import 'package:flappy/core/managers/game_speed_manager.dart';
import 'package:flappy/core/resources/game_assets.dart';
import 'package:flappy/features/flappy/components/pipe_trap.dart';
import '../views/flappy_bird_game.dart';
import 'flappy_components.dart';

class Bird extends SpriteComponent with CollisionCallbacks{
  final int birdType;
  late Sprite midFlapSprite;
  late Sprite upFlapSprite;
  late Sprite downFlapSprite;

  double animationTimer = 0;
  int animationFrame = 0;

  bool isYellowBird  = false;
  Bird({required this.birdType}):super(position: Vector2(GameConstants.birdStartX, GameConstants.birdStartY), size: Vector2(GameConstants.birdWidth, GameConstants.birdWidth));

  double velocity =0;

  DateTime? _lastFlapTime;
  double currentJumpStrength = GameSpeedManager.jumpStrength;

  static Future<void> initBirds()async{
    GameAssets.blueBirdMidFlap = await Sprite.load("bluebird-midflap.png");
    GameAssets.blueBirdUpFlap = await Sprite.load("bluebird-upflap.png");
    GameAssets.blueBirdDownFlap = await Sprite.load("bluebird-downflap.png");

    GameAssets.yellowBirdMidFlap = await Sprite.load("yellowbird-midflap.png");
    GameAssets.yellowBirdUpFlap = await Sprite.load("yellowbird-upflap.png");
    GameAssets.yellowBirdDownFlap = await Sprite.load("yellowbird-downflap.png");
  }

  @override
  async.FutureOr<void> onLoad() async{
    await _loadSprites();
    add(RectangleHitbox());
  }

  Future<void> _loadSprites() async {
    if(birdType==1){
      midFlapSprite = GameAssets.blueBirdMidFlap;
      upFlapSprite = GameAssets.blueBirdUpFlap;
      downFlapSprite = GameAssets.blueBirdDownFlap;
    }else{
      midFlapSprite = GameAssets.yellowBirdMidFlap;
      upFlapSprite = GameAssets.yellowBirdUpFlap;
      downFlapSprite = GameAssets.yellowBirdDownFlap;
    }
    sprite = midFlapSprite;
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
    velocity +=GameConstants.gravity*dt;
    position.y +=velocity*dt;
    animationTimer += dt * (velocity < 0 ? 12 : 6);

    if (animationTimer >= 1) {
      animationTimer = 0;
      animationFrame = (animationFrame + 1) % 3;
    }

    switch (animationFrame) {
      case 0:
        sprite = midFlapSprite;
        break;
      case 1:
        sprite = upFlapSprite;
        break;
      case 2:
        sprite = downFlapSprite;
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other)async{
    super.onCollision(intersectionPoints, other);
    if(other is Ground||other is Pipe||other is PipeTrap){
      (parent as FlappyBirdGame).gameOver();
      AudioManager.playAudio("trap_hit.mp3",volume: 2);

    }
  }
}