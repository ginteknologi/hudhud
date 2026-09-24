import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masjid_app/models/jadwal_shalat_model.dart';
import 'package:masjid_app/providers/app_settings_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Penjadwal notifikasi adzan harian (lokal, tanpa server).
///
/// ponytail: zona waktu di-hardcode Asia/Jakarta karena app hanya untuk
/// Masjid An-Ni'mah Cibubur (WIB). Kalau nanti perlu multizona, tambahkan
/// `flutter_timezone` untuk membaca zona perangkat.
/// ponytail: suara adzan masih memakai suara notifikasi bawaan; kalau
/// `android/app/src/main/res/raw/adzan.mp3` sudah tersedia, ganti
/// [_adzanSound] menjadi `RawResourceAndroidNotificationSound('adzan')`.
class AdzanScheduler {
  AdzanScheduler._();

  static const String _channelId = 'adzan_daily_channel';
  static const String _channelName = 'Notifikasi Adzan';
  static const String _channelDesc = 'Pengingat waktu sholat harian';

  static const int _adzanIdBase = 7100;
  static const int _remindIdBase = 7200;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _ready = false;

  static const AndroidNotificationDetails _adzanDetails =
      AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDesc,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    audioAttributesUsage: AudioAttributesUsage.alarm,
    category: AndroidNotificationCategory.alarm,
    fullScreenIntent: true,
  );

  static Future<void> init() async {
    if (kIsWeb) return;
    if (!_ready) {
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

      await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      _ready = true;
    }

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.max,
        playSound: true,
      ),
    );
  }

  /// Selaraskan jadwal notifikasi dengan pengaturan yang tersimpan.
  /// Dipanggil setiap kali jadwal sholat atau pengaturan berubah.
  static Future<void> sync({
    required JadwalShalatModel jadwal,
    required AppSettings settings,
  }) async {
    if (kIsWeb) return;
    await init();
    await cancelAll();

    if (!settings.adzanEnabled) return;

    final times = <String, String>{
      AdzanPrayer.subuh: jadwal.subuh,
      AdzanPrayer.dzuhur: jadwal.dzuhur,
      AdzanPrayer.ashar: jadwal.ashar,
      AdzanPrayer.maghrib: jadwal.maghrib,
      AdzanPrayer.isya: jadwal.isya,
    };

    for (final entry in times.entries) {
      if (!settings.isPrayerOn(entry.key)) continue;
      final parts = entry.value.split(':');
      if (parts.length != 2) continue;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) continue;

      final label = AdzanPrayer.label(entry.key);
      final index = AdzanPrayer.all.indexOf(entry.key);

      await _schedule(
        id: _adzanIdBase + index,
        title: 'Waktu Sholat $label',
        body: 'Telah masuk waktu sholat $label untuk wilayah Masjid An-Ni\'mah',
        at: _nextInstanceOf(hour, minute),
        payload: 'adzan:${entry.key}',
      );

      if (settings.adzanRemindMinutes > 0) {
        final remindAt = _minusMinutes(hour, minute, settings.adzanRemindMinutes);
        await _schedule(
          id: _remindIdBase + index,
          title: 'Menuju $label',
          body:
              '${settings.adzanRemindMinutes} menit lagi masuk waktu sholat $label',
          at: _nextInstanceOf(remindAt.$1, remindAt.$2),
          payload: 'adzan_remind:${entry.key}',
        );
      }
    }
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    for (var i = 0; i < AdzanPrayer.all.length; i++) {
      await _plugin.cancel(_adzanIdBase + i);
      await _plugin.cancel(_remindIdBase + i);
    }
  }

  /// Notifikasi uji coba supaya pengguna langsung melihat hasil pengaturannya.
  static Future<void> showTestNotification({required bool sound}) async {
    if (kIsWeb) return;
    await init();
    await _plugin.show(
      7300,
      'Notifikasi Adzan Aktif',
      'Notifikasi adzan akan muncul setiap waktu sholat.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.max,
          priority: Priority.high,
          playSound: sound,
        ),
      ),
      payload: 'adzan_test',
    );
  }

  /// Jadwalkan satu notifikasi. Kalau izin alarm presisi dicabut, jadwal
  /// diturunkan ke mode inexact supaya notifikasi tetap terpasang.
  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime at,
    required String payload,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        at,
        const NotificationDetails(android: _adzanDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('Alarm presisi tidak tersedia (${e.code}), pakai inexact');
      }
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        at,
        const NotificationDetails(android: _adzanDetails),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static (int, int) _minusMinutes(int hour, int minute, int delta) {
    final total = (hour * 60 + minute - delta) % (24 * 60);
    final safe = total < 0 ? total + 24 * 60 : total;
    return (safe ~/ 60, safe % 60);
  }
}
