import 'package:flutter/material.dart';
import '../config/game_theme.dart';
import './game_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const GameScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: GameTheme.useBackgroundImage
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    GameTheme.backgroundImagePath,
                  ),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Jogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Opções',
          ),
        ],
      ),
    );
  }
}
