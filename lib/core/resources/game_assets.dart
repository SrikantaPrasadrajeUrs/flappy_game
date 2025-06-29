import 'dart:math';
import 'package:flame/components.dart' show Sprite;
import 'package:flappy/core/managers/audio_manager.dart';
import 'package:flappy/features/flappy/components/flappy_components.dart';
import '../../features/flappy/components/pipe_trap.dart';

class GameAssets {
  static final Random rand = Random();

  static late Sprite thornSprite;
  static late Sprite potSprite;
  static late Sprite zombieSprite;
  static late Sprite zombie2Sprite;

  static late Sprite pipeGreenUp;
  static late Sprite pipeGreenDown;
  static late Sprite pipeBrownUp;
  static late Sprite pipeBrownDown;

  static late Sprite backgroundDay;
  static late Sprite backgroundNight;

  static late Sprite base;

  static late Sprite blueBirdMidFlap;
  static late Sprite blueBirdUpFlap;
  static late Sprite blueBirdDownFlap;

  static late Sprite yellowBirdMidFlap;
  static late Sprite yellowBirdUpFlap;
  static late Sprite yellowBirdDownFlap;

  static String getTrapType(int index){
    return switch(index){
      0 => "trap_basic_sound.mp3",
      1 => "zombie.mp3",
      2 => "zombie1.mp3",
      _ => "zombie1.mp3",
    };
  }

  static Future<void> initGameAssets()async{
    Pipe.initPipes();
    Background.initBackground();
    PipeTrap.initTraps();
    Ground.initGround();
    Bird.initBirds();
    AudioManager.loadAudio();
  }
}