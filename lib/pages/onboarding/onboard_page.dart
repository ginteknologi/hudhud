import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardSlideData {
  final String badge;
  final String title;
  final String description;
  final String imagePath;

  const _OnboardSlideData({
    required this.badge,
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class _OnboardPageState extends State<OnboardPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<_OnboardSlideData> _slides = [
    _OnboardSlideData(
      badge: 'JADWAL SHOLAT & ADZAN',
      title: 'Jadwal Sholat Presisi\nSesuai Lokasi Masjid',
      description:
          'Pantau waktu sholat 5 waktu akurat berdasarkan koordinat GPS masjid, lengkap dengan hitung mundur waktu berikutnya dan pengingat adzan otomatis.',
      imagePath: 'assets/img/pray-night.png',
    ),
    _OnboardSlideData(
      badge: 'MUSHAF DIGITAL LENGKAP',
      title: "Al-Qur'an 30 Juz\nDengan Audio Murottal",
      description:
          "Baca Al-Qur'an mushaf standar Indonesia dan Madinah, panduan tajwid berwarna, terjemahan resmi Kemenag RI, serta lantunan murottal dari qari pilihan.",
      imagePath: 'assets/img/alquran.png',
    ),
    _OnboardSlideData(
      badge: 'EKOSISTEM MASJID MODERN',
      title: "Makmurkan Masjid\nDalam Satu Genggaman",
      description:
          "Dapatkan jadwal kajian ilmiah, doa harian, kemudahan infaq digital, arah kiblat presisi, serta informasi terkini kegiatan masjid di Marbot App.",
      imagePath: 'assets/img/masjid.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish() {
    HapticFeedback.mediumImpact();
    PreferencesService.onboardingCompleted = true;
    context.go(AppRoutes.auth);
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _previousPage() {
    HapticFeedback.lightImpact();
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF048C7C);
    const deepTeal = Color(0xFF032621);
    const darkText = Color(0xFF132A26);
    const mutedText = Color(0xFF5A726C);
    const surfaceBg = Color(0xFFF8FAF9);
    final isLastPage = _currentIndex == _slides.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: surfaceBg,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: Branding & Tombol Lewati
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Identitas Singkat Aplikasi
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF048C7C), Color(0xFF063E36)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryTeal.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              FlutterRemix.building_2_line,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Marbot App",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: deepTeal,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                Text(
                                  'Aplikasi Jamaah & Masjid',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: mutedText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Tombol Lewati (Pill Style)
                    if (!isLastPage)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _finish,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE2EBE8),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryTeal.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Lewati',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: primaryTeal,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  FlutterRemix.arrow_right_s_line,
                                  size: 14,
                                  color: primaryTeal,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 32),
                  ],
                ),
              ),

              // Page Slider
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return _buildSlideContent(
                      context,
                      slide: slide,
                      primaryColor: primaryTeal,
                      darkText: darkText,
                      mutedText: mutedText,
                    );
                  },
                ),
              ),

              // Bottom Control Bar (Indicator + Tombol Aksi)
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dots Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => _buildIndicator(
                          isActive: index == _currentIndex,
                          primaryColor: primaryTeal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Navigation Action Buttons
                    if (isLastPage)
                      // Tombol Mulai Sekarang (Full Width Gradient Button)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF048C7C), Color(0xFF06574D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryTeal.withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _finish,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mulai Sekarang',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  FlutterRemix.arrow_right_line,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      // Row Tombol Kembali & Lanjut
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Tombol Kembali
                          if (_currentIndex > 0)
                            Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: _previousPage,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE2EBE8),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      FlutterRemix.arrow_left_line,
                                      color: primaryTeal,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 52),

                          // Tombol Lanjut (Next)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _nextPage,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 52,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF048C7C), Color(0xFF06574D)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryTeal.withValues(alpha: 0.30),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Lanjut',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      FlutterRemix.arrow_right_line,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
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
    );
  }

  Widget _buildSlideContent(
    BuildContext context, {
    required _OnboardSlideData slide,
    required Color primaryColor,
    required Color darkText,
    required Color mutedText,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),

          // Gambar Hero dengan Frame Geometris Halus
          Center(
            child: SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ambient Circles
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.12),
                          primaryColor.withValues(alpha: 0.02),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.65, 1.0],
                      ),
                    ),
                  ),
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),

                  // Hero Art Image
                  Hero(
                    tag: slide.imagePath,
                    child: Image.asset(
                      slide.imagePath,
                      height: 190,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        FlutterRemix.moon_line,
                        size: 90,
                        color: primaryColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              slide.badge,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: primaryColor,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Headline Display Font (DMSerifDisplay)
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'DMSerifDisplay',
              fontSize: 27,
              color: Color(0xFF032621),
              height: 1.25,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle / Deskripsi Nyaman Dibaca (GoogleFonts.poppins)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              slide.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: mutedText,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildIndicator({
    required bool isActive,
    required Color primaryColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 26 : 8,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : const Color(0xFFD2DFDC),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
