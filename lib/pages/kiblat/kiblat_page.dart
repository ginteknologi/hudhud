import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/partial/settings_tile.dart';
import 'package:masjid_app/pages/kiblat/kiblat_compass.dart';
import 'package:masjid_app/pages/kiblat/kiblat_math.dart';
import 'package:masjid_app/providers/location_provider.dart';

/// Halaman arah kiblat: kompas yang mengikuti arah hadap HP, dengan jarum
/// menunjuk ke Ka'bah.
class KiblatPage extends ConsumerStatefulWidget {
  const KiblatPage({super.key});

  @override
  ConsumerState<KiblatPage> createState() => _KiblatPageState();
}

class _KiblatPageState extends ConsumerState<KiblatPage> {
  /// Perkiraan koordinat area Masjid An-Ni'mah Cibubur — dipakai hanya kalau
  /// user belum mengaktifkan GPS. Selisihnya di bawah 0.1° untuk seluruh
  /// Jakarta, tapi ganti angka ini kalau butuh presisi.
  static const double _defaultLatitude = -6.3728;
  static const double _defaultLongitude = 106.8811;

  /// Toleransi "sudah tepat menghadap kiblat".
  static const double _alignedWithin = 5;

  /// Kompas dianggap tidak ada kalau tidak ada data masuk selama ini.
  static const Duration _compassTimeout = Duration(seconds: 4);

  /// Akurasi kompas di atas angka ini biasanya perlu dikalibrasi dulu.
  static const double _calibrationThreshold = 15;

  StreamSubscription<CompassEvent>? _compassSub;
  Timer? _timeoutTimer;
  double? _heading;
  double? _accuracy;
  bool _compassMissing = false;
  bool _aligned = false;

  @override
  void initState() {
    super.initState();
    _listenCompass();
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _listenCompass() {
    final events = FlutterCompass.events;
    if (events == null) {
      _compassMissing = true;
      return;
    }

    _timeoutTimer = Timer(_compassTimeout, () {
      if (mounted && _heading == null) {
        setState(() => _compassMissing = true);
      }
    });

    _compassSub = events.listen(
      (event) {
        final heading = event.heading;
        // Sensor belum stabil — event pertama sering bernilai null.
        if (!mounted || heading == null) return;

        final bearing = _bearing;
        final aligned =
            shortestAngleDelta(heading, bearing).abs() <= _alignedWithin;
        if (aligned && !_aligned) HapticFeedback.mediumImpact();

        _timeoutTimer?.cancel();
        setState(() {
          _heading = heading;
          _accuracy = event.accuracy;
          _aligned = aligned;
          _compassMissing = false;
        });
      },
      onError: (_) {
        if (mounted) setState(() => _compassMissing = true);
      },
    );
  }

  double get _latitude =>
      ref.read(locationProvider).latitude ?? _defaultLatitude;

  double get _longitude =>
      ref.read(locationProvider).longitude ?? _defaultLongitude;

  double get _bearing => qiblaBearing(_latitude, _longitude);

  Future<void> _detectLocation() async {
    final error = await ref.read(locationProvider.notifier).detect();
    if (error != null && mounted) {
      Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    final bearing = _bearing;
    final distance = distanceToKaaba(_latitude, _longitude);
    final dialSize = math.min(MediaQuery.of(context).size.width - 76, 300.0);
    final needsCalibration = _accuracy != null &&
        _accuracy! > _calibrationThreshold &&
        !_compassMissing;

    return Scaffold(
      backgroundColor: kTilePageBg,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsPageHeader(
              title: 'Arah Kiblat',
              subtitle: location.isGps
                  ? location.name
                  : '${location.name} (perkiraan)',
              leading: SettingsHeaderButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => context.pop(),
              ),
            ),
            const SizedBox(height: 18),
            _statusPill(),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: dialSize,
                height: dialSize,
                child: KiblatCompass(
                  qiblaBearing: bearing,
                  heading: _compassMissing ? null : _heading,
                  alignedWithin: _alignedWithin,
                ),
              ),
            ),
            const SizedBox(height: 22),
            _stats(bearing, distance),
            const SizedBox(height: 18),
            _locationCard(location),
            if (needsCalibration) ...[
              const SizedBox(height: 18),
              _calibrationCard(),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _statusPill() {
    final (icon, text, color, background) = switch ((
      _compassMissing,
      _aligned,
    )) {
      (true, _) => (
          Icons.explore_off_rounded,
          'Kompas HP tidak tersedia — arahkan bagian atas HP ke utara, '
              'lalu ikuti jarum',
          const Color(0xFF8A6D1F),
          const Color(0xFFFDF6E3),
        ),
      (false, true) => (
          Icons.check_circle_rounded,
          'Tepat menghadap kiblat',
          kTileAccent,
          const Color(0xFFEAF5F2),
        ),
      _ => (
          Icons.screen_rotation_alt_rounded,
          'Putar HP perlahan sampai jarum emas tepat di atas',
          kTileTextMuted,
          Colors.white,
        ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats(double bearing, double distance) {
    final delta =
        _heading == null ? null : shortestAngleDelta(_heading!, bearing).abs();

    return SettingsCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            _StatTile(
              label: 'Derajat Kiblat',
              value: '${bearing.toStringAsFixed(1)}°',
            ),
            const _StatDivider(),
            _StatTile(
              label: 'Selisih',
              value: delta == null ? '—' : '${delta.toStringAsFixed(1)}°',
            ),
            const _StatDivider(),
            _StatTile(
              label: "Jarak Ka'bah",
              value: '${distance.toStringAsFixed(0)} km',
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationCard(SavedLocation location) {
    return SettingsCard(
      child: Column(
        children: [
          SettingsTapRow(
            icon: Icons.my_location_rounded,
            title: location.isGps ? 'Perbarui Lokasi GPS' : 'Pakai Lokasi GPS',
            subtitle: location.isGps
                ? location.name
                : 'Arah kiblat sementara dihitung dari perkiraan lokasi masjid',
            trailingText: location.loading ? 'Mencari...' : null,
            onTap: location.loading ? null : _detectLocation,
          ),
          if (location.isGps) ...[
            const Divider(height: 1, color: kTileBorder),
            SettingsTapRow(
              icon: Icons.mosque_rounded,
              title: 'Kembali ke Lokasi Masjid',
              subtitle: 'Hitung ulang dari koordinat masjid',
              onTap: () => ref.read(locationProvider.notifier).reset(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _calibrationCard() {
    return SettingsCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsIconBox(Icons.threesixty_rounded),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kalibrasi kompas',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kTileTextDark,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Akurasi kompas masih rendah. Jauhkan HP dari logam atau '
                    'magnet, lalu gerakkan membentuk angka 8 beberapa kali.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.45,
                      color: kTileTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kTileAccent,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: kTileTextMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: kTileBorder);
}
