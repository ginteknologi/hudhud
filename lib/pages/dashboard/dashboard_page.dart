import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/artikel_model.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/pages/artikel/component/artikel_card.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';
import 'package:masjid_app/pages/dashboard/component/count_down.dart';
import 'package:masjid_app/pages/dashboard/component/dashboard_header.dart';
import 'package:masjid_app/pages/dashboard/component/dashboard_menu_grid.dart';
import 'package:masjid_app/pages/dashboard/component/prayer_times_card.dart';
import 'package:masjid_app/pages/dashboard/component/quick_quran_card.dart';
import 'package:masjid_app/pages/dashboard/component/ramadhan_menu.dart';
import 'package:masjid_app/pages/dashboard/component/sedang_live.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:masjid_app/providers/dashboard_data_providers.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';
import 'package:masjid_app/providers/kajian_provider.dart';
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isScrolled ? Brightness.dark : Brightness.light,
      statusBarBrightness: _isScrolled ? Brightness.light : Brightness.dark,
    );

    final sedangLiveAsync = ref.watch(sedangLiveListProvider);
    final kajianLiveAsync = ref.watch(kajianLiveSliderProvider);
    final kajianSliderAsync = ref.watch(kajianSliderProvider('tafsir'));
    final artikelAsync = ref.watch(artikelTerbaruProvider);
    final doaAsync = ref.watch(doaListProvider(const DoaListParams(categoryId: '1')));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: RefreshIndicator(
          color: const Color(0xFF048C7C),
          backgroundColor: Colors.white,
          onRefresh: () async {
            ref.invalidate(jadwalShalatProvider);
            ref.invalidate(sedangLiveListProvider);
            ref.invalidate(kajianLiveSliderProvider);
            ref.invalidate(kajianSliderProvider('tafsir'));
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

                      // 4. Grid 10 Layanan Masjid & Ibadah
                      const DashboardMenuGrid(),

                      // 5. Sedang Live (Jika ada data)
                      SedangLiveWidget(
                        listSedangLive: sedangLiveAsync.valueOrNull ?? [],
                      ),

                      // 6. Countdown Ramadhan / Event Khusus
                      const SizedBox(height: 14),
                      const CountDownWidget(),

                      // 7. Menu Imsakiyah & Penanggalan Ramadhan
                      const SizedBox(height: 14),
                      const RamadhanMenuWidget(),

                      const SizedBox(height: 22),

                      // 8. Doa Pilihan (Kartu Inspirasi Doa Harian)
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

                      // 9. Riwayat Kajian Live (Video Card Interaktif)
                      _buildSeparator(
                        'Riwayat Kajian Live',
                        'Lihat Semua',
                        context,
                        () => context.push(AppRoutes.kajianLive),
                      ),
                      const SizedBox(height: 10),
                      Skeletonizer(
                        enabled: kajianLiveAsync.isLoading,
                        child: _buildKajianSlider(
                          kajianLiveAsync.valueOrNull ?? [],
                          tag: 'Kajian Live',
                          badgeColor: const Color(0xFFE53935),
                          context: context,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // 10. Kajian Tafsir Quran (Video Card Interaktif)
                      _buildSeparator(
                        'Kajian Tafsir Quran',
                        'Lihat Semua',
                        context,
                        () => context.push(AppRoutes.kajianTafsir),
                      ),
                      const SizedBox(height: 10),
                      Skeletonizer(
                        enabled: kajianSliderAsync.isLoading,
                        child: _buildKajianSlider(
                          kajianSliderAsync.valueOrNull ?? [],
                          tag: 'Tafsir Qur’an',
                          badgeColor: const Color(0xFF048C7C),
                          context: context,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // 11. Artikel Terbaru (Featured & Compact Magazine Style)
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
            color: Color(0xFF137065),
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
                      color: Color(0xFF048C7C),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Color(0xFF048C7C),
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
                  color: const Color(0xFF048C7C).withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push(AppRoutes.doa),
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
                              color: Color(0xFF048C7C),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9D576).withValues(alpha: 0.25),
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
                              color: Color(0xFF137065),
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
                              color: Color(0xFF048C7C),
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
                                  color: Color(0xFF048C7C),
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 9,
                                color: Color(0xFF048C7C),
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

  /// Slider Kajian — kartu dari [KajianCard]
  Widget _buildKajianSlider(
    List<KajianModel> list, {
    required String tag,
    required Color badgeColor,
    required BuildContext context,
  }) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: list.isEmpty ? 3 : list.length,
        itemBuilder: (context, index) {
          final item = list.isNotEmpty ? list[index] : null;

          return KajianCard(
            item: item,
            tag: tag,
            badgeColor: badgeColor,
            onTap: item == null
                ? null
                : () => context.push(
                      AppRoutes.kajianDetail.replaceFirst(
                        ':id',
                        '${item.id}',
                      ),
                      extra: item,
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
          border: Border.all(color: const Color(0xFFE2EBE8)),
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
