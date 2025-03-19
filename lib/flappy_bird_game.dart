import 'dart:async';
import 'dart:developer';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy/components/background.dart';
import 'package:flappy/components/bird.dart';
import 'package:flappy/components/ground.dart';
import 'components/pipe.dart';
import 'package:flappy/components/pipe_manager.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  bool isGameOver = false;
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
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Column(
                  spacing: 10,
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
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    isGameOver = false;
    removeAllPipes();
    pipeManager.pipeSpawnTimer = 0;
    resumeEngine();
    Navigator.of(context).pop();
  }
}
