import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

/// Plays full Azan audio from app assets (foreground / notification tap).
class AzanAudioService {
  AzanAudioService._();
  static final AzanAudioService instance = AzanAudioService._();

  static const String azanAssetPath = 'assets/sound/azan.mp3';

  final AudioPlayer _player = AudioPlayer();
  bool _sessionConfigured = false;

  Future<void> _ensureSession() async {
    if (_sessionConfigured) return;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    ));
    _sessionConfigured = true;
  }

  Future<void> play() async {
    try {
      await _ensureSession();
      await _player.stop();
      await _player.setAsset(azanAssetPath);
      await _player.play();
    } catch (_) {
      // Asset may be missing until bundled — notification sound still fires.
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }
}
