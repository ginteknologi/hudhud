import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/partial/settings_tile.dart';
import 'package:masjid_app/core/notifications/adzan_scheduler.dart';
import 'package:masjid_app/core/notifications/notification_permissions.dart';
import 'package:masjid_app/providers/app_settings_provider.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';

/// Halaman pengaturan umum: notifikasi adzan + izin sistem yang dibutuhkan
/// supaya alarm adzan benar-benar terjadwal.
class PengaturanUmumPage extends ConsumerStatefulWidget {
  const PengaturanUmumPage({super.key});

  @override
  ConsumerState<PengaturanUmumPage> createState() => _PengaturanUmumPageState();
}

class _PengaturanUmumPageState extends ConsumerState<PengaturanUmumPage> {
  NotificationPermissionStatus? _permissions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applySchedule();
      _refreshPermissions();
    });
  }

  Future<void> _refreshPermissions() async {
    final status = await NotificationPermissions.check();
    if (mounted) setState(() => _permissions = status);
  }

  Future<void> _applySchedule() async {
    final jadwal = ref.read(jadwalShalatProvider).valueOrNull;
    if (jadwal == null) return;
    await AdzanScheduler.sync(
      jadwal: jadwal,
      settings: ref.read(appSettingsProvider),
    );
  }

  Future<void> _requestAllPermissions() async {
    final status = await NotificationPermissions.requestAll();
    if (!mounted) return;
    setState(() => _permissions = status);

    if (status.allGood) {
      Fluttertoast.showToast(msg: 'Semua izin sudah aktif');
      return;
    }

    // Dialog izin tidak bisa muncul lagi (sudah ditolak / dibatasi ROM), jadi
    // user langsung diarahkan ke layar pengaturan sistem yang relevan.
    Fluttertoast.showToast(
      msg: status.pendingCount == 1
          ? 'Aktifkan izin lewat pengaturan sistem'
          : '${status.pendingCount} izin perlu diaktifkan di pengaturan sistem',
      toastLength: Toast.LENGTH_LONG,
    );
    final target = status.firstPending;
    if (target != null) await _openSystemSettings(target);
  }

  Future<void> _openSystemSettings(PermissionTarget target) async {
    final opened = await NotificationPermissions.openSettingsFor(target);
    if (!opened && mounted) {
      Fluttertoast.showToast(msg: 'Tidak dapat membuka pengaturan sistem');
    }
    await _refreshPermissions();
  }

  Future<void> _toggleAdzan(bool value) async {
    final notifier = ref.read(appSettingsProvider.notifier);
    if (value) {
      final status = await NotificationPermissions.requestAll();
      if (mounted) setState(() => _permissions = status);
      if (!status.allGood) {
        Fluttertoast.showToast(
          msg: 'Masih ada ${status.pendingCount} izin belum aktif. '
              'Cek bagian "Izin & Baterai" di bawah.',
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
    await notifier.setAdzanEnabled(value);
    await _applySchedule();
    if (value && mounted) {
      await AdzanScheduler.showTestNotification(
        sound: ref.read(appSettingsProvider).adzanSound,
      );
    }
  }

  void _showRemindPicker() {
    final settings = ref.read(appSettingsProvider);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        // BottomSheet membatasi tingginya; 6 pilihan + header bisa melebihi
        // batas itu, jadi isinya harus bisa di-scroll.
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pengingat Sebelum Adzan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...kAdzanRemindOptions.map((minutes) {
                final isSelected = minutes == settings.adzanRemindMinutes;
                return ListTile(
                  dense: true,
                  title: Text(minutes == 0 ? 'Tidak ada' : '$minutes menit'),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: kTileAccent,
                        )
                      : null,
                  onTap: () async {
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setRemindMinutes(minutes);
                    await _applySchedule();
                    if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showAutostartHint() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Aktifkan Autostart'),
        content: const SingleChildScrollView(
          child: Text(
            'Beberapa HP (Xiaomi, Oppo, Vivo, Realme, Samsung) mematikan '
            'notifikasi terjadwal kalau app tidak diizinkan berjalan otomatis.\n\n'
            '1. Buka Pengaturan Aplikasi di bawah ini.\n'
            '2. Pilih menu Autostart / Mulai Otomatis / Jalankan Otomatis.\n'
            '3. Aktifkan untuk Marbot App.\n'
            '4. Di menu Baterai, pilih "Tanpa Batasan" / "Jangan optimalkan".',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Tutup'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kTileAccent),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await NotificationPermissions.openSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: kTilePageBg,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsPageHeader(
              title: 'Pengaturan Umum',
              subtitle: 'Notifikasi dan izin aplikasi',
              leading: SettingsHeaderButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => context.pop(),
              ),
            ),
            const SizedBox(height: 20),
            const SettingsSectionTitle('Audio Aplikasi'),
            SettingsCard(
              child: SettingsSwitchRow(
                icon: Icons.music_note_rounded,
                title: 'Audio Bismillah Pembuka',
                subtitle: 'Putar bacaan bismillah saat aplikasi dibuka',
                value: settings.bismillahAudioEnabled,
                onChanged: (v) => notifier.setBismillahAudioEnabled(v),
              ),
            ),
            const SizedBox(height: 22),
            const SettingsSectionTitle('Notifikasi Adzan'),
            SettingsCard(
              child: Column(
                children: [
                  SettingsSwitchRow(
                    icon: Icons.notifications_active_rounded,
                    title: 'Notifikasi Adzan',
                    subtitle: 'Bunyi pengingat setiap masuk waktu sholat',
                    value: settings.adzanEnabled,
                    onChanged: _toggleAdzan,
                  ),
                  if (settings.adzanEnabled) ...[
                    const Divider(height: 1, color: kTileBorder),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pilih Waktu Sholat',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: kTileTextDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: AdzanPrayer.all.map((key) {
                              final on = settings.isPrayerOn(key);
                              return _PrayerChip(
                                label: AdzanPrayer.label(key),
                                active: on,
                                onTap: () async {
                                  HapticFeedback.selectionClick();
                                  await notifier.setPrayer(key, !on);
                                  await _applySchedule();
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: kTileBorder),
                    SettingsTapRow(
                      icon: Icons.timer_outlined,
                      title: 'Pengingat Sebelum Adzan',
                      trailingText: settings.adzanRemindMinutes == 0
                          ? 'Tidak ada'
                          : '${settings.adzanRemindMinutes} menit',
                      onTap: _showRemindPicker,
                    ),
                    const Divider(height: 1, color: kTileBorder),
                    SettingsSwitchRow(
                      icon: Icons.volume_up_rounded,
                      title: 'Suara',
                      value: settings.adzanSound,
                      onChanged: (v) => notifier.setAdzanSound(v),
                    ),
                    const Divider(height: 1, color: kTileBorder),
                    SettingsSwitchRow(
                      icon: Icons.vibration_rounded,
                      title: 'Getar',
                      value: settings.adzanVibrate,
                      onChanged: (v) => notifier.setAdzanVibrate(v),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SettingsSectionTitle('Izin & Baterai'),
            _permissionCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _permissionCard() {
    final status = _permissions;

    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
            child: Text(
              status == null
                  ? 'Memeriksa izin...'
                  : status.allGood
                      ? 'Semua izin sudah aktif'
                      : '${status.pendingCount} izin belum aktif — adzan bisa tidak muncul',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: status?.allGood == true ? kTileAccent : kTileTextMuted,
              ),
            ),
          ),
          _permissionRow(
            title: 'Izin Notifikasi',
            granted: status?.notifications == PermissionLevel.granted,
            onTap: () => _openSystemSettings(PermissionTarget.notifications),
          ),
          const Divider(height: 1, color: kTileBorder),
          _permissionRow(
            title: 'Alarm Presisi',
            granted: status?.exactAlarm == PermissionLevel.granted,
            onTap: () => _openSystemSettings(PermissionTarget.exactAlarm),
          ),
          const Divider(height: 1, color: kTileBorder),
          _permissionRow(
            title: 'Bebas Optimasi Baterai',
            granted: status?.batteryOptimization == PermissionLevel.granted,
            blocked: status?.batteryOptimization == PermissionLevel.blocked,
            onTap: () =>
                _openSystemSettings(PermissionTarget.batteryOptimization),
          ),
          const Divider(height: 1, color: kTileBorder),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: FilledButton.icon(
                      onPressed: _requestAllPermissions,
                      icon: const Icon(Icons.verified_user_rounded, size: 17),
                      label: const Text(
                        'Aktifkan Semua Izin',
                        style: TextStyle(fontSize: 12.5),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: kTileAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 42,
                  width: 42,
                  child: OutlinedButton(
                    onPressed: _showAutostartHint,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: kTileAccent,
                      side: const BorderSide(color: kTileBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.help_outline_rounded, size: 19),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _permissionRow({
    required String title,
    required bool granted,
    bool blocked = false,
    VoidCallback? onTap,
  }) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: granted ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            child: Row(
              children: [
                Icon(
                  granted
                      ? Icons.check_circle_rounded
                      : blocked
                          ? Icons.error_rounded
                          : Icons.cancel_rounded,
                  size: 18,
                  color: granted
                      ? kTileAccent
                      : blocked
                          ? const Color(0xFFE0A800)
                          : const Color(0xFFD9534F),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: kTileTextDark,
                    ),
                  ),
                ),
                Text(
                  granted
                      ? 'Aktif'
                      : blocked
                          ? 'Buka pengaturan'
                          : 'Belum aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: granted ? kTileAccent : kTileTextMuted,
                  ),
                ),
                if (!granted)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: kTileTextMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}

class _PrayerChip extends StatelessWidget {
  const _PrayerChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFEAF5F2) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? kTileAccent : kTileBorder,
              width: active ? 1.2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (active) ...[
                const Icon(Icons.check_rounded, size: 14, color: kTileAccent),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active ? kTileAccent : kTileTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
