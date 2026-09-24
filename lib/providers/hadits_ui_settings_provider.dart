import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class HaditsUiSettings {
  final double arabicFontSize;
  final double translationFontSize;
  final bool showArabic;
  final bool showTranslation;

  const HaditsUiSettings({
    this.arabicFontSize = 24.0,
    this.translationFontSize = 14.0,
    this.showArabic = true,
    this.showTranslation = true,
  });

  HaditsUiSettings copyWith({
    double? arabicFontSize,
    double? translationFontSize,
    bool? showArabic,
    bool? showTranslation,
  }) {
    return HaditsUiSettings(
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      showArabic: showArabic ?? this.showArabic,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }
}

class HaditsUiSettingsNotifier extends StateNotifier<HaditsUiSettings> {
  HaditsUiSettingsNotifier() : super(const HaditsUiSettings()) {
    _load();
  }

  static const String _keyArabicFontSize = 'hadits_font_size_arabic';
  static const String _keyTranslationFontSize = 'hadits_font_size_trans';
  static const String _keyShowArabic = 'hadits_show_arabic';
  static const String _keyShowTranslation = 'hadits_show_trans';

  void _load() {
    final arabicSize = PreferencesService.getDouble(_keyArabicFontSize) ?? 24.0;
    final transSize = PreferencesService.getDouble(_keyTranslationFontSize) ?? 14.0;
    final showArab = PreferencesService.getBool(_keyShowArabic) ?? true;
    final showTrans = PreferencesService.getBool(_keyShowTranslation) ?? true;

    state = HaditsUiSettings(
      arabicFontSize: arabicSize,
      translationFontSize: transSize,
      showArabic: showArab,
      showTranslation: showTrans,
    );
  }

  Future<void> setArabicFontSize(double size) async {
    state = state.copyWith(arabicFontSize: size);
    await PreferencesService.setDouble(_keyArabicFontSize, size);
  }

  Future<void> setTranslationFontSize(double size) async {
    state = state.copyWith(translationFontSize: size);
    await PreferencesService.setDouble(_keyTranslationFontSize, size);
  }

  Future<void> toggleShowArabic() async {
    final next = !state.showArabic;
    state = state.copyWith(showArabic: next);
    await PreferencesService.setBool(_keyShowArabic, next);
  }

  Future<void> toggleShowTranslation() async {
    final next = !state.showTranslation;
    state = state.copyWith(showTranslation: next);
    await PreferencesService.setBool(_keyShowTranslation, next);
  }
}

final haditsUiSettingsProvider =
    StateNotifierProvider<HaditsUiSettingsNotifier, HaditsUiSettings>((ref) {
  return HaditsUiSettingsNotifier();
});
