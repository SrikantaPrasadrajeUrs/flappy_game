import 'dart:async' as async;
import 'package:flame/components.dart';
import '../constants.dart';

class Background extends SpriteComponent{
  Background(Vector2 size):super(size: size, position: Vector2(0, 0));
  late Sprite bgNight;
  late Sprite bgDay;
  bool turns = false;


  @override
  async.FutureOr<void> onLoad() async{
    bgDay = await Sprite.load("background-day.png");
    bgNight = await Sprite.load("background-night.png");
    sprite = bgDay;
    async.Timer.periodic(const Duration(seconds: backgroundChangeInterval), (timer) {
      sprite = turns?bgDay:bgNight;
      turns = !turns;
    });
  }
}