import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/models/lokasi_saya_data.dart';

class LokasiStorage {
  final box = GetStorage();

  void saveLokasi(LokasiSayaData lokasi) {
    box.write('keteranganLokasi', lokasi.keteranganLokasi);
    box.write('lat', lokasi.lat);
    box.write('long', lokasi.long);
    box.write('gpsizin', lokasi.gpsizin);
  }

  LokasiSayaData getLokasi() {
    if (box.read('keteranganLokasi') == null) {
      return LokasiSayaData(
        keteranganLokasi: 'Silahkan mengaktifkan izin lokasi',
        lat: 0.0,
        long: 0.0,
        gpsizin: false,
      );
    } else {
      return LokasiSayaData(
        keteranganLokasi: box.read('keteranganLokasi') ?? '',
        lat: box.read('lat') ?? 0,
        long: box.read('long') ?? 0,
        gpsizin: box.read('gpsizin') ?? false,
      );
    }
  }

  void removeLokasi() {
    box.remove('keteranganLokasi');
    box.remove('lat');
    box.remove('long');
    box.remove('gpsizin');
  }
}
