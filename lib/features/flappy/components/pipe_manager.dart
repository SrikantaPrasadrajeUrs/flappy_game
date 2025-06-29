import 'package:flame/components.dart';
import 'package:flappy/core/config/game_constants.dart';
import 'package:flappy/core/resources/game_assets.dart';
import 'package:flappy/features/flappy/components/pipe_trap.dart';
import '../views/flappy_bird_game.dart';
import 'package:flappy/features/flappy/components/flappy_components.dart';

class PipeManager extends Component with HasGameRef<FlappyBirdGame>{
  double pipeSpawnTimer = 0;
  static double pipeInterval = 3;

  Pipe? singlePipe;
  bool isSingleTopPipe = false;
  bool isSingleBottomPipe = false;
  int pipeIncreaseLength = 40;

  @override
  void update(double dt){
    pipeSpawnTimer +=dt;
    if(pipeSpawnTimer>=pipeInterval){
      int turns = GameAssets.rand.nextInt(3);
      pipeInterval = turns==0?2.3: turns==1?2.6:3;
      pipeSpawnTimer = 0;
      spawnPipe();
    }
    if(singlePipe!=null){
      final distance = gameRef.bird.position.x - singlePipe!.position.x;
      if(distance<150){
        int turns = GameAssets.rand.nextInt(4);
        if(isSingleTopPipe) {
          singlePipe!.size.y += dt*pipeIncreaseLength*turns;
        } else if(!singlePipe!.isStaticPipe) {
          singlePipe!.size.y += dt*pipeIncreaseLength*turns;
          singlePipe!.position.y -= dt*pipeIncreaseLength*turns;
        }
      }
    }
  }

  void spawnPipe(){
    bool isSinglePipe = false;
    bool onlyTopPipe = false;
    final double screenHeight = gameRef.size.y;
    final pipeGap = GameAssets.rand.nextInt(2)==0?GameConstants.minPipeGap:GameConstants.maxPipGap;
    double maxPipeHeight = screenHeight - GameConstants.groundHeight - GameConstants.minPipeHeight - pipeGap;
    final double bottomPipeHeight = GameConstants.minPipeHeight +GameAssets.rand.nextDouble()*(maxPipeHeight-GameConstants.minPipeHeight);
    final double topPipeHeight = screenHeight - GameConstants.groundHeight - bottomPipeHeight - pipeGap;

    if (topPipeHeight < GameConstants.minPipeHeight) {
      return;
    }
    isSinglePipe = GameAssets.rand.nextBool();
    onlyTopPipe = GameAssets.rand.nextBool();
    bool shouldAttachTrap = GameAssets.rand.nextBool();
    bool isStaticBottomPipe = isSinglePipe && !onlyTopPipe && shouldAttachTrap;
    final bottomPipe = Pipe(
      isStaticPipe: isStaticBottomPipe,
      Vector2(gameRef.size.x,screenHeight-GameConstants.groundHeight-bottomPipeHeight),
      Vector2(GameConstants.pipeWidth,bottomPipeHeight),
      isBottomPipe: true,
    );
    final topPipe = Pipe(
      isStaticPipe: true,
      Vector2(gameRef.size.x,0),
      Vector2(GameConstants.pipeWidth,topPipeHeight),
      isBottomPipe: false,
    );
    if (isSinglePipe) {
      if (onlyTopPipe) {
        gameRef.add(topPipe..isBrownPipe = GameAssets.rand.nextBool());
        singlePipe = topPipe;
        isSingleTopPipe = true;
        isSingleBottomPipe = false;
      } else {
        gameRef.add(bottomPipe..isBrownPipe = GameAssets.rand.nextBool());
        singlePipe = bottomPipe;
        isSingleTopPipe = false;
        isSingleBottomPipe = true;
        if (isStaticBottomPipe) {
          gameRef.add(PipeTrap(
            bottomPipe: bottomPipe,
            position: Vector2(bottomPipe.position.x, bottomPipe.position.y),
          ));
        }
      }
      return;
    }
    gameRef.addAll([bottomPipe,topPipe]);
    if(shouldAttachTrap){
      gameRef.add(PipeTrap(
        bottomPipe: bottomPipe,
        position: Vector2(bottomPipe.position.x, bottomPipe.position.y),
      ));
    }
    singlePipe = null;
    isSingleTopPipe = false;
    isSingleBottomPipe = false;
  }

}