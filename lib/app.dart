import 'package:flutter/material.dart';
import 'package:behabior/ui/themes/app_theme.dart';
import 'package:behabior/ui/screens/game_screen.dart';

class DinoApp extends StatelessWidget {
  const DinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dino Run',
      theme: DinoTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}
