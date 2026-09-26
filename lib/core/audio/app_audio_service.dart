import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class AppAudioService {
  static AudioPlayer? _bismillahPlayer;

  static const String bismillahAsset = 'assets/sounds/bismillah.mp3';
  static const String bismillahUrl =
      'https://cdn.islamic.network/quran/audio/64/ar.alafasy/1.mp3';

  /// Memainkan audio Bismillah jika diaktifkan di pengaturan.
  static Future<void> playBismillah() async {
    if (!PreferencesService.bismillahAudioEnabled) return;

    try {
      await _bismillahPlayer?.stop();
      await _bismillahPlayer?.dispose();

      final player = AudioPlayer();
      _bismillahPlayer = player;

      try {
        await player.setAsset(bismillahAsset);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Asset bismillah gagal, mencoba stream url: $e');
        }
        await player.setUrl(bismillahUrl);
      }

      // Cleanup saat selesai
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          player.dispose();
          if (_bismillahPlayer == player) {
            _bismillahPlayer = null;
          }
        }
      });

      await player.play();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error memainkan audio bismillah: $e');
      }
    }
  }

  /// Hentikan audio Bismillah jika sedang berjalan.
  static Future<void> stopBismillah() async {
    try {
      await _bismillahPlayer?.stop();
      await _bismillahPlayer?.dispose();
      _bismillahPlayer = null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error menghentikan audio bismillah: $e');
      }
    }
  }
}
