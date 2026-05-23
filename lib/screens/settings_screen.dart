import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundOption = true;

  int _difficultyRadio = 1;

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _soundOption = prefs.getBool('sound_enabled') ?? true;

      _difficultyRadio = prefs.getInt('difficulty') ?? 1;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'sound_enabled',
      _soundOption,
    );

    await prefs.setInt(
      'difficulty',
      _difficultyRadio,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Configurações salvas!',
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const SizedBox(height: 40),
          Text(
            'Configurações',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Divider(),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text(
              'Efeitos sonoros',
            ),
            value: _soundOption,
            onChanged: (value) {
              setState(() {
                _soundOption = value ?? true;
              });
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Dificuldade',
          ),
          RadioListTile<int>(
            title: const Text('Normal'),
            value: 1,
            groupValue: _difficultyRadio,
            onChanged: (value) {
              setState(() {
                _difficultyRadio = value ?? 1;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('Hardcore'),
            value: 2,
            groupValue: _difficultyRadio,
            onChanged: (value) {
              setState(() {
                _difficultyRadio = value ?? 2;
              });
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text(
              'Salvar Opções',
            ),
          ),
        ],
      ),
    );
  }
}
