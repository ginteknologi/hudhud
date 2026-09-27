import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:masjid_app/components/partial/settings_tile.dart';
import 'package:masjid_app/pages/kiblat/kiblat_math.dart';

const double _degToRad = math.pi / 180;

/// Kompas arah kiblat.
///
/// [heading] adalah arah hadap perangkat dalam derajat (0 = utara sejati).
/// Kalau `null` — kompas perangkat belum atau tidak tersedia — piringan diam
/// menghadap utara dan jarum tetap menunjukkan derajat kiblat yang sebenarnya.
class KiblatCompass extends StatefulWidget {
  const KiblatCompass({
    super.key,
    required this.qiblaBearing,
    required this.heading,
    this.alignedWithin = 5,
  });

  final double qiblaBearing;
  final double? heading;

  /// Toleransi selisih (derajat) yang masih dianggap tepat menghadap kiblat.
  final double alignedWithin;

  @override
  State<KiblatCompass> createState() => _KiblatCompassState();
}

class _KiblatCompassState extends State<KiblatCompass>
    with SingleTickerProviderStateMixin {
  /// Sudut yang benar-benar digambar, selalu dianimasikan menuju [_target].
  /// Nilai sensor digambar mentah-mentah akan terlihat bergetar.
  final ValueNotifier<double> _drawn = ValueNotifier<double>(0);

  /// Fase denyut kilau saat jarum sudah tepat menghadap kiblat (0..1).
  final ValueNotifier<double> _glow = ValueNotifier<double>(0);

  late final Listenable _repaint = Listenable.merge([_drawn, _glow]);
  late final Ticker _ticker;

  double _target = 0;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _target = widget.heading ?? 0;
    _drawn.value = _target;
    if (widget.heading != null) _ticker.start();
  }

  @override
  void didUpdateWidget(covariant KiblatCompass oldWidget) {
    super.didUpdateWidget(oldWidget);
    final heading = widget.heading;
    if (heading == null || heading == oldWidget.heading) return;

    // Tambahkan selisih terpendek ke sudut yang sedang digambar — bukan
    // mengganti nilainya — supaya lintasannya pendek dan tetap mulus saat
    // sensor mengirim 359.6 lalu 0.4.
    _target = _drawn.value + shortestAngleDelta(_drawn.value, heading);
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _drawn.dispose();
    _glow.dispose();
    super.dispose();
  }

  bool get _isAligned =>
      shortestAngleDelta(_drawn.value, widget.qiblaBearing).abs() <=
      widget.alignedWithin;

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;

    if (dt > 0) {
      final diff = _target - _drawn.value;
      if (diff.abs() < 0.05) {
        _drawn.value = _target;
      } else {
        // Peluruhan eksponensial: hasilnya sama di layar 60Hz maupun 120Hz.
        _drawn.value += diff * (1 - math.exp(-dt * 9));
      }
    }

    // Denyut kilau hanya jalan saat jarum sudah tepat; di luar itu ticker
    // dimatikan supaya halaman diam tidak membuang frame.
    if (_isAligned) {
      _glow.value =
          0.5 + 0.5 * math.sin(elapsed.inMilliseconds / 1500 * 2 * math.pi);
    } else {
      _glow.value = 0;
      if ((_target - _drawn.value).abs() < 0.05) _ticker.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _repaint,
      builder: (context, _) {
        final heading = _drawn.value;
        final aligned = _isAligned;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Piringan mata angin berputar berlawanan arah hadap perangkat.
            Transform.rotate(
              angle: -heading * _degToRad,
              child: CustomPaint(painter: _DialPainter(aligned: aligned)),
            ),
            // Jarum kiblat: sudut sebenarnya dikurangi arah hadap perangkat.
            Transform.rotate(
              angle: (widget.qiblaBearing - heading) * _degToRad,
              child: CustomPaint(
                painter: _QiblaPainter(glow: _glow.value, aligned: aligned),
              ),
            ),
            Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: aligned ? kTileGold : kTileAccent,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kTileAccent.withValues(alpha: 0.18),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Piringan kompas: cincin, garis derajat, dan huruf mata angin.
class _DialPainter extends CustomPainter {
  const _DialPainter({required this.aligned});

  final bool aligned;

  static const Map<String, double> _cardinals = {
    'U': 0,
    'T': 90,
    'S': 180,
    'B': 270,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    canvas.drawCircle(center, radius, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = aligned ? kTileAccent : kTileBorder,
    );
    canvas.drawCircle(
      center,
      radius * 0.84,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = const Color(0xFFEAF1EF),
    );

    for (var degrees = 0; degrees < 360; degrees += 5) {
      final isCardinal = degrees % 45 == 0;
      final isMedium = degrees % 15 == 0;
      final length = isCardinal
          ? radius * 0.09
          : isMedium
              ? radius * 0.055
              : radius * 0.03;
      final direction = degrees * _degToRad - math.pi / 2;

      final outer = Offset(
        center.dx + math.cos(direction) * (radius - 7),
        center.dy + math.sin(direction) * (radius - 7),
      );
      final inner = Offset(
        center.dx + math.cos(direction) * (radius - 7 - length),
        center.dy + math.sin(direction) * (radius - 7 - length),
      );

      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..strokeWidth = isCardinal ? 1.8 : 1
          ..strokeCap = StrokeCap.round
          ..color = isCardinal ? kTileTextDark : const Color(0xFFC9D6D2),
      );
    }

    _cardinals.forEach((label, degrees) {
      final isNorth = degrees == 0;
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: isNorth ? kTileGold : kTileTextMuted,
            fontSize: radius * 0.13,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final direction = degrees * _degToRad - math.pi / 2;
      final position = Offset(
        center.dx + math.cos(direction) * radius * 0.70,
        center.dy + math.sin(direction) * radius * 0.70,
      );
      painter.paint(
        canvas,
        position - Offset(painter.width / 2, painter.height / 2),
      );
    });
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) =>
      oldDelegate.aligned != aligned;
}

/// Jarum penunjuk kiblat beserta lambang Ka'bah di ujungnya.
///
/// Digambar menghadap atas; pemutaran ke arah sebenarnya dilakukan oleh
/// [Transform.rotate] di [KiblatCompass].
class _QiblaPainter extends CustomPainter {
  const _QiblaPainter({required this.glow, required this.aligned});

  final double glow;
  final bool aligned;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    if (aligned) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              kTileAccent.withValues(alpha: 0),
              kTileAccent.withValues(alpha: 0.06 + 0.12 * glow),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    final tip = Offset(center.dx, center.dy - radius * 0.62);
    final baseY = center.dy - radius * 0.06;
    final halfWidth = radius * 0.032;

    final needle = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(center.dx + halfWidth, baseY)
      ..lineTo(center.dx - halfWidth, baseY)
      ..close();

    canvas.drawPath(
      needle,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kTileAccent, Color(0xFFD06A4C)],
        ).createShader(Rect.fromPoints(tip, Offset(center.dx, baseY))),
    );
    canvas.drawCircle(tip, radius * 0.024, Paint()..color = kTileGold);

    _paintKaaba(canvas, Offset(center.dx, center.dy - radius * 0.79), radius);
  }

  /// Lambang Ka'bah sederhana: kotak hitam berpita emas.
  void _paintKaaba(Canvas canvas, Offset center, double radius) {
    final side = radius * 0.24;
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: side, height: side),
      Radius.circular(side * 0.22),
    );

    canvas.drawRRect(body, Paint()..color = const Color(0xFF16181A));

    canvas.save();
    canvas.clipRRect(body);
    canvas.drawRect(
      Rect.fromLTWH(
        body.left,
        center.dy - side * 0.18,
        side,
        side * 0.15,
      ),
      Paint()..color = kTileGold,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + side * 0.20),
        width: side * 0.24,
        height: side * 0.34,
      ),
      Paint()..color = kTileGold,
    );
    canvas.restore();

    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _QiblaPainter oldDelegate) =>
      oldDelegate.glow != glow || oldDelegate.aligned != aligned;
}
