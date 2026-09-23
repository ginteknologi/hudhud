import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/lokasi_saya_data.dart';

class LokasiStorage {
  void saveLokasi(LokasiSayaData lokasi) {
    PreferencesService.setString('keteranganLokasi', lokasi.keteranganLokasi);
    PreferencesService.setString('lat', lokasi.lat.toString());
    PreferencesService.setString('long', lokasi.long.toString());
    PreferencesService.setString('gpsizin', lokasi.gpsizin.toString());
  }

  LokasiSayaData getLokasi() {
    final keterangan = PreferencesService.getString('keteranganLokasi');
    if (keterangan == null) {
      return LokasiSayaData(
        keteranganLokasi: 'Silahkan mengaktifkan izin lokasi',
        lat: 0.0,
        long: 0.0,
        gpsizin: false,
      );
    } else {
      final latStr = PreferencesService.getString('lat');
      final longStr = PreferencesService.getString('long');
      final gpsStr = PreferencesService.getString('gpsizin');

      return LokasiSayaData(
        keteranganLokasi: keterangan,
        lat: double.tryParse(latStr ?? '') ?? 0.0,
        long: double.tryParse(longStr ?? '') ?? 0.0,
        gpsizin: gpsStr == 'true',
      );
    }
  }

  void removeLokasi() {
    PreferencesService.remove('keteranganLokasi');
    PreferencesService.remove('lat');
    PreferencesService.remove('long');
    PreferencesService.remove('gpsizin');
  }
}
