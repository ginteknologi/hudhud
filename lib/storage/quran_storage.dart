import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/bookmark_data.dart';

class QuranStorage {
  void saveBookmark(BookmarkData bookmark, [String type = 'ayat']) {
    PreferencesService.setString('${type}_namaSurat', bookmark.namaSurat);
    PreferencesService.setString('${type}_surat', bookmark.surat.toString());
    PreferencesService.setString('${type}_ayat', bookmark.ayat.toString());
    PreferencesService.setString('${type}_totalAyat', bookmark.totalAyat.toString());
    PreferencesService.setString('${type}_index', bookmark.index.toString());
  }

  BookmarkData getBookmark([String type = 'ayat']) {
    final namaSurat = PreferencesService.getString('${type}_namaSurat') ?? '';
    final suratStr = PreferencesService.getString('${type}_surat');
    final ayatStr = PreferencesService.getString('${type}_ayat');
    final totalAyatStr = PreferencesService.getString('${type}_totalAyat');
    final indexStr = PreferencesService.getString('${type}_index');

    return BookmarkData(
      namaSurat: namaSurat,
      surat: int.tryParse(suratStr ?? '') ?? 0,
      ayat: int.tryParse(ayatStr ?? '') ?? 0,
      totalAyat: int.tryParse(totalAyatStr ?? '') ?? 0,
      index: int.tryParse(indexStr ?? '') ?? 0,
    );
  }

  // Fungsi untuk menyimpan riwayat bacaan terakhir
  void saveLastRead({
    required String namaSurat,
    required int surat,
    required int ayat,
    int? totalAyat,
    int? index,
  }) {
    PreferencesService.setString('last_read_namaSurat', namaSurat);
    PreferencesService.setString('last_read_surat', surat.toString());
    PreferencesService.setString('last_read_ayat', ayat.toString());
    if (totalAyat != null) PreferencesService.setString('last_read_totalAyat', totalAyat.toString());
    if (index != null) PreferencesService.setString('last_read_index', index.toString());
  }

  // Fungsi untuk mengambil data riwayat bacaan
  Map<String, dynamic> getLastRead() {
    return {
      'namaSurat': PreferencesService.getString('last_read_namaSurat'),
      'surat': int.tryParse(PreferencesService.getString('last_read_surat') ?? ''),
      'ayat': int.tryParse(PreferencesService.getString('last_read_ayat') ?? ''),
      'totalAyat': int.tryParse(PreferencesService.getString('last_read_totalAyat') ?? ''),
      'index': int.tryParse(PreferencesService.getString('last_read_index') ?? ''),
    };
  }

  // Fungsi untuk menghapus riwayat bacaan (dipanggil saat logout)
  void removeQuranHistory() {
    PreferencesService.remove('last_read_namaSurat');
    PreferencesService.remove('last_read_surat');
    PreferencesService.remove('last_read_ayat');
    PreferencesService.remove('last_read_totalAyat');
    PreferencesService.remove('last_read_index');
  }
}
