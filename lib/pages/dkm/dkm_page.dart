import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/partial/settings_tile.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Kontak resmi masjid — sengaja di-hardcode, tidak lagi diambil dari server.
/// Ganti nilai `link` di sini kalau akun resmi berubah.
const List<Map<String, String>> kOfficialSocials = [
  {
    'label': 'Instagram',
    'icon': 'assets/icons/insta2.svg',
    'link': 'https://www.instagram.com/marbot.aplikasi/',
  },
  {
    'label': 'YouTube',
    'icon': 'assets/icons/youtube-solid.svg',
    'link': 'https://www.youtube.com/@marbot.aplikasi',
  },
  {
    'label': 'TikTok',
    'icon': 'assets/icons/tiktok-solid.svg',
    'link': 'https://www.tiktok.com/@marbot.aplikasi',
  },
  {
    'label': 'Facebook',
    'icon': 'assets/icons/fb-solid.svg',
    'link': 'https://www.facebook.com/marbot.aplikasi',
  },
  {
    'label': 'WhatsApp',
    'icon': 'assets/icons/wa-solid.svg',
    'link': 'https://wa.me/6281234567890',
  },
];

class DkmPage extends ConsumerStatefulWidget {
  const DkmPage({super.key});

  @override
  ConsumerState<DkmPage> createState() => _DkmPageState();
}

class _DkmPageState extends ConsumerState<DkmPage> {
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

  Future<void> _openLink(BuildContext context, String link) async {
    final url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication) &&
        context.mounted) {
      Fluttertoast.showToast(msg: 'Tidak dapat membuka tautan');
    }
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
                  _header(context, user?.name ?? 'Tamu', user?.email ?? '',
                      user?.photo ?? ''),
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
              const SettingsSectionTitle('Ikuti Kami'),
            SettingsCard(
              child: SettingsSocialRow(
                items: kOfficialSocials,
                onTap: (item) => _openLink(context, item['link']!),
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
                            'Marbot App - aplikasi Masjid An-Ni\'mah\nhttps://s.id/downloadmarbotapp',
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
                'Marbot App version $version',
                style: const TextStyle(fontSize: 11, color: kTileTextMuted),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // Sticky AppBar dengan background putih saat di-scroll
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
                            const Color(0xFF048C7C).withValues(alpha: 0.06),
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
                    'Marbot',
                    style: TextStyle(
                      color: Color(0xFF137065),
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
            Color(0xFF048C7C),
            Color(0xFF036F63),
            Color(0xFF02574D),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22048C7C),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Marbot',
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
              Text(
                'Masjid An-Ni’mah Cibubur',
                style: TextStyle(
                  color: const Color(0xFFFFECB7).withValues(alpha: 0.95),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
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
                      email.isEmpty ? 'guest@annimah.id' : email,
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
            ],
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
