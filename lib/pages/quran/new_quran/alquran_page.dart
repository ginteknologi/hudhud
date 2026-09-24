import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:masjid_app/storage/bookmarkStorage.dart';
import 'package:share_plus/share_plus.dart';

class AlquranPage extends ConsumerStatefulWidget {
  const AlquranPage({super.key});

  @override
  ConsumerState<AlquranPage> createState() => _AlquranPageState();
}

class _AlquranPageState extends ConsumerState<AlquranPage> {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _loadBookmarks();
  }

  void _loadBookmarks() {
    _ayatBookmark = _ayatStorage.getBookmark();
    _indonesiaBookmark = _indonesiaStorage.getBookmark();
    _madinahBookmark = _madinahStorage.getBookmark();
    _tajwidBookmark = _tajwidStorage.getBookmark();
  }

  // The readers are self-contained (tabbed mushaf + their own surah picker), so
  // each tile just pushes its route — same as the pre-migration Get.toNamed(route).
  Future<void> _openReader(String route, {bool bookmarks = false}) async {
    await context.push(bookmarks ? '$route?bookmarks=true' : route);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (mounted) {
      setState(_loadBookmarks);
    }
  }

  void _showRandomAyatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Consumer(
            builder: (context, ref, _) {
              final randomAsync = ref.watch(randomAyatProvider);

              return randomAsync.when(
                data: (data) {
                  final arab = data['arab'] ?? 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
                  final terjemahan = data['indonesia'] ?? 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.';
                  final surat = data['surat'] ?? 'Al-Fatihah';
                  final ayat = data['nomor_ayat'] ?? '1';

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(dialogContext).pop(),
                            ),
                            Text(
                              '$surat : $ayat',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, size: 20),
                              onPressed: () {
                                SharePlus.instance.share(
                                  ShareParams(
                                    text: '$arab\n\n$terjemahan\n\n($surat : $ayat)',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          arab,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: GoogleFonts.amiriQuran().fontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          terjemahan,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ButtonElevated(
                          title: 'Acak Lagi',
                          iconLeft: const Icon(Icons.refresh, color: Colors.white, size: 18),
                          showIcon: 'left',
                          bgcolor: Theme.of(context).primaryColor,
                          height: 40,
                          color: Colors.white,
                          radius: 8,
                          shadow: false,
                          onPressed: () {
                            ref.invalidate(randomAyatProvider);
                          },
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Gagal memuat ayat acak'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(randomAyatProvider),
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final listMenu = [
      {
        'title': 'Per Ayat',
        'icon': 'assets/icons/perayat.png',
        'onTap': () => _openReader(AppRoutes.quranPerAyat),
      },
      {
        'title': 'Indonesia',
        'icon': 'assets/icons/indonesia.png',
        'onTap': () => _openReader(AppRoutes.quranPage),
      },
      {
        'title': 'Madinah',
        'icon': 'assets/icons/madinah.png',
        'onTap': () => _openReader(AppRoutes.quranPageMadinah),
      },
      {
        'title': 'Tajwid Indonesia',
        'icon': 'assets/icons/tajwid.png',
        'onTap': () => _openReader(AppRoutes.quranPageTajwid),
      },
      {
        'title': 'Ayat Kejutan',
        'icon': 'assets/icons/kejutan.png',
        'onTap': () => _showRandomAyatDialog(context),
      },
      {
        'title': 'Pengaturan',
        'icon': 'assets/icons/pengaturan.png',
        'onTap': () => _openReader(AppRoutes.quranPengaturan),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Al-Quran
              Container(
                width: screenWidth,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xFF137065), Color(0xFF4CB4A7)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Yuk mulai tilawah Quran !',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bacalah kalian Al-Quran, karena ia akan datang pada hari kiamat kelak sebagai pemberi syafa’at.',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/img/quran_banner.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Grid Menu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listMenu.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = listMenu[index];
                    return InkWell(
                      onTap: item['onTap'] as void Function()?,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F4F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              item['icon'] as String,
                              height: 38,
                              width: 38,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Bookmark Tilawah
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bookmark Tilawah Anda',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    _buildBookmarkTile(
                      title: 'Tilawah Perayat',
                      bookmark: _ayatBookmark,
                      onTap: () => _openReader(AppRoutes.quranPerAyat, bookmarks: true),
                    ),
                    const SizedBox(height: 8),
                    _buildBookmarkTile(
                      title: 'Tilawah Indonesia',
                      bookmark: _indonesiaBookmark,
                      onTap: () => _openReader(AppRoutes.quranPage, bookmarks: true),
                    ),
                    const SizedBox(height: 8),
                    _buildBookmarkTile(
                      title: 'Tilawah Tajwid Indonesia',
                      bookmark: _tajwidBookmark,
                      onTap: () => _openReader(AppRoutes.quranPageTajwid, bookmarks: true),
                    ),
                    const SizedBox(height: 8),
                    _buildBookmarkTile(
                      title: 'Tilawah Madinah',
                      bookmark: _madinahBookmark,
                      onTap: () => _openReader(AppRoutes.quranPageMadinah, bookmarks: true),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkTile({
    required String title,
    required BookmarkData bookmark,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF048C7C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          bookmark.totalAyat == 0
              ? (bookmark.namaSurat.isNotEmpty ? bookmark.namaSurat : 'Belum ada bookmark')
              : '${bookmark.namaSurat} (${bookmark.ayat}:${bookmark.totalAyat})',
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ),
    );
  }
}
