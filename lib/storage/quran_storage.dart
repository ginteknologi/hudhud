import 'package:get_storage/get_storage.dart';

class QuranStorage {
  final box = GetStorage();

  // Fungsi untuk menyimpan riwayat bacaan terakhir
  void saveLastRead({
    required String namaSurat,
    required int surat,
    required int ayat,
    int? totalAyat,
    int? index,
  }) {
    box.write('namaSurat', namaSurat);
    box.write('surat', surat);
    box.write('ayat', ayat);
    if (totalAyat != null) box.write('totalAyat', totalAyat);
    if (index != null) box.write('index', index);
  }

  // Fungsi untuk mengambil data riwayat bacaan
  Map<String, dynamic> getLastRead() {
    return {
      'namaSurat': box.read('namaSurat'),
      'surat': box.read('surat'),
      'ayat': box.read('ayat'),
      'totalAyat': box.read('totalAyat'),
      'index': box.read('index'),
    };
  }

  // Fungsi untuk menghapus riwayat bacaan (dipanggil saat logout)
  void removeQuranHistory() {
    box.remove('namaSurat');
    box.remove('surat');
    box.remove('ayat');
    box.remove('totalAyat');
    box.remove('index');
  }
}
