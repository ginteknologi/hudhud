import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/hudhud_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:share_plus/share_plus.dart';

class AkunPage extends ConsumerWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final version = ref.watch(appVersionProvider).valueOrNull ?? '0.0.0';
    final location = ref.watch(locationProvider).name;
    final t = context.hudhud;
    final loggedIn = user != null;

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(
        title: const Text('Akun'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceXl),
        children: [
          _ProfileHeader(
            name: user?.name ?? 'Tamu',
            email: user?.email ?? 'Masuk untuk menyimpan profilmu',
            photo: user?.photo ?? '',
            location: location,
            onTap: loggedIn
                ? () => context.push(AppRoutes.profileEdit)
                : () => context.go(AppRoutes.auth),
          ),
          SizedBox(height: t.spaceLg),
          const HudhudSectionHeader(title: 'Pengaturan'),
          SizedBox(height: t.spaceSm),
          _Group(children: [
            HudhudActionRow(
                icon: LucideIcons.slidersHorizontal,
                title: 'Pengaturan umum',
                subtitle: 'Adzan, izin lokasi, dan baterai',
                onTap: () => context.push(AppRoutes.pengaturanUmum)),
            HudhudActionRow(
                icon: LucideIcons.bookOpen,
                title: "Pengaturan Al-Qur'an",
                subtitle: 'Teks, terjemahan, dan qari',
                onTap: () => context.push(AppRoutes.quranPengaturan)),
          ]),
          SizedBox(height: t.spaceLg),
          const HudhudSectionHeader(title: 'Tentang Hudhud'),
          SizedBox(height: t.spaceSm),
          _Group(children: [
            HudhudActionRow(
                icon: LucideIcons.share2,
                title: 'Bagikan aplikasi',
                onTap: () => SharePlus.instance.share(ShareParams(
                    text:
                        'Hudhud — pendamping ibadah harian\nhttps://hudhud.app'))),
            HudhudActionRow(
                icon: LucideIcons.info,
                title: 'Versi aplikasi',
                trailing: Text(version,
                    style: Theme.of(context).textTheme.bodySmall)),
          ]),
          SizedBox(height: t.spaceXl),
          if (loggedIn)
            OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) context.go(AppRoutes.auth);
              },
              icon: const Icon(LucideIcons.logOut, size: 18),
              label: const Text('Keluar'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, t.controlHeight),
                foregroundColor: t.danger,
                side: BorderSide(color: t.danger.withValues(alpha: .3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(t.radiusMd)),
              ),
            )
          else
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.auth),
              icon: const Icon(LucideIcons.logIn, size: 18),
              label: const Text('Masuk ke Hudhud'),
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, t.controlHeight),
                backgroundColor: t.terracotta,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(t.radiusMd)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.photo,
    required this.location,
    required this.onTap,
  });

  final String name;
  final String email;
  final String photo;
  final String location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(t.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(t.spaceMd),
            child: Row(
              children: [
                ClipOval(
                  child: photo.isEmpty
                      ? Container(
                          width: 52,
                          height: 52,
                          color: t.terracotta.withValues(alpha: .12),
                          child: Icon(LucideIcons.userRound,
                              color: t.terracotta, size: 24))
                      : Image.network(photo,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              width: 52,
                              height: 52,
                              color: t.terracotta.withValues(alpha: .12),
                              child: Icon(LucideIcons.userRound,
                                  color: t.terracotta, size: 24))),
                ),
                SizedBox(width: t.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: t.muted)),
                      const SizedBox(height: 4),
                      Row(children: [
                        Icon(LucideIcons.mapPin, size: 13, color: t.terracotta),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: t.muted)),
                        ),
                      ]),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, color: t.muted, size: 19),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(height: 1, indent: 52, color: t.outline),
          ]
        ],
      ),
    );
  }
}
