import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/partial/settings_tile.dart';
import 'package:masjid_app/core/notifications/adzan_scheduler.dart';
import 'package:masjid_app/core/notifications/notification_permissions.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
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
    final t = context.hudhud;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusMd)),
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
                  color: t.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pengingat Sebelum Adzan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: t.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              ...kAdzanRemindOptions.map((minutes) {
                final isSelected = minutes == settings.adzanRemindMinutes;
                return ListTile(
                  dense: true,
                  title: Text(
                    minutes == 0 ? 'Tidak ada' : '$minutes menit',
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.normal,
                      color: isSelected ? t.terracottaDark : t.charcoal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          LucideIcons.circleCheck,
                          color: t.terracotta,
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
    final t = context.hudhud;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radiusMd),
        ),
        title: Text(
          'Aktifkan Autostart',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: t.charcoal,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Beberapa HP (Xiaomi, Oppo, Vivo, Realme, Samsung) mematikan '
            'notifikasi terjadwal kalau app tidak diizinkan berjalan otomatis.\n\n'
            '1. Buka Pengaturan Aplikasi di bawah ini.\n'
            '2. Pilih menu Autostart / Mulai Otomatis / Jalankan Otomatis.\n'
            '3. Aktifkan untuk Hudhud.\n'
            '4. Di menu Baterai, pilih "Tanpa Batasan" / "Jangan optimalkan".',
            style: TextStyle(fontSize: 13, height: 1.5, color: t.charcoal),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Tutup', style: TextStyle(color: t.muted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: t.terracotta,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(t.radiusSm),
              ),
            ),
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
    final t = context.hudhud;

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(
        title: const Text('Pengaturan Umum'),
        leading: IconButton(
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          tooltip: 'Kembali',
          onPressed: () => context.pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: t.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsSectionTitle('Audio Aplikasi'),
            SettingsCard(
              child: SettingsSwitchRow(
                icon: LucideIcons.music,
                title: 'Audio Bismillah Pembuka',
                subtitle: 'Putar bacaan bismillah saat aplikasi dibuka',
                value: settings.bismillahAudioEnabled,
                onChanged: (v) => notifier.setBismillahAudioEnabled(v),
              ),
            ),
            SizedBox(height: t.spaceLg),
            const SettingsSectionTitle('Notifikasi Adzan'),
            SettingsCard(
              child: Column(
                children: [
                  SettingsSwitchRow(
                    icon: LucideIcons.bell,
                    title: 'Notifikasi Adzan',
                    subtitle: 'Bunyi pengingat setiap masuk waktu sholat',
                    value: settings.adzanEnabled,
                    onChanged: _toggleAdzan,
                  ),
                  if (settings.adzanEnabled) ...[
                    Divider(height: 1, color: t.outline),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        t.spaceMd + 2,
                        t.spaceMd + 2,
                        t.spaceMd + 2,
                        t.spaceSm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Waktu Sholat',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: t.charcoal,
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
                    Divider(height: 1, color: t.outline),
                    SettingsTapRow(
                      icon: LucideIcons.clock,
                      title: 'Pengingat Sebelum Adzan',
                      trailingText: settings.adzanRemindMinutes == 0
                          ? 'Tidak ada'
                          : '${settings.adzanRemindMinutes} menit',
                      onTap: _showRemindPicker,
                    ),
                    Divider(height: 1, color: t.outline),
                    SettingsSwitchRow(
                      icon: LucideIcons.volume2,
                      title: 'Suara',
                      value: settings.adzanSound,
                      onChanged: (v) => notifier.setAdzanSound(v),
                    ),
                    Divider(height: 1, color: t.outline),
                    SettingsSwitchRow(
                      icon: LucideIcons.vibrate,
                      title: 'Getar',
                      value: settings.adzanVibrate,
                      onChanged: (v) => notifier.setAdzanVibrate(v),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: t.spaceLg),
            const SettingsSectionTitle('Izin & Baterai'),
            _permissionCard(t),
            SizedBox(height: t.spaceXl),
          ],
        ),
      ),
    );
  }

  Widget _permissionCard(HudhudTheme t) {
    final status = _permissions;

    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              t.spaceMd + 2,
              t.spaceMd + 2,
              t.spaceMd + 2,
              t.spaceXs,
            ),
            child: Row(
              children: [
                Icon(
                  status?.allGood == true
                      ? LucideIcons.circleCheck
                      : LucideIcons.circleAlert,
                  size: 15,
                  color: status?.allGood == true ? t.success : t.amber,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    status == null
                        ? 'Memeriksa izin...'
                        : status.allGood
                            ? 'Semua izin sudah aktif'
                            : '${status.pendingCount} izin belum aktif — adzan bisa tidak muncul',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: status?.allGood == true ? t.success : t.charcoal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _permissionRow(
            t: t,
            title: 'Izin Notifikasi',
            granted: status?.notifications == PermissionLevel.granted,
            onTap: () => _openSystemSettings(PermissionTarget.notifications),
          ),
          Divider(height: 1, color: t.outline),
          _permissionRow(
            t: t,
            title: 'Alarm Presisi',
            granted: status?.exactAlarm == PermissionLevel.granted,
            onTap: () => _openSystemSettings(PermissionTarget.exactAlarm),
          ),
          Divider(height: 1, color: t.outline),
          _permissionRow(
            t: t,
            title: 'Bebas Optimasi Baterai',
            granted: status?.batteryOptimization == PermissionLevel.granted,
            blocked: status?.batteryOptimization == PermissionLevel.blocked,
            onTap: () =>
                _openSystemSettings(PermissionTarget.batteryOptimization),
          ),
          Divider(height: 1, color: t.outline),
          Padding(
            padding: EdgeInsets.fromLTRB(
              t.spaceMd + 2,
              t.spaceMd,
              t.spaceMd + 2,
              t.spaceMd + 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: FilledButton.icon(
                      onPressed: _requestAllPermissions,
                      icon: const Icon(LucideIcons.shieldCheck, size: 17),
                      label: const Text(
                        'Aktifkan Semua Izin',
                        style: TextStyle(fontSize: 12.5),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: t.terracotta,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(t.radiusMd),
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
                      foregroundColor: t.terracotta,
                      side: BorderSide(color: t.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(t.radiusMd),
                      ),
                    ),
                    child: const Icon(LucideIcons.helpCircle, size: 19),
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
    required HudhudTheme t,
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
                      ? LucideIcons.circleCheck
                      : blocked
                          ? LucideIcons.circleAlert
                          : LucideIcons.circleX,
                  size: 18,
                  color: granted
                      ? t.success
                      : blocked
                          ? t.amber
                          : t.danger,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: t.charcoal,
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
                    color: granted ? t.success : t.muted,
                  ),
                ),
                if (!granted)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: t.muted,
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
    final t = context.hudhud;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? t.terracotta.withValues(alpha: 0.12) : t.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? t.terracotta : t.outline,
              width: active ? 1.2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (active) ...[
                Icon(LucideIcons.check, size: 14, color: t.terracotta),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? t.terracottaDark : t.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
