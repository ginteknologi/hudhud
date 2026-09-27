import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/partial/settings_tile.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:share_plus/share_plus.dart';

class AkunPage extends ConsumerStatefulWidget {
  const AkunPage({super.key});

  @override
  ConsumerState<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends ConsumerState<AkunPage> {
  late final ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled =
        _scrollController.hasClients && _scrollController.offset > 24;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final version = ref.watch(appVersionProvider).valueOrNull ?? '0.0.0';
    final isLoggedIn = user != null;
    final topPadding = MediaQuery.of(context).padding.top;

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isScrolled ? Brightness.dark : Brightness.light,
      statusBarBrightness: _isScrolled ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        backgroundColor: kTilePageBg,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(
                    context,
                    user?.name ?? 'Tamu',
                    user?.email ?? '',
                    user?.photo ?? '',
                    isLoggedIn,
                  ),
                  const SizedBox(height: 22),
                  const SettingsSectionTitle('Pengaturan'),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsTapRow(
                          icon: Icons.tune_rounded,
                          title: 'Pengaturan Umum',
                          subtitle: 'Notifikasi adzan, izin, dan baterai',
                          onTap: () => context.push(AppRoutes.pengaturanUmum),
                        ),
                        const Divider(height: 1, color: kTileBorder),
                        SettingsTapRow(
                          icon: Icons.menu_book_rounded,
                          title: 'Pengaturan Al-Qur\'an',
                          subtitle: 'Ukuran teks, terjemahan, dan qori murottal',
                          onTap: () => context.push(AppRoutes.quranPengaturan),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const SettingsSectionTitle('Tentang Aplikasi'),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsTapRow(
                          icon: Icons.share_rounded,
                          title: 'Bagikan Aplikasi',
                          onTap: () => SharePlus.instance.share(
                            ShareParams(
                              text:
                                  'Hudhud - Daily Quran & Stories\nhttps://hudhud.app',
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: kTileBorder),
                        SettingsTapRow(
                          icon: Icons.info_outline_rounded,
                          title: 'Versi Aplikasi',
                          trailingText: version,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (isLoggedIn)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await ref.read(authNotifierProvider.notifier).logout();
                            if (context.mounted) context.go(AppRoutes.auth);
                          },
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: const Text('Keluar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD9534F),
                            side: const BorderSide(color: Color(0xFFF2C9C7)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Hudhud v$version',
                      style: const TextStyle(fontSize: 11, color: kTileTextMuted),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            // Sticky AppBar saat di-scroll
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_isScrolled,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: topPadding + 48,
                  decoration: BoxDecoration(
                    color: _isScrolled
                        ? Colors.white.withValues(alpha: 0.98)
                        : Colors.transparent,
                    border: _isScrolled
                        ? const Border(
                            bottom: BorderSide(
                              color: Color(0xFFE2EBE8),
                              width: 0.8,
                            ),
                          )
                        : null,
                    boxShadow: _isScrolled
                        ? [
                            BoxShadow(
                              color:
                                  const Color(0xFFD06A4C).withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isScrolled ? 1.0 : 0.0,
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: const Text(
                          'Akun',
                          style: TextStyle(
                            color: Color(0xFFD06A4C),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(
    BuildContext context,
    String name,
    String email,
    String photo,
    bool isLoggedIn,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 18,
        left: 18,
        right: 18,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD06A4C),
            Color(0xFFB85639),
            Color(0xFF8C3B24),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x28D06A4C),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Akun',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on_rounded, size: 12, color: kTileGold),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  ref.watch(locationProvider).name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFFFFECB7).withValues(alpha: 0.95),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: isLoggedIn ? () => context.push(AppRoutes.profileEdit) : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kTileGold, width: 1.2),
                    ),
                    child: ClipOval(
                      child: photo.isNotEmpty
                          ? Image.network(
                              photo,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _defaultAvatar(),
                            )
                          : _defaultAvatar(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email.isEmpty ? 'guest@hudhud.app' : email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoggedIn)
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() => Container(
        width: 48,
        height: 48,
        color: const Color(0xFFEAF5F2),
        child: const Icon(Icons.person_rounded, color: kTileAccent, size: 26),
      );
}
