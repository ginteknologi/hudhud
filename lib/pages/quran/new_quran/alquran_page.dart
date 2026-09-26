import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:masjid_app/storage/bookmarkStorage.dart';
import 'package:share_plus/share_plus.dart';

class AlquranPage extends ConsumerStatefulWidget {
  const AlquranPage({super.key});

  @override
  ConsumerState<AlquranPage> createState() => _AlquranPageState();
}

class _AlquranPageState extends ConsumerState<AlquranPage>
    with SingleTickerProviderStateMixin {
  final BookmarkStorage _ayatStorage = BookmarkStorage("ayat");
  final BookmarkStorage _indonesiaStorage = BookmarkStorage("indonesia");
  final BookmarkStorage _madinahStorage = BookmarkStorage("madinah");
  final BookmarkStorage _tajwidStorage = BookmarkStorage("tajwid");

  late BookmarkData _ayatBookmark;
  late BookmarkData _indonesiaBookmark;
  late BookmarkData _madinahBookmark;
  late BookmarkData _tajwidBookmark;

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _tabController = TabController(length: 4, vsync: this);
    _loadBookmarks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadBookmarks() {
    _ayatBookmark = _ayatStorage.getBookmark();
    _indonesiaBookmark = _indonesiaStorage.getBookmark();
    _madinahBookmark = _madinahStorage.getBookmark();
    _tajwidBookmark = _tajwidStorage.getBookmark();
  }

  Future<void> _openReader(String route, {bool bookmarks = false}) async {
    await context.push(bookmarks ? '$route?bookmarks=true' : route);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Consumer(
            builder: (context, ref, _) {
              final randomAsync = ref.watch(randomAyatProvider);

              return randomAsync.when(
                data: (data) {
                  final arab =
                      data['arab'] ?? 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
                  final terjemahan = data['indonesia'] ??
                      'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.';
                  final surat = data['surat'] ?? 'Al-Fatihah';
                  final ayat = data['nomor_ayat'] ?? '1';

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                              ),
                              Text(
                                '$surat : $ayat',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.share, size: 20),
                                onPressed: () {
                                  SharePlus.instance.share(
                                    ShareParams(
                                      text:
                                          '$arab\n\n$terjemahan\n\n($surat : $ayat)',
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
                            iconLeft: const Icon(Icons.refresh,
                                color: Colors.white, size: 18),
                            showIcon: 'left',
                            bgcolor: const Color(0xFF048C7C),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Baris Header: Judul & Aksi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Al-Qur'anul Karim",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF137065),
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Mari senantiasa istiqomah tilawah",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: "Ayat Kejutan",
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFFE6F4F2),
                                  foregroundColor: const Color(0xFF048C7C),
                                ),
                                icon:
                                    const Icon(Icons.shuffle_rounded, size: 20),
                                onPressed: () => _showRandomAyatDialog(context),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                tooltip: "Pengaturan",
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFFE6F4F2),
                                  foregroundColor: const Color(0xFF048C7C),
                                ),
                                icon: const Icon(Icons.settings_outlined,
                                    size: 20),
                                onPressed: () =>
                                    _openReader(AppRoutes.quranPengaturan),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Hero Card: Terakhir Dibaca
                      _buildLastReadCard(),
                      const SizedBox(height: 14),

                      // Kolom Pencarian
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            hintText:
                                "Cari surah (misal: Yasin, Al-Mulk, 36)...",
                            hintStyle: const TextStyle(
                                fontSize: 13, color: Colors.black38),
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF048C7C), size: 22),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        size: 18, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Persistent TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                    indicatorColor: const Color(0xFF048C7C),
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: const Color(0xFF048C7C),
                    unselectedLabelColor: Colors.black45,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13),
                    tabs: const [
                      Tab(text: "Surah"),
                      Tab(text: "Juz"),
                      Tab(text: "Mushaf"),
                      Tab(text: "Bookmark"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _buildSurahTab(),
              _buildJuzTab(),
              _buildMushafTab(),
              _buildBookmarkTab(),
            ],
          ),
        ),
      ),
    );
  }

  /// Hero Card menampilkan progress baca terakhir
  Widget _buildLastReadCard() {
    // Prioritas: Tilawah Per Ayat jika ada
    final hasAyat = _ayatBookmark.surat > 0;
    final hasMushaf = _indonesiaBookmark.index > 0 ||
        _madinahBookmark.index > 0 ||
        _tajwidBookmark.index > 0;

    String surahName = 'Al-Fatihah';
    String detailText = 'Mulai tilawah hari ini';
    VoidCallback onContinue = () => _openReader(AppRoutes.quranPerAyat);

    if (hasAyat) {
      surahName = _ayatBookmark.namaSurat;
      detailText = 'Ayat ke-${_ayatBookmark.ayat} • Tilawah Per Ayat';
      onContinue = () async {
        await context.push(
            '${AppRoutes.quranPerAyat}?surah=${_ayatBookmark.surat}&ayat=${_ayatBookmark.ayat}');
        if (mounted) setState(_loadBookmarks);
      };
    } else if (hasMushaf) {
      if (_indonesiaBookmark.index > 0) {
        surahName = _indonesiaBookmark.namaSurat.isNotEmpty
            ? _indonesiaBookmark.namaSurat
            : 'Mushaf Indonesia';
        detailText = 'Halaman ${_indonesiaBookmark.index} • Standar Kemenag';
        onContinue = () => _openReader(AppRoutes.quranPage, bookmarks: true);
      } else if (_madinahBookmark.index > 0) {
        surahName = _madinahBookmark.namaSurat.isNotEmpty
            ? _madinahBookmark.namaSurat
            : 'Mushaf Madinah';
        detailText = 'Halaman ${_madinahBookmark.index} • Rasm Utsmani';
        onContinue =
            () => _openReader(AppRoutes.quranPageMadinah, bookmarks: true);
      } else {
        surahName = _tajwidBookmark.namaSurat.isNotEmpty
            ? _tajwidBookmark.namaSurat
            : 'Mushaf Tajwid';
        detailText = 'Halaman ${_tajwidBookmark.index} • Tajwid Berwarna';
        onContinue =
            () => _openReader(AppRoutes.quranPageTajwid, bookmarks: true);
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D6357), Color(0xFF1E8D7F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bookmark_added_rounded,
                        color: Color(0xFFF9D576), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      hasAyat || hasMushaf
                          ? "Terakhir Dibaca"
                          : "Yuk Mulai Membaca",
                      style: const TextStyle(
                        color: Color(0xFFF9D576),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  surahName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detailText,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: onContinue,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hasAyat || hasMushaf ? "Lanjutkan" : "Buka Surah",
                          style: const TextStyle(
                            color: Color(0xFF048C7C),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 14, color: Color(0xFF048C7C)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            'assets/img/card_quran.png',
            width: 85,
            height: 85,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/img/quran_banner.png',
              width: 85,
              height: 85,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 1: Daftar 114 Surah
  Widget _buildSurahTab() {
    final surahAsync = ref.watch(surahListProvider(''));

    return surahAsync.when(
      data: (surahList) {
        if (surahList.isEmpty) {
          return const Center(child: Text("Data surah belum tersedia"));
        }

        final filtered = surahList.where((s) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return s.nama.toLowerCase().contains(q) ||
              s.arti.toLowerCase().contains(q) ||
              s.id.toString() == q;
        }).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                "Tidak ada surah yang cocok dengan pencarian Anda",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: Color(0xFFEBEBEB),
            indent: 58,
          ),
          itemBuilder: (context, index) {
            final item = filtered[index];
            final tipeName = item.tipe.toLowerCase().contains('mad')
                ? 'MADANIYAH'
                : 'MAKKIYAH';

            return InkWell(
              onTap: () async {
                await context
                    .push('${AppRoutes.quranPerAyat}?surah=${item.id}');
                if (mounted) setState(_loadBookmarks);
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    // Badge Nomor Surah Islami
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/list_star.svg',
                          height: 38,
                          width: 38,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF048C7C),
                            BlendMode.srcIn,
                          ),
                        ),
                        Text(
                          '${item.id}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF048C7C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Info Nama Latin & Terjemahan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nama,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$tipeName • ${item.jumlahAyat} AYAT${item.arti.isNotEmpty ? ' • ${item.arti}' : ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Nama Arab
                    Text(
                      item.asma,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: GoogleFonts.amiriQuran().fontFamily,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF048C7C),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF048C7C)),
      ),
      error: (_, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Gagal memuat daftar surah"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ref.invalidate(surahListProvider('')),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }

  /// Tab 2: Daftar 30 Juz
  Widget _buildJuzTab() {
    final filteredJuz = kQuranJuzList.where((j) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return j.name.toLowerCase().contains(q) ||
          j.startSurahName.toLowerCase().contains(q) ||
          j.juzNumber.toString() == q;
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: filteredJuz.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0xFFEBEBEB),
        indent: 58,
      ),
      itemBuilder: (context, index) {
        final juz = filteredJuz[index];

        return InkWell(
          onTap: () async {
            // Langsung buka mushaf ke halaman awal juz tersebut
            await context.push('${AppRoutes.quranPage}?page=${juz.startPage}');
            if (mounted) setState(_loadBookmarks);
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                // Badge Nomor Juz
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${juz.juzNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF048C7C),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Info Juz
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${juz.name} • ${juz.startSurahName}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Mulai Ayat ${juz.startAyat} • Halaman ${juz.startPage}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Nama Arab Juz
                Text(
                  juz.arabicName,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: GoogleFonts.amiriQuran().fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF048C7C),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Tab 3: Pilihan Mushaf Per Halaman
  Widget _buildMushafTab() {
    final listMushaf = [
      {
        'title': 'Mushaf Standar Kemenag Indonesia',
        'desc': 'Mushaf cetak standar Kementerian Agama RI (15 baris pojok)',
        'route': AppRoutes.quranPage,
        'icon': 'assets/icons/indonesia.png',
        'bookmark': _indonesiaBookmark,
      },
      {
        'title': 'Mushaf Madinah (Utsmani)',
        'desc': 'Rasm Utsmani standar Percetakan Al-Qur\'an Raja Fahd',
        'route': AppRoutes.quranPageMadinah,
        'icon': 'assets/icons/madinah.png',
        'bookmark': _madinahBookmark,
      },
      {
        'title': 'Mushaf Tajwid Berwarna',
        'desc':
            'Dilengkapi panduan warna kaidah tajwid untuk kemudahan tilawah',
        'route': AppRoutes.quranPageTajwid,
        'icon': 'assets/icons/tajwid.png',
        'bookmark': _tajwidBookmark,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: listMushaf.length,
      itemBuilder: (context, index) {
        final item = listMushaf[index];
        final bm = item['bookmark'] as BookmarkData;
        final hasRead = bm.index > 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          child: InkWell(
            onTap: () => _openReader(item['route'] as String),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F4F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      item['icon'] as String,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item['desc'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              hasRead
                                  ? Icons.bookmark_added_rounded
                                  : Icons.menu_book_rounded,
                              size: 13,
                              color: const Color(0xFF048C7C),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hasRead
                                    ? 'Terakhir: Hal ${bm.index} (${bm.namaSurat})'
                                    : 'Mulai baca dari Halaman 1',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF048C7C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.black38),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Tab 4: Bookmark & Riwayat Baca
  Widget _buildBookmarkTab() {
    final bookmarks = [
      {
        'title': 'Tilawah Per Ayat',
        'subtitle': _ayatBookmark.surat > 0
            ? '${_ayatBookmark.namaSurat} : Ayat ${_ayatBookmark.ayat}'
            : 'Belum ada ayat yang ditandai',
        'route': AppRoutes.quranPerAyat,
        'hasData': _ayatBookmark.surat > 0,
        'icon': Icons.format_list_numbered_rounded,
      },
      {
        'title': 'Mushaf Kemenag Indonesia',
        'subtitle': _indonesiaBookmark.index > 0
            ? 'Halaman ${_indonesiaBookmark.index} (${_indonesiaBookmark.namaSurat})'
            : 'Belum ada halaman yang ditandai',
        'route': AppRoutes.quranPage,
        'hasData': _indonesiaBookmark.index > 0,
        'icon': Icons.auto_stories_rounded,
      },
      {
        'title': 'Mushaf Madinah',
        'subtitle': _madinahBookmark.index > 0
            ? 'Halaman ${_madinahBookmark.index} (${_madinahBookmark.namaSurat})'
            : 'Belum ada halaman yang ditandai',
        'route': AppRoutes.quranPageMadinah,
        'hasData': _madinahBookmark.index > 0,
        'icon': Icons.menu_book_rounded,
      },
      {
        'title': 'Mushaf Tajwid Warna',
        'subtitle': _tajwidBookmark.index > 0
            ? 'Halaman ${_tajwidBookmark.index} (${_tajwidBookmark.namaSurat})'
            : 'Belum ada halaman yang ditandai',
        'route': AppRoutes.quranPageTajwid,
        'hasData': _tajwidBookmark.index > 0,
        'icon': Icons.color_lens_rounded,
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            "Tanda Baca Tilawah Anda",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...bookmarks.map((bm) {
          final hasData = bm['hasData'] as bool;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: ListTile(
              onTap: () =>
                  _openReader(bm['route'] as String, bookmarks: hasData),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: hasData
                      ? const Color(0xFFE6F4F2)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  bm['icon'] as IconData,
                  color: hasData ? const Color(0xFF048C7C) : Colors.grey,
                  size: 20,
                ),
              ),
              title: Text(
                bm['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                bm['subtitle'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: hasData ? const Color(0xFF048C7C) : Colors.black45,
                ),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasData ? const Color(0xFF048C7C) : Colors.grey.shade300,
                  foregroundColor: hasData ? Colors.white : Colors.black54,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(60, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () =>
                    _openReader(bm['route'] as String, bookmarks: hasData),
                child: Text(
                  hasData ? 'Lanjut' : 'Buka',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate._tabBar != _tabBar;
  }
}
