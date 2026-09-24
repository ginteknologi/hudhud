import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/partial/settings_tile.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/pages/dkm/dkm_page.dart' show kOfficialSocials;
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AkunPage extends ConsumerWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final userName = user?.name ?? 'Pengguna Tamu';
    final userEmail = user?.email ?? 'guest@annimah.id';
    final userPhoto = user?.photo ?? '';
    final version = ref.watch(appVersionProvider).valueOrNull ?? '0.0.0';

    return Scaffold(
      backgroundColor: kTilePageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, userName, userEmail, userPhoto),
              const SizedBox(height: 22),
              const SettingsSectionTitle('Akun'),
              SettingsCard(
                child: Column(
                  children: [
                    SettingsTapRow(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profil',
                      subtitle: 'Ubah nama, nomor telepon, dan foto',
                      onTap: () => context.push(AppRoutes.profileEdit),
                    ),
                    const Divider(height: 1, color: kTileBorder),
                    SettingsTapRow(
                      icon: Icons.history_rounded,
                      title: 'Riwayat Sedekah',
                      onTap: () => context.push(AppRoutes.profileRiwayat),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SettingsSectionTitle('Ikuti Kami'),
              SettingsCard(
                child: SettingsSocialRow(
                  items: kOfficialSocials,
                  onTap: (item) async {
                    final url = Uri.parse(item['link']!);
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    ) &&
                        context.mounted) {
                      Fluttertoast.showToast(msg: 'Tidak dapat membuka tautan');
                    }
                  },
                ),
              ),
              const SizedBox(height: 22),
              const SettingsSectionTitle('Tentang'),
              SettingsCard(
                child: SettingsTapRow(
                  icon: Icons.info_outline_rounded,
                  title: 'Versi Aplikasi',
                  trailingText: version,
                ),
              ),
              const SizedBox(height: 28),
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
              const SizedBox(height: 40),
            ],
          ),
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
        top: topPadding + 10,
        left: 18,
        right: 18,
        bottom: 24,
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
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SettingsHeaderButton(
                icon: Icons.arrow_back_rounded,
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
              ),
              const SizedBox(width: 12),
              const Text(
                'Profil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kTileGold, width: 1.4),
            ),
            child: ClipOval(
              child: photo.isNotEmpty
                  ? Image.network(
                      photo,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatar(),
                    )
                  : _defaultAvatar(),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            email,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() => Container(
        width: 84,
        height: 84,
        color: const Color(0xFFEAF5F2),
        child: const Icon(Icons.person_rounded, color: kTileAccent, size: 44),
      );
}
