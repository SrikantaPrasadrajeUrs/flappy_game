import 'package:flappy/core/theme/theme.dart';
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
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width/2,
           color: AppTheme.flappyGameTheme.primaryColor,
          ),
          Container(
            width: MediaQuery.of(context).size.width/2,
            color: AppTheme.rocketGameTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
