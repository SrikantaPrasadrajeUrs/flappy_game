import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'flappy_bird_game.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GameWidget(game: FlappyBirdGame()));
  }
}
