import 'package:flame/game.dart';
import 'package:flappy/core/utils/utility_methods.dart';
import 'package:flappy/features/flappy/flappy_bloc/flappy_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flappy_bird_game.dart';

class FlappyHome extends StatelessWidget {
  const FlappyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Flappy Bird",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => startGame(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "Start Game",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startGame(BuildContext context) async{
    context.read<FlappyBloc>().syncHighScore().then((_){
      navigateTo(child: GameWidget(game: FlappyBirdGame(highScore: context.read<FlappyBloc>().highScore,flappyBloc: context.read<FlappyBloc>())), context: context);
    });
  }
}
