import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/core/storage/bookmark_storage.dart';

/// State bookmark per jenis tilawah ("ayat", "indonesia", "madinah", "tajwid").
/// Pengganti AlquranController (GetX) — UI-nya kini di alquran_page.dart.
class AlquranBookmarkNotifier extends StateNotifier<BookmarkData> {
  AlquranBookmarkNotifier(this.storageName)
      : _storage = BookmarkStorage(storageName),
        super(BookmarkData(
            namaSurat: "Belum ada bookmark", surat: 0, ayat: 0, totalAyat: 0)) {
    reload();
  }

  final String storageName;
  final BookmarkStorage _storage;

  void reload() => state = _storage.getBookmark();

  void save(BookmarkData bookmark) {
    _storage.saveBookmark(bookmark);
    state = bookmark;
  }
}

final alquranBookmarkProvider =
    StateNotifierProvider.family<AlquranBookmarkNotifier, BookmarkData, String>(
  (ref, storageName) => AlquranBookmarkNotifier(storageName),
);
