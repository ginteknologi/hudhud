import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/core/storage/bookmark_storage.dart';

class QuickQuranCard extends StatefulWidget {
  const QuickQuranCard({super.key});

  @override
  State<QuickQuranCard> createState() => _QuickQuranCardState();
}

class _QuickQuranCardState extends State<QuickQuranCard> {
  final BookmarkStorage _ayatStorage = BookmarkStorage("ayat");
  final BookmarkStorage _indonesiaStorage = BookmarkStorage("indonesia");
  final BookmarkStorage _madinahStorage = BookmarkStorage("madinah");
  final BookmarkStorage _tajwidStorage = BookmarkStorage("tajwid");

  late BookmarkData _ayatBookmark;
  late BookmarkData _indonesiaBookmark;
  late BookmarkData _madinahBookmark;
  late BookmarkData _tajwidBookmark;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    _ayatBookmark = _ayatStorage.getBookmark();
    _indonesiaBookmark = _indonesiaStorage.getBookmark();
    _madinahBookmark = _madinahStorage.getBookmark();
    _tajwidBookmark = _tajwidStorage.getBookmark();
  }

  @override
  Widget build(BuildContext context) {
    final hasAyat = _ayatBookmark.surat > 0;
    final hasMushaf = _indonesiaBookmark.index > 0 ||
        _madinahBookmark.index > 0 ||
        _tajwidBookmark.index > 0;

    String surahName = 'Al-Fatihah';
    String detailText = 'Ayat 1 • Mulai Tilawah';
    VoidCallback onContinue = () async {
      await context.push(AppRoutes.quranPerAyat);
      if (mounted) setState(_loadBookmarks);
    };

    if (hasAyat) {
      surahName = _ayatBookmark.namaSurat.isNotEmpty
          ? _ayatBookmark.namaSurat
          : 'Surah ${_ayatBookmark.surat}';
      detailText = 'Ayat ${_ayatBookmark.ayat} • Terakhir Dibaca';
      onContinue = () async {
        await context.push(
          '${AppRoutes.quranPerAyat}?surah=${_ayatBookmark.surat}&ayat=${_ayatBookmark.ayat}',
        );
        if (mounted) setState(_loadBookmarks);
      };
    } else if (hasMushaf) {
      if (_indonesiaBookmark.index > 0) {
        surahName = _indonesiaBookmark.namaSurat.isNotEmpty
            ? _indonesiaBookmark.namaSurat
            : 'Mushaf Standar';
        detailText = 'Hal. ${_indonesiaBookmark.index} • Terakhir Dibaca';
        onContinue = () async {
          await context.push('${AppRoutes.quranPage}?bookmarks=true');
          if (mounted) setState(_loadBookmarks);
        };
      } else if (_madinahBookmark.index > 0) {
        surahName = _madinahBookmark.namaSurat.isNotEmpty
            ? _madinahBookmark.namaSurat
            : 'Mushaf Madinah';
        detailText = 'Hal. ${_madinahBookmark.index} • Terakhir Dibaca';
        onContinue = () async {
          await context.push('${AppRoutes.quranPageMadinah}?bookmarks=true');
          if (mounted) setState(_loadBookmarks);
        };
      } else {
        surahName = _tajwidBookmark.namaSurat.isNotEmpty
            ? _tajwidBookmark.namaSurat
            : 'Mushaf Tajwid';
        detailText = 'Hal. ${_tajwidBookmark.index} • Terakhir Dibaca';
        onContinue = () async {
          await context.push('${AppRoutes.quranPageTajwid}?bookmarks=true');
          if (mounted) setState(_loadBookmarks);
        };
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEFE7DE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD06A4C).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onContinue,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                // Minimalist Quran Bookmark Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7EBE4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFF0D6C8),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.bookmark_added_rounded,
                    color: Color(0xFFD06A4C),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // Surah & Reading Position Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              surahName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF2B2523),
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7EBE4),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Tilawah',
                              style: TextStyle(
                                color: Color(0xFFD06A4C),
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        detailText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Action Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD06A4C),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD06A4C).withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lanjut',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 9,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
