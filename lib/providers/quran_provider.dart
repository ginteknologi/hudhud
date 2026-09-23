import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/providers/api_providers.dart';

// Surah list provider with search query parameter
final surahListProvider = FutureProvider.family<List<SurahModel>, String>((ref, search) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<SurahModel>>(
      ApiEndpoints.quranSurah,
      queryParameters: search.isNotEmpty ? {'search': search} : null,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => SurahModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// Random Ayat provider
final randomAyatProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.baseUrl}/quran/random-surah',
      fromJson: (json) => (json is Map<String, dynamic>) ? json : {},
    );
    return response.data ?? {};
  } catch (_) {
    return {};
  }
});

// Detail ayat provider
final surahDetailProvider = FutureProvider.family<List<AyatModel>, int>((ref, surahId) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<AyatModel>>(
      '${ApiEndpoints.quranDetail}/$surahId',
      fromJson: (json) {
        if (json is Map && json['list'] is List) {
          return (json['list'] as List)
              .map((item) => AyatModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// Bookmark Notifier
class QuranBookmarkNotifier extends StateNotifier<QuranBookmark?> {
  QuranBookmarkNotifier() : super(null) {
    _load();
  }

  void _load() {
    final jsonStr = PreferencesService.getString('quran_bookmark');
    if (jsonStr != null) {
      try {
        state = QuranBookmark.fromJson(jsonDecode(jsonStr));
      } catch (_) {}
    }
  }

  Future<void> saveBookmark(QuranBookmark bookmark) async {
    state = bookmark;
    await PreferencesService.setString('quran_bookmark', jsonEncode(bookmark.toJson()));
  }
}

final quranBookmarkProvider = StateNotifierProvider<QuranBookmarkNotifier, QuranBookmark?>((ref) {
  return QuranBookmarkNotifier();
});

// Audio Player State & Controller
class AudioState {
  final bool isPlaying;
  final int? currentAyat;
  final bool isLoading;

  AudioState({
    this.isPlaying = false,
    this.currentAyat,
    this.isLoading = false,
  });

  AudioState copyWith({bool? isPlaying, int? currentAyat, bool? isLoading}) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentAyat: currentAyat ?? this.currentAyat,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class QuranAudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayer _player = AudioPlayer();

  QuranAudioNotifier() : super(AudioState()) {
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false, currentAyat: null);
      } else {
        state = state.copyWith(isPlaying: playerState.playing);
      }
    });
  }

  Future<void> playAyat(AyatModel ayat) async {
    if (ayat.audioUrl.isEmpty) return;
    try {
      state = state.copyWith(isLoading: true, currentAyat: ayat.ayat);
      await _player.setUrl(ayat.audioUrl);
      await _player.play();
      state = state.copyWith(isLoading: false, isPlaying: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, isPlaying: false);
    }
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(isPlaying: false, currentAyat: null);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final quranAudioProvider = StateNotifierProvider.autoDispose<QuranAudioNotifier, AudioState>((ref) {
  return QuranAudioNotifier();
});
