import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/location_provider.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  /// Ambil posisi GPS; kalau gagal tampilkan alasannya ke user.
  Future<void> _detectLocation(BuildContext context, WidgetRef ref) async {
    final error = await ref.read(locationProvider.notifier).detect();
    if (error != null && context.mounted) {
      Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final location = ref.watch(locationProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 8,
        left: 18,
        right: 18,
        bottom: 12,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sapaan, Nama Pengguna & Lokasi (Satu Kolom Kompak)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Assalamu'alaikum, ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        user?.name ?? 'Tamu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (location.loading)
                      const SizedBox(
                        width: 11,
                        height: 11,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.6,
                          color: Color(0xFFECA843),
                        ),
                      )
                    else
                      const Icon(
                        Icons.location_on_rounded,
                        size: 11,
                        color: Color(0xFFECA843),
                      ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        location.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              const Color(0xFFFFECB7).withValues(alpha: 0.95),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    _HeaderIconButton(
                      icon: Icons.my_location_rounded,
                      tooltip: 'Pakai lokasi GPS saya',
                      onTap: location.loading
                          ? null
                          : () => _detectLocation(context, ref),
                    ),
                    if (location.isGps) ...[
                      const SizedBox(width: 4),
                      _HeaderIconButton(
                        icon: Icons.refresh_rounded,
                        tooltip: 'Kembali ke lokasi default',
                        onTap: () =>
                            ref.read(locationProvider.notifier).reset(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Tombol Aksi: Notifikasi & Avatar (Kompak & Bersih)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notification Icon Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push(AppRoutes.notifikasi),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Profile Avatar
              GestureDetector(
                onTap: () => context.push(AppRoutes.profile),
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFECA843),
                      width: 1.2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (user?.photo.isNotEmpty ?? false)
                        ? Image.network(
                            user!.photo,
                            height: 32,
                            width: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/icons/app_icon.png',
                              height: 32,
                              width: 32,
                            ),
                          )
                        : Image.asset(
                            'assets/icons/app_icon.png',
                            height: 32,
                            width: 32,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tombol bundar kecil untuk baris lokasi di header.
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.16),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 22,
            height: 22,
            child: Icon(icon, size: 13, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
