import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

/// Nama shalat yang bisa di-toggle notifikasi adzannya.
class AdzanPrayer {
  static const String subuh = 'subuh';
  static const String dzuhur = 'dzuhur';
  static const String ashar = 'ashar';
  static const String maghrib = 'maghrib';
  static const String isya = 'isya';

  static const List<String> all = [subuh, dzuhur, ashar, maghrib, isya];

  static String label(String key) {
    switch (key) {
      case subuh:
        return 'Subuh';
      case dzuhur:
        return 'Dzuhur';
      case ashar:
        return 'Ashar';
      case maghrib:
        return 'Maghrib';
      case isya:
        return 'Isya';
      default:
        return key;
    }
  }
}

/// Pilihan pengingat sebelum adzan, dalam menit. 0 = tidak ada pengingat.
const List<int> kAdzanRemindOptions = [0, 5, 10, 15, 30];

class AppSettings {
  final bool adzanEnabled;
  final Map<String, bool> adzanPrayers;
  final int adzanRemindMinutes;
  final bool adzanSound;
  final bool adzanVibrate;
  final bool bismillahAudioEnabled;

  const AppSettings({
    this.adzanEnabled = false,
    this.adzanPrayers = const {
      AdzanPrayer.subuh: true,
      AdzanPrayer.dzuhur: true,
      AdzanPrayer.ashar: true,
      AdzanPrayer.maghrib: true,
      AdzanPrayer.isya: true,
    },
    this.adzanRemindMinutes = 0,
    this.adzanSound = true,
    this.adzanVibrate = true,
    this.bismillahAudioEnabled = true,
  });

  bool isPrayerOn(String key) => adzanPrayers[key] ?? false;

  AppSettings copyWith({
    bool? adzanEnabled,
    Map<String, bool>? adzanPrayers,
    int? adzanRemindMinutes,
    bool? adzanSound,
    bool? adzanVibrate,
    bool? bismillahAudioEnabled,
  }) {
    return AppSettings(
      adzanEnabled: adzanEnabled ?? this.adzanEnabled,
      adzanPrayers: adzanPrayers ?? this.adzanPrayers,
      adzanRemindMinutes: adzanRemindMinutes ?? this.adzanRemindMinutes,
      adzanSound: adzanSound ?? this.adzanSound,
      adzanVibrate: adzanVibrate ?? this.adzanVibrate,
      bismillahAudioEnabled:
          bismillahAudioEnabled ?? this.bismillahAudioEnabled,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  static const String _kAdzanEnabled = 'notif_adzan_enabled';
  static const String _kAdzanPrayerPrefix = 'notif_adzan_';
  static const String _kAdzanRemind = 'notif_adzan_remind';
  static const String _kAdzanSound = 'notif_adzan_sound';
  static const String _kAdzanVibrate = 'notif_adzan_vibrate';

  void _load() {
    final prayers = <String, bool>{
      for (final key in AdzanPrayer.all)
        key: PreferencesService.getBool('$_kAdzanPrayerPrefix$key') ?? true,
    };

    state = AppSettings(
      adzanEnabled: PreferencesService.getBool(_kAdzanEnabled) ?? false,
      adzanPrayers: prayers,
      adzanRemindMinutes: PreferencesService.getInt(_kAdzanRemind) ?? 0,
      adzanSound: PreferencesService.getBool(_kAdzanSound) ?? true,
      adzanVibrate: PreferencesService.getBool(_kAdzanVibrate) ?? true,
      bismillahAudioEnabled: PreferencesService.bismillahAudioEnabled,
    );
  }

  Future<void> setBismillahAudioEnabled(bool value) async {
    state = state.copyWith(bismillahAudioEnabled: value);
    PreferencesService.bismillahAudioEnabled = value;
  }

  Future<void> setAdzanEnabled(bool value) async {
    state = state.copyWith(adzanEnabled: value);
    await PreferencesService.setBool(_kAdzanEnabled, value);
  }

  Future<void> setPrayer(String key, bool value) async {
    final prayers = Map<String, bool>.from(state.adzanPrayers);
    prayers[key] = value;
    state = state.copyWith(adzanPrayers: prayers);
    await PreferencesService.setBool('$_kAdzanPrayerPrefix$key', value);
  }

  Future<void> setRemindMinutes(int minutes) async {
    state = state.copyWith(adzanRemindMinutes: minutes);
    await PreferencesService.setInt(_kAdzanRemind, minutes);
  }

  Future<void> setAdzanSound(bool value) async {
    state = state.copyWith(adzanSound: value);
    await PreferencesService.setBool(_kAdzanSound, value);
  }

  Future<void> setAdzanVibrate(bool value) async {
    state = state.copyWith(adzanVibrate: value);
    await PreferencesService.setBool(_kAdzanVibrate, value);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
