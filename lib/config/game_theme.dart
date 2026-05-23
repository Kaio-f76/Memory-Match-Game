import 'package:flutter/material.dart';

class GameTheme {
  static const bool useBackgroundImage = true;
  static const String backgroundImagePath = 'assets/images/fundo.jpg';

  static const Color backgroundColor = Color(0xFF1E1E2E);

  static const Color cardBackColor = Colors.deepPurple;
  static const Color cardFrontColor = Colors.amber;

  static const double cardElevation = 6.0;

  static const bool useCustomImagesAsCards = true;

  static const List<IconData> gameIcons = [
    Icons.star,
    Icons.favorite,
    Icons.directions_car,
    Icons.dark_mode,
    Icons.flight,
    Icons.cake,
    Icons.pets,
    Icons.sports_esports,
  ];

  static const List<String> gameImageAssets = [
    'assets/images/lion_man.jpg',
    'assets/images/orko_he_man.png',
    'assets/images/thundercats.png',
    'assets/images/Tokusatsu1.png',
    'assets/images/Tokusatsu2.png',
    'assets/images/Tokusatsu3.png',
    'assets/images/Tokusatsu4.png',
    'assets/images/Tokusatsu5.png',
  ];
}
