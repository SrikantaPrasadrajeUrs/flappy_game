import 'package:flutter_bloc/flutter_bloc.dart';
part 'flappy_event.dart';
part 'flappy_state.dart';

class FlappyBloc extends Bloc<FlappyEvent,FlappyState>{
  int highScore = 0;
  FlappyBloc():super(FlappyInitialState());
}