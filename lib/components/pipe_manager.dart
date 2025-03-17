
import 'package:flame/components.dart';
import 'package:flappy/constants.dart';
import 'package:flappy/game.dart';
import 'package:flappy/components/pipe.dart';
import 'dart:math' as math;

class PipeManager extends Component with HasGameRef<FlappyBirdGame>{

  double pipeSpawnTimer = 0;
  static const double pipeInterval = 2;
  @override
  void update(double dt){
    pipeSpawnTimer +=dt;
    if(pipeSpawnTimer>=pipeInterval){
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  void spawnPipe(){
    final double screenHeight = gameRef.size.y;
    const double pipeGap = 160;
    const double minPipeHeight = 100;
    const double pipeWidth = 60;

    double maxPipeHeight = screenHeight - groundHeight - minPipeHeight - pipeGap;
    final double bottomPipeHeight = minPipeHeight +math.Random().nextDouble()*(maxPipeHeight-minPipeHeight);
    final double topPipeHeight = screenHeight - groundHeight - bottomPipeHeight - pipeGap;

    if (topPipeHeight < minPipeHeight) {
      return;
    }

    final bottomPipe = Pipe(
      Vector2(gameRef.size.x,screenHeight-groundHeight-bottomPipeHeight),
      Vector2(pipeWidth,bottomPipeHeight),
      isBottomPipe: true,
    );
    final topPipe = Pipe(
      Vector2(gameRef.size.x,0),
      Vector2(pipeWidth,topPipeHeight),
      isBottomPipe: false,
    );
    gameRef.addAll([bottomPipe,topPipe]);
  }

}