import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/storage/bookmarkStorage.dart';

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
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF0D6357),
            Color(0xFF137065),
            Color(0xFF1A8A7D),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onContinue,
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.white.withValues(alpha: 0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                // Minimalist Quran Bookmark Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFF9D576).withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.bookmark_added_rounded,
                    color: Color(0xFFF9D576),
                    size: 19,
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
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
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
                              color: const Color(0xFFF9D576).withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Tilawah',
                              style: TextStyle(
                                color: Color(0xFFF9D576),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
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
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Minimalist Action Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lanjut',
                        style: TextStyle(
                          color: Color(0xFF048C7C),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 9,
                        color: Color(0xFF048C7C),
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
