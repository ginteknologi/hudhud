import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/bookmark_data.dart';

class BookmarkStorage {
  final String storageName;
  BookmarkStorage(this.storageName);

  void saveBookmark(BookmarkData bookmark) {
    PreferencesService.setString(
        '${storageName}_namaSurat', bookmark.namaSurat);
    PreferencesService.setString(
        '${storageName}_surat', bookmark.surat.toString());
    PreferencesService.setString(
        '${storageName}_ayat', bookmark.ayat.toString());
    PreferencesService.setString(
        '${storageName}_totalAyat', bookmark.totalAyat.toString());
    PreferencesService.setString(
        '${storageName}_index', bookmark.index.toString());
  }

  void clearBookmark() {
    for (final field in ['namaSurat', 'surat', 'ayat', 'totalAyat', 'index']) {
      PreferencesService.remove('${storageName}_$field');
    }
  }

  BookmarkData getBookmark() {
    final namaSurat =
        PreferencesService.getString('${storageName}_namaSurat') ?? '';
    final suratStr = PreferencesService.getString('${storageName}_surat');
    final ayatStr = PreferencesService.getString('${storageName}_ayat');
    final totalAyatStr =
        PreferencesService.getString('${storageName}_totalAyat');
    final indexStr = PreferencesService.getString('${storageName}_index');

    return BookmarkData(
      namaSurat: namaSurat,
      surat: int.tryParse(suratStr ?? '') ?? 0,
      ayat: int.tryParse(ayatStr ?? '') ?? 0,
      totalAyat: int.tryParse(totalAyatStr ?? '') ?? 0,
      index: int.tryParse(indexStr ?? '') ?? 0,
    );
  }
}
