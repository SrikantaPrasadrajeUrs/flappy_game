import 'package:flappy/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'features/flappy/views/splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
