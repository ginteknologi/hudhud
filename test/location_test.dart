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

  test('default location has no coordinates until detected or selected', () {
    final notifier = LocationNotifier();
    expect(notifier.state.name, kDefaultLocationName);
    expect(notifier.state.hasCoordinates, isFalse);
    expect(notifier.state.latitude, isNull);
    expect(notifier.state.longitude, isNull);
    expect(notifier.state.isDeviceLocation, isFalse);
  });

  test('manual location is saved without being marked as device GPS', () async {
    final notifier = LocationNotifier();
    await notifier.setManualLocation(
      name: 'Makassar',
      latitude: -5.1477,
      longitude: 119.4327,
      timeZoneId: 'Asia/Makassar',
    );

    expect(notifier.state.hasCoordinates, isTrue);
    expect(notifier.state.isDeviceLocation, isFalse);
    expect(notifier.state.timeZoneId, 'Asia/Makassar');
    expect(LocationNotifier().state.name, 'Makassar');
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
