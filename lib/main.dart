import 'package:flappy/core/theme/theme.dart';
import 'package:flappy/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/flappy/flappy_bloc/flappy_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.flappyGameTheme,
        debugShowCheckedModeBanner: false,
        home: const Splash());
  }
}
