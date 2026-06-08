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
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white, // Garante visibilidade no fundo escuro
                ),
          ),
          const Divider(color: Colors.white30),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Fundo preto transparente
              borderRadius: BorderRadius.circular(12),
            ),
            child: CheckboxListTile(
              title: const Text(
                'Efeitos sonoros',
                style: TextStyle(color: Colors.white),
              ),
              value: _soundOption,
              activeColor: Colors.white, // Cor do Checkbox quando ativo
              checkColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  _soundOption = value ?? true;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Dificuldade',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Fundo preto transparente
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                RadioListTile<int>(
                  title: const Text('Normal',
                      style: TextStyle(color: Colors.white)),
                  value: 1,
                  groupValue: _difficultyRadio,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _difficultyRadio = value ?? 1;
                    });
                  },
                ),
                // Uma linha divisória sutil entre as duas opções de rádio
                const Divider(height: 1, color: Colors.white12),
                RadioListTile<int>(
                  title: const Text('Hardcore',
                      style: TextStyle(color: Colors.white)),
                  value: 2,
                  groupValue: _difficultyRadio,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _difficultyRadio = value ?? 2;
                    });
                  },
                ),
              ],
            ),
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
