import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';
import 'config/game_theme.dart';

void main() {
  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mega Memory Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: GameTheme.backgroundColor,
      ),
      home: const MainNavigationScreen(),
    );
  }
}
