import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/artikel_model.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/models/kajian_model.dart';
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
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.tryParse(dateStr);
      if (dateTime != null) {
        return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
      }
    } catch (_) {}
    return dateStr;
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
    final kajianLiveAsync = ref.watch(kajianLiveListProvider);
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
            ref.invalidate(kajianLiveListProvider);
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
                        () {},
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
                        () {},
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

  /// Slider Kajian dengan Video Thumbnail & Play Button
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

          return Container(
            width: 215,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2EBE8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF048C7C).withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  if (item?.link.isNotEmpty == true) {
                    final uri = Uri.tryParse(item!.link);
                    if (uri != null) {
                      await launchUrl(uri);
                    }
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar Thumbnail Kajian
                    if (item?.image.isNotEmpty == true)
                      CachedNetworkImage(
                        imageUrl: item!.image,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _buildFallbackKajianImage(),
                      )
                    else
                      _buildFallbackKajianImage(),

                    // Gradient Overlay untuk Keterbacaan Teks
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),

                    // Badge di Pojok Kiri Atas
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                    // Play Button di Tengah Thumbnail
                    Center(
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.7),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Judul Kajian di Bawah
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item?.judul ?? 'Kajian Masjid',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item?.ustadz.isNotEmpty == true
                                ? item!.ustadz
                                : (item?.subjudul ?? 'Masjid An-Ni’mah'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFF9D576),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallbackKajianImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D6357),
            Color(0xFF1E8D7F),
          ],
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.25,
          child: Image.asset(
            'assets/icons/app_icon.png',
            height: 60,
            width: 60,
          ),
        ),
      ),
    );
  }

  /// List Artikel bergaya Majalah Islami (1 Featured + Compact List)
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

    final featured = list.first;
    final otherArticles = list.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Featured Article Card (Artikel Pilihan Paling Baru)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2EBE8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF048C7C).withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push(
                  AppRoutes.artikelDetail.replaceAll(':id', featured.id.toString()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Image Featured
                  SizedBox(
                    height: 125,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (featured.thumbnail.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: featured.thumbnail,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _buildFallbackKajianImage(),
                          )
                        else
                          _buildFallbackKajianImage(),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF048C7C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Artikel Utama',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title & Meta Featured
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _cleanText(featured.judul),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF137065),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: Color(0xFF048C7C),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(featured.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF048C7C),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text(
                                  'Baca Selengkapnya',
                                  style: TextStyle(
                                    color: Color(0xFF048C7C),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 10,
                                  color: Color(0xFF048C7C),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. Artikel Lainnya (Compact Style)
        ...otherArticles.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE2EBE8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF048C7C).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  context.push(
                    AppRoutes.artikelDetail.replaceAll(':id', item.id.toString()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: item.thumbnail.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: item.thumbnail,
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Image.asset(
                                  'assets/icons/app_icon.png',
                                  width: 68,
                                  height: 68,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/icons/app_icon.png',
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _cleanText(item.judul),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF2C3E50),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 12,
                                  color: Color(0xFF048C7C),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(item.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF048C7C),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
        }),
      ],
    );
  }
}
