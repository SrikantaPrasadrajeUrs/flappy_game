import 'package:flappy/core/utils/utility_methods.dart';
import 'package:flappy/features/flappy/flappy_bloc/flappy_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/flappy/views/flappy_home.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select a Game", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _gameButton(context, "Flappy", MultiBlocProvider(
                    providers: [BlocProvider(create: (context) => FlappyBloc())],
                    child: const FlappyHome())),
                const SizedBox(width: 20),
                _gameButton(context, "Rocket", const FlappyHome()), // Replace with RocketHome()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gameButton(BuildContext context, String title, Widget child) {
    return GestureDetector(
      onTap: () => navigateTo(child: child, context: context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
