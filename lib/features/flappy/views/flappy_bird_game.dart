import 'dart:async' as async;
import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy/core/config/game_constants.dart';
import 'package:flappy/features/flappy/flappy_bloc/flappy_bloc.dart';
import 'package:flappy/features/flappy/views/flappy_home.dart';
import 'package:flutter/material.dart';
import 'package:flappy/features/flappy/components/flappy_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/managers/game_speed_manager.dart';
import '../../../core/utils/utility_methods.dart';
import '../components/game_over_dialog.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  final int birdType;
  String _highScore = "00:00";
  final FlappyBloc flappyBloc;
  bool isGameOver = false;
  async.Timer? _speedIncreaseTimer;
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late TextComponent textComponent;
  late TextComponent survivalTimerText;
  late DateTime _startTime;
  Duration _elapsedTime = Duration.zero;
  async.Timer? _gameTimer;

  FlappyBirdGame({required String highScore, required this.flappyBloc, required this.birdType}):_highScore = highScore;

  @override
  async.FutureOr<void> onLoad() async{
    bird = Bird(birdType: birdType);
    background = Background(size);
    ground = Ground();
    pipeManager = PipeManager();
    // ----------------------------
    textComponent = TextComponent(
      text: "High Score: $_highScore",
      position: Vector2(170, size.y-30),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(blurRadius: 5, color: Colors.black, offset: Offset(2, 2))
          ],
        ),
      ),
    );

    // ----------------------------
    survivalTimerText = TextComponent(
      text: "Time: 00:00",
      position: Vector2(size.x, 50),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
          shadows: [
            Shadow(blurRadius: 5, color: Colors.black, offset: Offset(2, 2))
          ],
        ),
      ),
    );
    addAll([background, bird, ground, pipeManager, textComponent, survivalTimerText]);
    _speedIncreaseTimer = async.Timer.periodic(const Duration(seconds: 10), (_)=> GameSpeedManager.increaseSpeed());
    startGameTimer();
    return super.onLoad();
  }

  void startGameTimer(){
    _startTime = DateTime.now();
    _gameTimer?.cancel();
    _gameTimer = async.Timer.periodic(const Duration(milliseconds: 100),(timer){
      if(isGameOver){
        timer.cancel();
        survivalTimerText.text = "Time: 00:00";
        return;
      }
      _elapsedTime = DateTime.now().difference(_startTime);
      survivalTimerText.text = _formatElapsedTimer(_elapsedTime);
    });
  }

  String _formatElapsedTimer(Duration time){
    int min = time.inMinutes;
    int sec = time.inSeconds % 60;
    return "Time: ${min.toString().padLeft(2,"0")}:${sec.toString().padLeft(2,"0")}";
  }

  @override
  void onTap(){
    bird.flap();
    // on top touch
    if(bird.position.y<=0){
      gameOver();
    }
  }

  void gameOver() {
    if (isGameOver) return;
    resetFields();
    log("gameOver");
    isGameOver = true;
    pauseEngine();
    checkHighScore();
    removeAllPipes();
    showGameOverDialog(buildContext!);
  }

  void checkHighScore(){
    List<String> highScoreParts = _highScore.split(":");
    int highScoreMin = int.parse(highScoreParts[0]);
    int highScoreSec = int.parse(highScoreParts[1]);
    List<String> currentScoreParts = survivalTimerText.text.split(":");
    int currentScoreMin = int.parse(currentScoreParts[1]);
    int currentScoreSec = int.parse(currentScoreParts[2]);
    if(highScoreMin<currentScoreMin||(highScoreMin==currentScoreMin&&highScoreSec<currentScoreSec)){
      _highScore = "${currentScoreMin<10?"0":""}$currentScoreMin:${currentScoreSec<10?"0":""}$currentScoreSec";
      textComponent.text = "High Score: $_highScore";
      flappyBloc.storeHighScore(_highScore);
    }
  }

  void showGameOverDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => GameOverDialog(
        survivalTime: survivalTimerText.text,
        onRestart: () => restartGame(context),
        onExit: () {
          removeAll(children);
          overlays.clear();
          resetFields();
          navigateTo(child: BlocProvider.value(
              value: FlappyBloc(),
              child: const FlappyHome()), context: context,shouldClearStack: true);
        },
      ),
    );
  }


  void removeAllPipes(){
    for (var pipe in children.whereType<Pipe>()) pipe.removeFromParent();
  }

  void resetFields(){
    _speedIncreaseTimer?.cancel();
    _speedIncreaseTimer = null;
    _gameTimer?.cancel();
    _gameTimer = null;
    bird.position = Vector2(GameConstants.birdStartX, GameConstants.birdStartY);
    bird.velocity = 0;
    pipeManager.pipeSpawnTimer = 0;
    GameSpeedManager.resetSpeed();
  }

  void restartGame(BuildContext context) {
    resetFields();
    _speedIncreaseTimer = async.Timer.periodic(const Duration(seconds: 10), (_)=> GameSpeedManager.increaseSpeed());
    isGameOver = false;
    resumeEngine();
    startGameTimer();
    goBack(context);
  }
}
