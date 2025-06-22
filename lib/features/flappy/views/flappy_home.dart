import 'package:flame/game.dart';
import 'package:flappy/core/utils/utility_methods.dart';
import 'package:flappy/features/flappy/flappy_bloc/flappy_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flappy_bird_game.dart';

class FlappyHome extends StatefulWidget {
  const FlappyHome({super.key});

  @override
  State<FlappyHome> createState() => _FlappyHomeState();
}

class _FlappyHomeState extends State<FlappyHome> {

  final ValueNotifier<int> _selectedBird = ValueNotifier<int>(1);

  @override
  void dispose() {
    _selectedBird.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            _buildUI(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(),
        const SizedBox(height: 20),
        _buildBirdSelection(),
        const SizedBox(height: 30),
        _buildGameModeSelection(),
        const SizedBox(height: 40),
        _buildStartButton(context),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      "FLAPPY BIRD",
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.yellowAccent,
        fontFamily: 'PressStart2P',
        shadows: [
          Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
        ],
      ),
    );
  }

  Widget _buildBirdSelection() {
    return ValueListenableBuilder(
      valueListenable: _selectedBird,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBird("assets/images/bluebird-upflap.png", value==1, 1),
            const SizedBox(width: 20),
            _buildBird("assets/images/yellowbird-upflap.png", value==2, 2),
          ],
        );
      }
    );
  }

  Widget _buildBird(String assetPath, bool isSelected, int birdIndex) {
    return GestureDetector(
      onTap: () {
        _selectedBird.value = birdIndex;
      },
      child: Container(
        height: isSelected?90:80,
        width: isSelected?90:80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.asset(assetPath, width: 70, height: 70),
      ),
    );
  }

  Widget _buildGameModeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGameModeButton("Classic"),
        const SizedBox(width: 10),
        _buildGameModeButton("Hard Mode"),
        const SizedBox(width: 10),
        _buildGameModeButton("Endless", isAvailable:  true),
      ],
    );
  }

  Widget _buildGameModeButton(String mode, {bool isAvailable = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          "$mode ${!isAvailable?"❌":"✅"}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      onTap: () => startGame(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Text(
          "Start Game",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void startGame(BuildContext context) async {
    context.read<FlappyBloc>().syncHighScore().then((_) {
      navigateTo(
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: true,
          child: GameWidget(
            game: FlappyBirdGame(
              highScore: context.read<FlappyBloc>().highScore,
              flappyBloc: context.read<FlappyBloc>(),
              birdType: _selectedBird.value
            ),
          ),
        ),
        context: context,
      );
    });
  }
}
