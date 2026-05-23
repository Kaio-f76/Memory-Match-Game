import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(
    String assetPath,
    bool enabled,
  ) async {
    if (!enabled) return;

    await _audioPlayer.stop();
    await _audioPlayer.play(
      AssetSource(assetPath),
    );
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
