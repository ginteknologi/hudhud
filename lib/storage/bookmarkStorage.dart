import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/models/bookmarkData.dart';

class BookmarkStorage {
  final String storageName;
  BookmarkStorage(this.storageName);
  final box = GetStorage();

  void saveBookmark(bookmarkData bookmark) {
    box.write('${storageName}_namaSurat', bookmark.namaSurat);
    box.write('${storageName}_surat', bookmark.surat);
    box.write('${storageName}_ayat', bookmark.ayat);
    box.write('${storageName}_totalAyat', bookmark.totalAyat);
    box.write('${storageName}_index', bookmark.index);
  }

  bookmarkData getBookmark() {
    return bookmarkData(
      namaSurat: box.read('${storageName}_namaSurat') ?? '',
      surat: box.read('${storageName}_surat') ?? 0,
      ayat: box.read('${storageName}_ayat') ?? 0,
      totalAyat: box.read('${storageName}_totalAyat') ?? 0,
      index: box.read('${storageName}_index') ?? 0,
    );
  }
}
