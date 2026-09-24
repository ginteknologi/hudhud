import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/providers/app_settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  test('default: adzan mati, semua waktu sholat hidup', () {
    final notifier = AppSettingsNotifier();
    final settings = notifier.state;

    expect(settings.adzanEnabled, isFalse);
    for (final key in AdzanPrayer.all) {
      expect(settings.isPrayerOn(key), isTrue, reason: key);
    }
    expect(settings.adzanRemindMinutes, 0);
  });

  test('pengaturan tersimpan dan terbaca ulang', () async {
    final notifier = AppSettingsNotifier();
    await notifier.setAdzanEnabled(true);
    await notifier.setPrayer(AdzanPrayer.subuh, false);
    await notifier.setRemindMinutes(10);

    final reloaded = AppSettingsNotifier().state;
    expect(reloaded.adzanEnabled, isTrue);
    expect(reloaded.isPrayerOn(AdzanPrayer.subuh), isFalse);
    expect(reloaded.isPrayerOn(AdzanPrayer.dzuhur), isTrue);
    expect(reloaded.adzanRemindMinutes, 10);
  });

  test('label waktu sholat tidak pernah kosong', () {
    for (final key in AdzanPrayer.all) {
      expect(AdzanPrayer.label(key), isNotEmpty);
    }
  });
}
