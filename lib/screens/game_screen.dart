import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/game_theme.dart';

import '../services/audio_service.dart';
import '../services/preferences_service.dart';

import '../widgets/card_counter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioService _audioService = AudioService();

  List<dynamic> _shuffledCards = [];

  List<bool> _cardFlips = [];

  int _previousSelectedIndex = -1;

  bool _waitNextClick = false;

  int _score = 0;

  int _highScore = 0;

  bool _soundEnabled = true;

  int _difficulty = 1;

  int _remainingAttempts = 8;

  int _previewSeconds = 4;

  int _errors = 0;

  bool _gameStarted = false;

  late DateTime _startTime;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    _highScore = await PreferencesService.getHighScore();

    _soundEnabled = await PreferencesService.getSoundEnabled();

    final prefs = await SharedPreferences.getInstance();

    _difficulty = prefs.getInt('difficulty') ?? 1;

    _startNewGame();
  }

  void _configureDifficulty() {
    if (_difficulty == 1) {
      _remainingAttempts = 8;

      _previewSeconds = 4;
    } else {
      _remainingAttempts = 4;

      _previewSeconds = 3;
    }
  }

  @override
  void dispose() {
    _audioService.dispose();

    super.dispose();
  }

  void _startNewGame() {
    _configureDifficulty();

    List<dynamic> baseItems = GameTheme.useCustomImagesAsCards
        ? [...GameTheme.gameImageAssets]
        : [...GameTheme.gameIcons];

    List<dynamic> gameItems = [...baseItems, ...baseItems];

    gameItems.shuffle();

    setState(() {
      _shuffledCards = gameItems;

      _cardFlips = List<bool>.filled(
        gameItems.length,
        true,
      );

      _previousSelectedIndex = -1;

      _waitNextClick = true;

      _score = 0;

      _errors = 0;

      _gameStarted = false;
    });

    Future.delayed(
      Duration(
        seconds: _previewSeconds,
      ),
      () {
        if (!mounted) return;

        setState(() {
          _cardFlips = List<bool>.filled(
            gameItems.length,
            false,
          );

          _waitNextClick = false;

          _gameStarted = true;

          _startTime = DateTime.now();
        });
      },
    );
  }

  // 🔥 SCORE ALTERADO SOMENTE AQUI
  void _updateScore({required bool isMatch}) {
    if (isMatch) {
      _score += 100;
    } else {
      _score -= 50;
      if (_score < 0) _score = 0;
    }
  }

  void _onCardTap(int index) {
    if (_waitNextClick ||
        _cardFlips[index] ||
        index == _previousSelectedIndex) {
      return;
    }

    setState(() {
      _cardFlips[index] = true;
    });

    if (_previousSelectedIndex == -1) {
      _previousSelectedIndex = index;
    } else {
      final isMatch =
          _shuffledCards[_previousSelectedIndex] == _shuffledCards[index];

      if (isMatch) {

        final matchedCard = _shuffledCards[index];

        final audioPath = GameTheme.cardAudios[matchedCard];

        if (audioPath != null) {
          _audioService.playSound(
            audioPath,
            _soundEnabled,
          );
        } else {
        _audioService.playSound(
          'audio/success.mp3',
          _soundEnabled,
        );
        }

        setState(() {
          _updateScore(isMatch: true);
          _previousSelectedIndex = -1;
        });

        _checkWinCondition();
        }
        else{
        _audioService.playSound(
          'audio/error.mp3',
          _soundEnabled,
        );

        setState(() {
          _updateScore(isMatch: false);
        });

        _waitNextClick = true;

        _errors++;
        _remainingAttempts--;

        if (_remainingAttempts <= 0) {
          _showGameOver();
          return;
        }

        Timer(
          const Duration(seconds: 1),
          () {
            setState(() {
              _cardFlips[_previousSelectedIndex] = false;

              _cardFlips[index] = false;

              _previousSelectedIndex = -1;

              _waitNextClick = false;
            });
          },
        );
      }
    }
  }

  Future<void> _checkWinCondition() async {
    if (_cardFlips.every((flipped) => flipped)) {
      final endTime = DateTime.now();

      final seconds = endTime.difference(_startTime).inSeconds;

      // mantém lógica original de tempo + erros, mas soma com score base
      final finalScore = _score + (1000 - (seconds * 5) - (_errors * 50));

      _score = finalScore < 0 ? 0 : finalScore;

      if (_score > _highScore) {
        _highScore = _score;

        await PreferencesService.saveHighScore(_highScore);
      }

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: const Text('🎉 Vitória'),
            content: Text(
              'Pontuação: $_score\n'
              'Erros: $_errors',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startNewGame();
                },
                child: const Text('Jogar novamente'),
              )
            ],
          );
        },
      );
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('💀 Game Over'),
          content: const Text('Você ficou sem tentativas.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewGame();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardContent(dynamic cardData) {
    if (GameTheme.useCustomImagesAsCards) {
      return Image.asset(
        cardData as String,
        fit: BoxFit.contain,
      );
    } else {
      return Icon(
        cardData as IconData,
        size: 32,
        color: Colors.black87,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.0,
              ),
              children: [
                CardCounter(
                  title: 'Tentativas',
                  value: _remainingAttempts.toString(),
                ),
                CardCounter(
                  title: 'Erros',
                  value: _errors.toString(),
                ),
                CardCounter(
                  title: 'Score',
                  value: _score.toString(),
                ),
                CardCounter(
                  title: 'Recorde',
                  value: _highScore.toString(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: !_gameStarted,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Text(
                'Memorize as cartas...',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: _shuffledCards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: Card(
                      color: _cardFlips[index]
                          ? GameTheme.cardFrontColor
                          : GameTheme.cardBackColor,
                      elevation: GameTheme.cardElevation,
                      child: Center(
                        child: _cardFlips[index]
                            ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: _buildCardContent(
                                  _shuffledCards[index],
                                ),
                              )
                            : const Icon(
                                Icons.help_outline,
                                size: 32,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _startNewGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar Jogo'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
