import 'dart:async';
import 'dart:developer';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy/components/background.dart';
import 'package:flappy/components/bird.dart';
import 'package:flappy/components/ground.dart';
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Game Over",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap to play again",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        restartGame();
                      },
                      child: Text("Play Again"),
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

  void removeChildren() {

  }

  void restartGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    isGameOver = false;
    pipeManager.pipeSpawnTimer = 0;
    removeChildren();
    onLoad();
    resumeEngine();
  }
}
