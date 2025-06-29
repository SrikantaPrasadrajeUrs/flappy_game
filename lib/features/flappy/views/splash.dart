import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/resources/game_assets.dart';
import '../../../core/utils/utility_methods.dart';
import '../flappy_bloc/flappy_bloc.dart';
import 'flappy_home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State createState() => _RocketScreenState();
}

class _RocketScreenState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await GameAssets.initGameAssets();
      await Future.delayed(const Duration(seconds: 2),()=>navigateTo(child: MultiBlocProvider(
          providers: [BlocProvider(create: (context) => FlappyBloc())],
          child: const FlappyHome()), context: context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/bg-test1.png", fit: BoxFit.cover, width: size.width, height: size.height,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha:0.4),
                  blurRadius: 25,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha:0.1),
                  blurRadius: 40,
                  spreadRadius: 15,
                  offset: const Offset(-5, -5),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.15),
                  blurRadius: 50,
                  spreadRadius: 0,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                "assets/images/flappy_home_img.webp",
                width: size.width / 1.2,
                height: size.height / 4,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
