import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/core/managers/audio_manager.dart';
import 'package:flappy/features/flappy/components/pipe.dart';
import '../../../core/resources/game_assets.dart';
import '../views/flappy_bird_game.dart';

class PipeTrap extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks{

  final Pipe bottomPipe;
  PipeTrap({required Vector2 position, required this.bottomPipe}):super(size: Vector2(40, 70), position: position, priority: -1);

  bool isPopped = false;
  int trapType = 0;

  static initTraps()async{
    GameAssets.thornSprite = await Sprite.load("thorn.png");
    GameAssets.potSprite = await Sprite.load("pot.png");
    GameAssets.zombieSprite = await Sprite.load("zombie.png");
    GameAssets.zombie2Sprite = await Sprite.load("zombie2.png");
  }

  @override
  FutureOr<void> onLoad() async{
    trapType = GameAssets.rand.nextInt(4);
    sprite = switch (trapType) {
      0 => GameAssets.thornSprite,
      1 => GameAssets.potSprite,
      2 => GameAssets.zombieSprite,
      _ => GameAssets.zombie2Sprite,
    };
    add(RectangleHitbox());
  }

  @override
  void update(double dt){
    position.x = bottomPipe.position.x+size.x/2;
    final birdX = gameRef.bird.position.x;
    final trapX = position.x;
    if(!isPopped&&trapX - birdX<=150){
      // playTrapSound(trapType);
     position.y = bottomPipe.position.y - size.y;
     isPopped = true;
     priority = 1;
    }
    if (position.x + size.x < 0||bottomPipe.parent == null) {
      removeFromParent();
    }
  }

  void playTrapSound(int trapSoundType){
    AudioManager.playAudio(GameAssets.getTrapType(trapSoundType), volume: 3);
  }

  @override
  void onRemove(){
    super.onRemove();
    children.whereType<RectangleHitbox>().forEach((hitBox) => hitBox.removeFromParent());
  }
}