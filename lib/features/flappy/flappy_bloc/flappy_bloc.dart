import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/high_score_repository.dart';
part 'flappy_event.dart';
part 'flappy_state.dart';

class FlappyBloc extends Bloc<FlappyEvent,FlappyState>{
  String highScore = "00:00";
  final highScoreRepository = HighScoreRepository();
  FlappyBloc():super(FlappyInitialState());

  Future<void> syncHighScore()async{
   await highScoreRepository.getHighScore().then((value)=>highScore = value);
  }

  void storeHighScore(String score)async{
    highScoreRepository.setHighScore(score);
  }
}