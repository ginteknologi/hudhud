import 'package:masjid_app/models/jadwal_shalat_model.dart';

enum HudhudDayPeriod { morning, midday, dusk, night }

class HudhudCompanionState {
  const HudhudCompanionState({
    required this.period,
    required this.greeting,
    required this.message,
    required this.assetPath,
  });

  final HudhudDayPeriod period;
  final String greeting;
  final String message;
  final String assetPath;
}

HudhudCompanionState resolveHudhudCompanion(
  DateTime now,
  JadwalShalatModel? schedule,
) {
  final minutes = now.hour * 60 + now.minute;
  final subuh = _minutes(schedule?.subuh) ?? 5 * 60;
  final dzuhur = _minutes(schedule?.dzuhur) ?? 12 * 60;
  final ashar = _minutes(schedule?.ashar) ?? 15 * 60;
  final maghrib = _minutes(schedule?.maghrib) ?? 18 * 60;
  final isya = _minutes(schedule?.isya) ?? 19 * 60;

  if (minutes >= subuh && minutes < dzuhur) {
    return const HudhudCompanionState(
      period: HudhudDayPeriod.morning,
      greeting: 'Selamat pagi',
      message: 'Awali hari dengan satu langkah ibadah yang ringan.',
      assetPath: 'assets/img/hudhud/morning.png',
    );
  }
  if (minutes >= dzuhur && minutes < ashar) {
    return const HudhudCompanionState(
      period: HudhudDayPeriod.midday,
      greeting: 'Jeda sejenak',
      message: 'Tarik napas, luruskan niat, lalu lanjutkan harimu.',
      assetPath: 'assets/img/hudhud/midday.png',
    );
  }
  if (minutes >= ashar && minutes < isya) {
    return HudhudCompanionState(
      period: HudhudDayPeriod.dusk,
      greeting: minutes < maghrib ? 'Menjelang petang' : 'Selamat petang',
      message: 'Tutup kesibukan hari ini dengan dzikir dan tilawah.',
      assetPath: 'assets/img/hudhud/dusk.png',
    );
  }
  return const HudhudCompanionState(
    period: HudhudDayPeriod.night,
    greeting: 'Malam yang tenang',
    message: 'Sempurnakan hari dengan doa sebelum beristirahat.',
    assetPath: 'assets/img/hudhud/night.png',
  );
}

int? _minutes(String? value) {
  if (value == null) return null;
  final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(value);
  if (match == null) return null;
  final hour = int.tryParse(match.group(1)!);
  final minute = int.tryParse(match.group(2)!);
  if (hour == null || minute == null || hour > 23 || minute > 59) return null;
  return hour * 60 + minute;
}
