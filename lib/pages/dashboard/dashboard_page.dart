import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/artikel_model.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/pages/artikel/component/artikel_card.dart';
import 'package:masjid_app/pages/dashboard/component/count_down.dart';
import 'package:masjid_app/pages/dashboard/component/dashboard_header.dart';
import 'package:masjid_app/pages/dashboard/component/dashboard_menu_grid.dart';
import 'package:masjid_app/pages/dashboard/component/prayer_times_card.dart';
import 'package:masjid_app/pages/dashboard/component/quick_quran_card.dart';
import 'package:masjid_app/pages/dashboard/component/ramadhan_menu.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.hasClients && _scrollController.offset > 50;
    if (scrolled != _isScrolled) {
      setState(() {
        _isScrolled = scrolled;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String _cleanText(String text) {
    if (text.isEmpty) return '';
    return text
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'</?p>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isScrolled ? Brightness.dark : Brightness.light,
      statusBarBrightness: _isScrolled ? Brightness.light : Brightness.dark,
    );

    final artikelAsync = ref.watch(artikelTerbaruProvider);
    final doaAsync = ref.watch(doaListProvider(const DoaListParams(categoryId: '1')));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF7F2),
        body: Stack(
          children: [
            RefreshIndicator(
              color: const Color(0xFFD06A4C),
              backgroundColor: Colors.white,
              onRefresh: () async {
            ref.invalidate(jadwalShalatProvider);
            ref.invalidate(artikelTerbaruProvider);
            ref.invalidate(doaListProvider(const DoaListParams(categoryId: '1')));
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Profil & Lokasi Islami Elegan
                const DashboardHeader(),

                // Konten Utama Beranda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 2. Kartu Waktu Shalat Realtime
                      const PrayerTimesCard(),

                      // 3. Kartu Cepat "Lanjutkan Tilawah" Al-Qur'an (Minimalis)
                      const QuickQuranCard(),

                      // 4. Grid Layanan & Ibadah
                      const DashboardMenuGrid(),

                      // 5. Countdown Ramadhan / Event Khusus
                      const SizedBox(height: 14),
                      const CountDownWidget(),

                      // 6. Menu Imsakiyah & Penanggalan Ramadhan
                      const SizedBox(height: 14),
                      const RamadhanMenuWidget(),

                      const SizedBox(height: 22),

                      // 7. Doa Pilihan (Kartu Inspirasi Doa Harian)
                      _buildSeparator(
                        'Doa Pilihan',
                        'Lihat Semua',
                        context,
                        () => context.push(AppRoutes.doa),
                      ),
                      const SizedBox(height: 10),
                      Skeletonizer(
                        enabled: doaAsync.isLoading,
                        child: _buildDoaSlider(doaAsync.valueOrNull ?? [], context),
                      ),

                      const SizedBox(height: 22),

                      // 8. Artikel Terbaru (Featured & Compact Magazine Style)
                      _buildSeparator(
                        'Artikel Terbaru',
                        'Lihat Semua',
                        context,
                        () => context.push(AppRoutes.artikel),
                      ),
                      const SizedBox(height: 10),
                      Skeletonizer(
                        enabled: artikelAsync.isLoading,
                        child: _buildArtikelList(
                          artikelAsync.valueOrNull ?? [],
                          context,
                        ),
                      ),

                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Pelindung status bar saat di-scroll
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: MediaQuery.of(context).padding.top,
            color: _isScrolled
                ? const Color(0xFFFBF7F2).withValues(alpha: 0.96)
                : Colors.transparent,
          ),
        ),
      ],
    ),
  ),
);
  }

  Widget _buildSeparator(
    String title,
    String? sub,
    BuildContext context,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFD06A4C),
            fontSize: 16,
            letterSpacing: 0.1,
          ),
        ),
        if (sub != null && sub.isNotEmpty)
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xFFD06A4C),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Color(0xFFD06A4C),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Slider Doa bergaya Kartu Inspirasi / Quote Card Islami
  Widget _buildDoaSlider(List<DoaItemModel> list, BuildContext context) {
    return SizedBox(
      height: 142,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: list.isEmpty ? 3 : list.length,
        itemBuilder: (context, index) {
          final item = list.isNotEmpty ? list[index] : null;

          return Container(
            width: 230,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFF5FAF8),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFDCECE7),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD06A4C).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: item == null
                    ? null
                    : () => context.push(
                          AppRoutes.doaContent
                              .replaceFirst(':id', '1')
                              .replaceFirst(':content', item.id.toString()),
                          extra: {
                            'categoryName': 'Doa Pilihan',
                            'doaItem': item,
                          },
                        ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header Kartu Doa
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.auto_stories_rounded,
                              size: 15,
                              color: Color(0xFFD06A4C),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECA843).withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Doa Pilihan',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9E780A),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Konten Judul & Makna Doa
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _cleanText(item?.judul ?? 'Doa Harian'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFFD06A4C),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item?.arti.isNotEmpty == true
                                ? _cleanText(item!.arti)
                                : 'Doa harian untuk ketenangan hati dan keberkahan hidup.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),

                      // Footer Aksi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item?.riwayat.isNotEmpty == true
                                ? _cleanText(item!.riwayat)
                                : 'Shahih',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFD06A4C),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Row(
                            children: [
                              Text(
                                'Baca',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD06A4C),
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 9,
                                color: Color(0xFFD06A4C),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// List Artikel bergaya Majalah Islami (1 Featured + Compact List).
  /// Kartunya dari [ArtikelCard] — sama dengan halaman daftar & detail artikel.
  Widget _buildArtikelList(List<ArtikelModel> list, BuildContext context) {
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFE7DE)),
        ),
        child: const Center(
          child: Text(
            'Belum ada artikel terbaru',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < list.length; i++)
          ArtikelCard(
            judul: list[i].judul,
            image: list[i].thumbnail,
            dateLabel: formatArtikelDate(list[i].createdAt),
            featured: i == 0,
            onTap: () => context.push(
              AppRoutes.artikelDetail.replaceFirst(':id', '${list[i].id}'),
            ),
          ),
      ],
    );
  }
}
