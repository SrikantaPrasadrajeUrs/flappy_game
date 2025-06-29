import 'package:flame/game.dart';
import 'package:flappy/core/managers/audio_manager.dart';
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
  late final ValueNotifier<int> _selectedBird;
  late final ValueNotifier<bool> isMusicClicked;
  final Image musicImage = Image.asset("assets/images/musical-note.png", width: 30, height: 30);

  @override
  void initState() {
    _selectedBird = ValueNotifier<int>(1);
    playInitialBgAudio();
    isMusicClicked = ValueNotifier<bool>(AudioManager.isBgmPlaying==0||AudioManager.isBgmPlaying==1);
    super.initState();
  }

  void playInitialBgAudio(){
    if(AudioManager.isBgmPlaying==0){
      AudioManager.playAudio("home_page_song.mp3", isBg: true);
    }
  }

  @override
  void dispose() {
    _selectedBird.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(size.width, size.height),
            _buildUI(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(double width, double height) {
    return Image.asset("assets/images/home_bg.png", fit: BoxFit.cover, width: width, height: height);
  }

  Widget _buildUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          ValueListenableBuilder(
            valueListenable: isMusicClicked,
            builder: (context,value,_) {
              return Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: (){
                      isMusicClicked.value = !isMusicClicked.value;
                      if(isMusicClicked.value){
                        AudioManager.playAudio("home_page_song.mp3", isBg: true);
                      }else{
                        AudioManager.stopAudio("home_page_song.mp3", isBg: true);
                      }
                      print(AudioManager.isBgmPlaying);
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(color: Colors.black,
                            border: Border.all(color: Colors.white,width: 2),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: value?const [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]:[]
                    ),
                    child: Center(
                        child: musicImage)),
                  ));
            }
          ),
          const Spacer(),
          _buildTitle(),
          const SizedBox(height: 20),
          _buildBirdSelection(),
          const SizedBox(height: 30),
          _buildGameModeSelection(),
          const SizedBox(height: 40),
          _buildStartButton(context),
          const Spacer(),
        ],
      ),
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
              _buildBird("assets/images/bluebird-upflap.png", value == 1, 1),
              const SizedBox(width: 20),
              _buildBird("assets/images/yellowbird-upflap.png", value == 2, 2),
            ],
          );
        });
  }

  Widget _buildBird(String assetPath, bool isSelected, int birdIndex) {
    return GestureDetector(
      onTap: () {
        _selectedBird.value = birdIndex;
      },
      child: Container(
        height: isSelected ? 90 : 80,
        width: isSelected ? 90 : 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 3),
          color: const Color(0xFFFFC107),
          boxShadow: isSelected ? [
            // White glow - top left
            const BoxShadow(
              color: Colors.white70,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(-4, -4),
            ),
            const BoxShadow(
              color: Colors.lightBlueAccent,
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ] : [],
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
        _buildGameModeButton("Endless", isAvailable: true),
      ],
    );
  }

  Widget _buildGameModeButton(String mode, {bool isAvailable = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Text(
          "$mode ${!isAvailable ? "❌" : "✅"}",
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
          color: Colors.brown,
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
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
                birdType: _selectedBird.value),
          ),
        ),
        context: context,
      );
    });
  }
}
