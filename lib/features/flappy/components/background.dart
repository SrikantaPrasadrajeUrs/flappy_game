import 'dart:async' as async;
import 'package:flame/components.dart';
import 'package:flappy/core/resources/game_assets.dart';
import '../../../core/config/game_constants.dart';


class Background extends SpriteComponent{
  Background(Vector2 size):super(size: size, position: Vector2(0, 0));
  bool turns = false;

  static Future<void> initBackground()async{
    GameAssets.backgroundDay = await Sprite.load("background-day.png");
    GameAssets.backgroundNight = await Sprite.load("background-night.png");
  }

  @override
  async.FutureOr<void> onLoad() async{
    sprite = GameAssets.backgroundDay;
    async.Timer.periodic(const Duration(seconds: GameConstants.backgroundChangeInterval), (timer) {
      sprite = turns?GameAssets.backgroundDay:GameAssets.backgroundNight;
      turns = !turns;
    });
  }
}