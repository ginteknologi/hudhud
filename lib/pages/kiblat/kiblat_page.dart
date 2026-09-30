import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
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
  static const double _defaultLatitude = -6.2088;
  static const double _defaultLongitude = 106.8456;
  static const double _alignedWithin = 5;
  static const Duration _compassTimeout = Duration(seconds: 4);
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
      if (mounted && _heading == null) setState(() => _compassMissing = true);
    });
    _compassSub = events.listen(
      (event) {
        final heading = event.heading;
        if (!mounted || heading == null) return;
        final aligned = shortestAngleDelta(heading, _bearing).abs() <= _alignedWithin;
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

  double get _latitude => ref.read(locationProvider).latitude ?? _defaultLatitude;
  double get _longitude => ref.read(locationProvider).longitude ?? _defaultLongitude;
  double get _bearing => qiblaBearing(_latitude, _longitude);

  Future<void> _detectLocation() async {
    final error = await ref.read(locationProvider.notifier).detect();
    if (error != null && mounted) {
      Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final location = ref.watch(locationProvider);
    final bearing = _bearing;
    final distance = distanceToKaaba(_latitude, _longitude);
    final dialSize = math.min(MediaQuery.sizeOf(context).width - 48, 300.0);
    final needsCalibration = _accuracy != null &&
        _accuracy! > _calibrationThreshold &&
        !_compassMissing;

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(
        title: const Text('Arah Kiblat'),
        leading: IconButton(
          tooltip: 'Kembali',
          constraints: BoxConstraints(minWidth: t.controlHeight, minHeight: t.controlHeight),
          onPressed: () => context.pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(bottom: t.spaceXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceMd),
              child: Text(
                '${location.name}${location.isGps ? '' : ' (perkiraan)'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.muted),
                textAlign: TextAlign.center,
              ),
            ),
            _statusPill(context),
            SizedBox(height: t.spaceMd),
            Center(
              child: SizedBox.square(
                dimension: dialSize,
                child: KiblatCompass(
                  qiblaBearing: bearing,
                  heading: _compassMissing ? null : _heading,
                  alignedWithin: _alignedWithin,
                ),
              ),
            ),
            SizedBox(height: t.spaceMd),
            _stats(context, bearing, distance),
            SizedBox(height: t.spaceMd),
            _locationCard(context, location),
            if (needsCalibration) ...[
              SizedBox(height: t.spaceMd),
              _calibrationCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusPill(BuildContext context) {
    final t = context.hudhud;
    final (icon, text, color) = switch ((_compassMissing, _aligned)) {
      (true, _) => (
          LucideIcons.compass,
          'Kompas HP tidak tersedia — arahkan bagian atas HP ke utara, lalu ikuti jarum',
          t.amber,
        ),
      (false, true) => (LucideIcons.circleCheck, 'Tepat menghadap kiblat', t.success),
      _ => (LucideIcons.rotateCw, 'Putar HP perlahan sampai jarum emas tepat di atas', t.muted),
    };
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spaceLg),
      child: Container(
        constraints: BoxConstraints(minHeight: t.controlHeight),
        padding: EdgeInsets.symmetric(horizontal: t.spaceMd, vertical: t.spaceSm),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(t.radiusMd),
          border: Border.all(color: t.outline),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: t.spaceSm),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontFamily: 'Roboto', color: t.charcoal, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats(BuildContext context, double bearing, double distance) {
    final t = context.hudhud;
    final delta = _heading == null ? null : shortestAngleDelta(_heading!, bearing).abs();
    final values = [
      ('Derajat Kiblat', '${bearing.toStringAsFixed(1)}°'),
      ('Selisih', delta == null ? '—' : '${delta.toStringAsFixed(1)}°'),
      ("Jarak Ka'bah", '${distance.toStringAsFixed(0)} km'),
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: t.spaceLg),
      padding: EdgeInsets.symmetric(vertical: t.spaceMd),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Row(
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) Container(width: 1, height: 32, color: t.outline),
            Expanded(
              child: Column(
                children: [
                  Text(values[i].$2, style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w700, color: t.terracottaDark)),
                  SizedBox(height: t.spaceXs),
                  Text(values[i].$1, maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto', fontSize: 12, color: t.muted)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _locationCard(BuildContext context, SavedLocation location) {
    final t = context.hudhud;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: t.spaceLg),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Column(
        children: [
          _locationAction(
            context,
            icon: LucideIcons.locateFixed,
            title: location.isGps ? 'Perbarui Lokasi GPS' : 'Pakai Lokasi GPS',
            subtitle: location.isGps ? location.name : 'Arah kiblat sementara dihitung dari perkiraan lokasi masjid',
            trailing: location.loading ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : null,
            onTap: location.loading ? null : _detectLocation,
          ),
          if (location.isGps) ...[
            Divider(height: 1, color: t.outline),
            _locationAction(
              context,
              icon: LucideIcons.mosque,
              title: 'Kembali ke Lokasi Masjid',
              subtitle: 'Hitung ulang dari koordinat masjid',
              onTap: () => ref.read(locationProvider.notifier).reset(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _locationAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Widget? trailing,
  }) {
    final t = context.hudhud;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.controlHeight),
          child: Padding(
            padding: EdgeInsets.all(t.spaceMd),
            child: Row(
              children: [
                Icon(icon, size: 20, color: t.terracotta),
                SizedBox(width: t.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, color: t.charcoal)),
                      SizedBox(height: t.spaceXs),
                      Text(subtitle, style: TextStyle(fontFamily: 'Roboto', color: t.muted, height: 1.35)),
                    ],
                  ),
                ),
                trailing ?? (onTap == null ? const SizedBox.shrink() : Icon(LucideIcons.chevronRight, size: 18, color: t.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _calibrationCard(BuildContext context) {
    final t = context.hudhud;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: t.spaceLg),
      constraints: BoxConstraints(minHeight: t.controlHeight),
      padding: EdgeInsets.all(t.spaceMd),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.rotate3d, size: 20, color: t.amber),
          SizedBox(width: t.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kalibrasi kompas', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600, color: t.charcoal)),
                SizedBox(height: t.spaceXs),
                Text(
                  'Akurasi kompas masih rendah. Jauhkan HP dari logam atau magnet, lalu gerakkan membentuk angka 8 beberapa kali.',
                  style: TextStyle(fontFamily: 'Roboto', color: t.muted, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
