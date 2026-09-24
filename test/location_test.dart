import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  test('default: lokasi masjid, tanpa koordinat GPS', () {
    final notifier = LocationNotifier();
    expect(notifier.state.name, kDefaultLocationName);
    expect(notifier.state.isGps, isFalse);
  });

  test('lokasi GPS tersimpan dan terbaca ulang', () async {
    SharedPreferences.setMockInitialValues({
      'location_name': 'Cibubur, Kota Jakarta Timur',
      'location_lat': -6.3728,
      'location_lng': 106.8811,
    });
    await PreferencesService.init();

    final notifier = LocationNotifier();
    expect(notifier.state.name, 'Cibubur, Kota Jakarta Timur');
    expect(notifier.state.isGps, isTrue);

    await notifier.reset();
    expect(notifier.state.isGps, isFalse);
    expect(LocationNotifier().state.name, kDefaultLocationName);
  });

  test('nama lokasi diambil dari subLocality + locality, tanpa duplikat', () {
    expect(
      placeNameOrCoords(
        [
          Placemark(
            subLocality: 'Cibubur',
            locality: 'Kota Jakarta Timur',
            country: 'Indonesia',
          ),
        ],
        -6.37,
        106.88,
      ),
      'Cibubur, Kota Jakarta Timur',
    );

    expect(
      placeNameOrCoords(
        [Placemark(subLocality: 'Jakarta', locality: 'Jakarta')],
        -6.2,
        106.8,
      ),
      'Jakarta',
    );
  });

  test('reverse-geocode kosong -> pakai koordinat', () {
    expect(placeNameOrCoords(const [], -6.3728, 106.8811), '-6.373, 106.881');
  });
}
