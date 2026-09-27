import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionLevel {
  granted,
  denied,

  /// Tidak bisa diminta lagi dari dalam app — user harus ke pengaturan sistem.
  blocked,
}

/// Izin sistem yang bisa diminta langsung maupun lewat layar pengaturan.
enum PermissionTarget { notifications, exactAlarm, batteryOptimization }

class NotificationPermissionStatus {
  const NotificationPermissionStatus({
    required this.notifications,
    required this.exactAlarm,
    required this.batteryOptimization,
  });

  final PermissionLevel notifications;
  final PermissionLevel exactAlarm;

  /// `granted` berarti app sudah dikecualikan dari optimasi baterai.
  final PermissionLevel batteryOptimization;

  bool get allGood =>
      notifications == PermissionLevel.granted &&
      exactAlarm == PermissionLevel.granted &&
      batteryOptimization == PermissionLevel.granted;

  /// Jumlah izin yang belum beres, dipakai untuk badge di halaman pengaturan.
  int get pendingCount => [
        notifications,
        exactAlarm,
        batteryOptimization,
      ].where((level) => level != PermissionLevel.granted).length;

  /// Target pertama yang belum beres — urut dari yang paling sering jadi
  /// penghalang notifikasi adzan.
  PermissionTarget? get firstPending {
    if (batteryOptimization != PermissionLevel.granted) {
      return PermissionTarget.batteryOptimization;
    }
    if (exactAlarm != PermissionLevel.granted) {
      return PermissionTarget.exactAlarm;
    }
    if (notifications != PermissionLevel.granted) {
      return PermissionTarget.notifications;
    }
    return null;
  }
}

/// Pemeriksaan & permintaan izin yang dibutuhkan agar notifikasi adzan
/// benar-benar terjadwal: izin notifikasi, alarm presisi, dan pengecualian
/// optimasi baterai (Doze/OEM task killer).
class NotificationPermissions {
  NotificationPermissions._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static Future<NotificationPermissionStatus> check() async {
    if (kIsWeb || !Platform.isAndroid) {
      return const NotificationPermissionStatus(
        notifications: PermissionLevel.granted,
        exactAlarm: PermissionLevel.granted,
        batteryOptimization: PermissionLevel.granted,
      );
    }

    final enabled = await _android?.areNotificationsEnabled();
    final canExact = await _android?.canScheduleExactNotifications();
    final battery = await Permission.ignoreBatteryOptimizations.status;

    return NotificationPermissionStatus(
      notifications:
          (enabled ?? false) ? PermissionLevel.granted : PermissionLevel.denied,
      exactAlarm: (canExact ?? false)
          ? PermissionLevel.granted
          : PermissionLevel.denied,
      batteryOptimization: battery.isGranted
          ? PermissionLevel.granted
          : battery.isPermanentlyDenied
              ? PermissionLevel.blocked
              : PermissionLevel.denied,
    );
  }

  /// Minta semua izin yang belum diberikan. Mengembalikan status terakhir.
  static Future<NotificationPermissionStatus> requestAll() async {
    if (kIsWeb || !Platform.isAndroid) return check();

    await _android?.requestNotificationsPermission();
    await _android?.requestExactAlarmsPermission();

    final battery = await Permission.ignoreBatteryOptimizations.status;
    if (!battery.isGranted) {
      // Dialog sistem hanya muncul kalau izin ini belum pernah ditolak;
      // kalau sudah, `request()` diam-diam tidak melakukan apa pun dan user
      // harus diarahkan ke pengaturan lewat [openSettingsFor].
      await Permission.ignoreBatteryOptimizations.request();
    }

    return check();
  }

  /// Arahkan user ke layar pengaturan sistem untuk satu izin tertentu.
  /// Mengembalikan `true` kalau salah satu layar berhasil dibuka.
  static Future<bool> openSettingsFor(PermissionTarget target) async {
    if (kIsWeb || !Platform.isAndroid) return false;

    switch (target) {
      case PermissionTarget.batteryOptimization:
        if (await _openSystemScreen('openBatteryOptimizationSettings')) {
          return true;
        }
      case PermissionTarget.exactAlarm:
        if (await _openSystemScreen('openExactAlarmSettings')) return true;
      case PermissionTarget.notifications:
        // Tidak ada layar khusus; app info selalu tersedia di bawah.
        break;
    }

    return openAppSettings();
  }

  /// Halaman pengaturan app di sistem — jalan terakhir kalau permintaan izin
  /// sudah diblokir permanen atau user perlu mengaktifkan autostart OEM.
  static Future<bool> openSettings() => openAppSettings();

  static const MethodChannel _settingsChannel =
      MethodChannel('hudhud/system_settings');

  static Future<bool> _openSystemScreen(String method) async {
    try {
      return await _settingsChannel.invokeMethod<bool>(method) ?? false;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('Gagal membuka $method: ${e.message}');
      }
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
