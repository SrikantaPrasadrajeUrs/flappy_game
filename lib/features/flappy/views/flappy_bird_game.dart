import 'dart:async';
import 'dart:developer';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy/core/config/game_constants.dart';
import 'package:flutter/material.dart';
import 'package:flappy/features/flappy/components/flappy_components.dart';

import '../../../core/managers/game_speed_manager.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  bool isGameOver = false;
  Timer? _speedIncreaseTimer;
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;

  @override
  FutureOr<void> onLoad() {
    bird = Bird();
    background = Background(size);
    ground = Ground();
    pipeManager = PipeManager();
    addAll([background,bird, ground, pipeManager]);
    _speedIncreaseTimer = Timer.periodic(const Duration(seconds: 10), (_)=> GameSpeedManager.increaseSpeed());
    return super.onLoad();
  }

  @override
  void onTap(){
    bird.flap();
    // on top reach
    if(bird.position.y<=0){
      gameOver();
    }
  }

  void gameOver() {
    if (isGameOver) return;
    log("gameOver");
    isGameOver = true;
    pauseEngine();
    _speedIncreaseTimer?.cancel();
    showDialog(
      barrierDismissible: false,
      context: buildContext!,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Game Over",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      "Tap to play again",
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        restartGame(context);
                      },
                      child: const Text("Play Again"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void removeAllPipes(){
    for (var pipe in children.whereType<Pipe>()) {
      pipe.removeFromParent();
    }
  }

  void restartGame(BuildContext context) {
    _speedIncreaseTimer = Timer.periodic(const Duration(seconds: 10), (_)=> GameSpeedManager.increaseSpeed());
    bird.position = Vector2(GameConstants.birdStartX, GameConstants.birdStartY);
    bird.velocity = 0;
    isGameOver = false;
    removeAllPipes();
    pipeManager.pipeSpawnTimer = 0;
    resumeEngine();
    GameSpeedManager.resetSpeed();
    Navigator.of(context).pop();
  }
}
