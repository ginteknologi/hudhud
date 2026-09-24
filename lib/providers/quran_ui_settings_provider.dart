import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class QuranUiSettings {
  final double arabicFontSize;
  final double translationFontSize;
  final bool showLatin;
  final bool showTranslation;
  final String selectedQori;

  const QuranUiSettings({
    this.arabicFontSize = 24.0,
    this.translationFontSize = 13.5,
    this.showLatin = true,
    this.showTranslation = true,
    this.selectedQori = 'ar.alafasy',
  });

  QuranUiSettings copyWith({
    double? arabicFontSize,
    double? translationFontSize,
    bool? showLatin,
    bool? showTranslation,
    String? selectedQori,
  }) {
    return QuranUiSettings(
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      showLatin: showLatin ?? this.showLatin,
      showTranslation: showTranslation ?? this.showTranslation,
      selectedQori: selectedQori ?? this.selectedQori,
    );
  }
}

class QuranUiSettingsNotifier extends StateNotifier<QuranUiSettings> {
  QuranUiSettingsNotifier() : super(const QuranUiSettings()) {
    _load();
  }

  static const String _keyArabicFontSize = 'quran_font_size_arabic';
  static const String _keyTranslationFontSize = 'quran_font_size_trans';
  static const String _keyShowLatin = 'quran_show_latin';
  static const String _keyShowTranslation = 'quran_show_trans';
  static const String _keySelectedQori = 'quran_selected_qori';

  void _load() {
    final arabicSize = PreferencesService.getDouble(_keyArabicFontSize) ?? 24.0;
    final transSize = PreferencesService.getDouble(_keyTranslationFontSize) ?? 13.5;
    final showLatin = PreferencesService.getBool(_keyShowLatin) ?? true;
    final showTrans = PreferencesService.getBool(_keyShowTranslation) ?? true;
    final qori = PreferencesService.getString(_keySelectedQori) ?? 'ar.alafasy';

    state = QuranUiSettings(
      arabicFontSize: arabicSize,
      translationFontSize: transSize,
      showLatin: showLatin,
      showTranslation: showTrans,
      selectedQori: qori,
    );
  }

  Future<void> updateArabicFontSize(double size) async {
    state = state.copyWith(arabicFontSize: size);
    await PreferencesService.setDouble(_keyArabicFontSize, size);
  }

  Future<void> updateTranslationFontSize(double size) async {
    state = state.copyWith(translationFontSize: size);
    await PreferencesService.setDouble(_keyTranslationFontSize, size);
  }

  Future<void> toggleLatin(bool show) async {
    state = state.copyWith(showLatin: show);
    await PreferencesService.setBool(_keyShowLatin, show);
  }

  Future<void> toggleTranslation(bool show) async {
    state = state.copyWith(showTranslation: show);
    await PreferencesService.setBool(_keyShowTranslation, show);
  }

  Future<void> setQori(String qori) async {
    state = state.copyWith(selectedQori: qori);
    await PreferencesService.setString(_keySelectedQori, qori);
  }
}

final quranUiSettingsProvider =
    StateNotifierProvider<QuranUiSettingsNotifier, QuranUiSettings>((ref) {
  return QuranUiSettingsNotifier();
});
