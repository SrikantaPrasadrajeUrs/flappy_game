import 'package:flame/components.dart';
import 'package:flappy/constants.dart';
import '../flappy_bird_game.dart';
import 'package:flappy/components/pipe.dart';
import 'dart:math' as math;

class PipeManager extends Component with HasGameRef<FlappyBirdGame>{

  double pipeSpawnTimer = 0;
  static double pipeInterval = 3;
  @override
  void update(double dt){
    pipeSpawnTimer +=dt;
    if(pipeSpawnTimer>=pipeInterval){
      int turns = math.Random().nextInt(3);
      pipeInterval = turns==0?2.3: turns==1?2.6:3;
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  void spawnPipe(){
    final double screenHeight = gameRef.size.y;
    const double maxPipGap = 250;
    const double minPipeGap = 180;
    const double minPipeHeight = 100;
    const double pipeWidth = 60;
    final pipeGap = math.Random().nextInt(2)==0?minPipeGap:maxPipGap;
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