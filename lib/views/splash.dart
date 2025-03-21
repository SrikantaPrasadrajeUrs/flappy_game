import 'package:flappy/core/theme/theme.dart';
import 'package:flappy/views/home.dart';
import 'package:flutter/material.dart';

import '../core/utils/utility_methods.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State createState() => _RocketScreenState();
}

class _RocketScreenState extends State<Splash> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Future.delayed(const Duration(seconds: 3),()=>navigateTo(child: const Home(), context: context));
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
