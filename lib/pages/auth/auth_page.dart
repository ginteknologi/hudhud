import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  String? _errorMessage;

  Future<void> _handleGoogleLogin() async {
    HapticFeedback.lightImpact();
    setState(() => _errorMessage = null);
    try {
      await ref.read(authNotifierProvider.notifier).loginGoogle();
      final authState = ref.read(authNotifierProvider);
      if (authState.hasError) {
        setState(() {
          _errorMessage = 'Gagal masuk dengan Google. Silakan coba lagi.';
        });
      } else if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan saat masuk. Silakan coba lagi.';
        });
      }
    }
  }

  Future<void> _handleGuestLogin() async {
    HapticFeedback.lightImpact();
    setState(() => _errorMessage = null);
    try {
      await ref.read(authNotifierProvider.notifier).loginGuest();
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal masuk sebagai tamu. Silakan coba lagi.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    const primaryTeal = Color(0xFF048C7C);
    const surfaceBg = Color(0xFFF8FAF9);
    const darkText = Color(0xFF132A26);
    const mutedText = Color(0xFF5A726C);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: surfaceBg,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // 1. Header Islami Elegan Bergaya Home Dashboard
              _buildTopHeader(context, primaryTeal),

              // 2. Card Form & Opsi Masuk (Overlapping Header)
              Transform.translate(
                offset: const Offset(0, -28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFE2EBE8),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryTeal.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Chip Highlight Fitur Masjid
                        _buildFeaturePills(primaryTeal),
                        const SizedBox(height: 20),

                        // Judul & Penjelasan
                        Text(
                          'Pintu Masuk Jamaah',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Masuk untuk sinkronisasi riwayat infaq, bookmark Qur\'an, atau lanjutkan langsung sebagai tamu.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: mutedText,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Error Banner jika ada kendala
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF2F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFF8B4B4),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  FlutterRemix.error_warning_line,
                                  color: Color(0xFFE02424),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFF9B1C1C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Loading State atau Pilihan Tombol
                        if (isLoading)
                          _buildLoadingIndicator(primaryTeal)
                        else ...[
                          // Primary CTA: Lanjutkan dengan Google
                          _buildGoogleButton(onTap: _handleGoogleLogin),
                          const SizedBox(height: 16),

                          // Divider dengan teks "atau"
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFE8EDE9),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'atau',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF8E9E99),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFE8EDE9),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Secondary CTA: Masuk sebagai Tamu
                          _buildGuestButton(
                            primaryColor: primaryTeal,
                            onTap: _handleGuestLogin,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Footer Informasi Aplikasi
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FlutterRemix.shield_check_line,
                          size: 14,
                          color: Color(0xFF048C7C),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Aman & Bebas Iklan Komersial',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: mutedText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Marbot App • Menuju Ekosistem Masjid Makmur & Mandiri",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: const Color(0xFF8B9D98),
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
  }

  Widget _buildTopHeader(BuildContext context, Color primaryColor) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 16,
        left: 24,
        right: 24,
        bottom: 50,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF032621),
            Color(0xFF063E36),
            Color(0xFF0D6357),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22048C7C),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Masjid dalam Frame Lembut
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/img/new-logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                FlutterRemix.building_2_line,
                size: 36,
                color: Color(0xFF048C7C),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sapaan Islami Khas Home
          const Text(
            "Assalamu'alaikum",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DMSerifDisplay',
              color: Colors.white,
              fontSize: 27,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Warahmatullahi Wabarakatuh',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),

          // Badge Nama Masjid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FlutterRemix.building_2_line,
                  color: Color(0xFFE2F4EE),
                  size: 13,
                ),
                const SizedBox(width: 6),
                Text(
                  "Marbot App",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePills(Color primaryColor) {
    final features = [
      {'icon': FlutterRemix.time_line, 'label': 'Waktu Sholat'},
      {'icon': FlutterRemix.book_read_line, 'label': "Al-Qur'an 30 Juz"},
      {'icon': FlutterRemix.compass_3_line, 'label': 'Arah Kiblat'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: features.map((f) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2EBE8),
                width: 0.8,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  f['icon'] as IconData,
                  size: 16,
                  color: primaryColor,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      f['label'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C4A43),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoogleButton({required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFDCE4E1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/google.png',
                height: 22,
                width: 22,
                errorBuilder: (_, __, ___) => const Icon(
                  FlutterRemix.google_fill,
                  size: 20,
                  color: Color(0xFFEA4335),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Lanjutkan dengan Google',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E322F),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestButton({
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFBFE0D7),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FlutterRemix.user_3_line,
                size: 19,
                color: primaryColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Masuk sebagai Tamu (Guest)',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.8,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Menghubungkan akun...',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E322F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mohon tunggu beberapa saat',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF5A726C),
            ),
          ),
        ],
      ),
    );
  }
}
