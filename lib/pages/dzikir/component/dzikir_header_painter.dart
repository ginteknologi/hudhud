import 'dart:math' as math;
import 'package:flutter/material.dart';

class DzikirAnimatedBackground extends StatefulWidget {
  final bool isPetang;
  final Widget child;

  const DzikirAnimatedBackground({
    super.key,
    required this.isPetang,
    required this.child,
  });

  @override
  State<DzikirAnimatedBackground> createState() => _DzikirAnimatedBackgroundState();
}

class _DzikirAnimatedBackgroundState extends State<DzikirAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: DzikirFullScreenPainter(
            isPetang: widget.isPetang,
            progress: _controller.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class DzikirFullScreenPainter extends CustomPainter {
  final bool isPetang;
  final double progress; // 0.0 -> 1.0

  DzikirFullScreenPainter({
    required this.isPetang,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    if (!isPetang) {
      _paintPagi(canvas, size, rect);
    } else {
      _paintPetang(canvas, size, rect);
    }
  }

  void _paintPagi(Canvas canvas, Size size, Rect rect) {
    // 1. Soft Warm Sunrise Gradient covering the full screen
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFFE88A3C), // Vibrant morning orange at top right
          Color(0xFFE8AB52), // Golden amber
          Color(0xFFD06A4C), // Calming emerald transition
          Color(0xFF0C5047), // Deep emerald base
          Color(0xFF083E38), // Grounded teal bottom
        ],
        stops: [0.0, 0.22, 0.58, 0.85, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, skyPaint);

    // 2. Rising Sun (Top Right with warm pulsing glow)
    final sunCenter = Offset(size.width * 0.82, 110);
    final pulseScale = 1.0 + 0.08 * math.sin(progress * 2 * math.pi);
    final sunRadius = 42.0 * pulseScale;

    // Outer Glow
    final sunGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE082).withValues(alpha: 0.40),
          const Color(0xFFFFB74D).withValues(alpha: 0.16),
          Colors.transparent,
        ],
        stops: const [0.25, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius * 3.2));
    canvas.drawCircle(sunCenter, sunRadius * 3.2, sunGlowPaint);

    // Rotating Sun Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFFF8E1).withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final rayCount = 14;
    final rayAngleOffset = progress * 2 * math.pi;
    for (int i = 0; i < rayCount; i++) {
      final angle = rayAngleOffset + (i * 2 * math.pi / rayCount);
      final innerR = sunRadius + 6;
      final outerR = sunRadius + 22 + 6 * math.sin((progress * 4 * math.pi) + i);
      final p1 = Offset(
        sunCenter.dx + innerR * math.cos(angle),
        sunCenter.dy + innerR * math.sin(angle),
      );
      final p2 = Offset(
        sunCenter.dx + outerR * math.cos(angle),
        sunCenter.dy + outerR * math.sin(angle),
      );
      canvas.drawLine(p1, p2, rayPaint);
    }

    // Sun Core
    final sunCorePaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFFFDE7),
          Color(0xFFFFEE58),
          Color(0xFFFFA726),
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius));
    canvas.drawCircle(sunCenter, sunRadius, sunCorePaint);

    // 3. Floating Light Morning Particles scattered throughout the screen
    final particlePaint = Paint()..style = PaintingStyle.fill;
    final particleCoords = [
      Offset(size.width * 0.15, size.height * 0.08),
      Offset(size.width * 0.35, size.height * 0.14),
      Offset(size.width * 0.60, size.height * 0.06),
      Offset(size.width * 0.20, size.height * 0.28),
      Offset(size.width * 0.85, size.height * 0.32),
      Offset(size.width * 0.10, size.height * 0.45),
      Offset(size.width * 0.75, size.height * 0.52),
      Offset(size.width * 0.30, size.height * 0.65),
      Offset(size.width * 0.90, size.height * 0.72),
      Offset(size.width * 0.18, size.height * 0.84),
      Offset(size.width * 0.65, size.height * 0.90),
    ];

    for (int i = 0; i < particleCoords.length; i++) {
      final p = particleCoords[i];
      final floatY = math.sin((progress * 2 * math.pi) + (i * 1.3)) * 8;
      final alpha = (0.2 + 0.35 * math.cos((progress * 2 * math.pi) + i)).clamp(0.0, 1.0);
      particlePaint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(p.dx, p.dy + floatY), 2.5 + (i % 2), particlePaint);
    }
  }

  void _paintPetang(Canvas canvas, Size size, Rect rect) {
    // 1. Deep Midnight Twilight Gradient across the full screen
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF070B18), // Deepest midnight blue
          Color(0xFF121532), // Indigo dusk
          Color(0xFF162534), // Dark twilight teal
          Color(0xFF0C2020), // Forest night emerald
          Color(0xFF051413), // Deep nocturnal base
        ],
        stops: [0.0, 0.25, 0.55, 0.82, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, skyPaint);

    // 2. Animated Aurora / Night Nebula Wave (Gentle glowing veil drifting across the night sky)
    final nebulaPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 32
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);

    final nebulaWaveOffset = math.sin(progress * 2 * math.pi) * 20;
    final nebulaPath = Path()
      ..moveTo(-50, size.height * 0.25 + nebulaWaveOffset)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.18 - nebulaWaveOffset,
        size.width * 0.6,
        size.height * 0.32 + nebulaWaveOffset,
        size.width + 50,
        size.height * 0.22 - nebulaWaveOffset,
      );

    nebulaPaint.shader = LinearGradient(
      colors: [
        const Color(0xFF00E5FF).withValues(alpha: 0.08),
        const Color(0xFF7C4DFF).withValues(alpha: 0.12),
        const Color(0xFF00BFA5).withValues(alpha: 0.06),
      ],
    ).createShader(rect);
    canvas.drawPath(nebulaPath, nebulaPaint);

    // Second gentle aurora ribbon in lower area
    final nebulaPath2 = Path()
      ..moveTo(-50, size.height * 0.65 - nebulaWaveOffset)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.72 + nebulaWaveOffset,
        size.width * 0.7,
        size.height * 0.60 - nebulaWaveOffset,
        size.width + 50,
        size.height * 0.68 + nebulaWaveOffset,
      );
    nebulaPaint.shader = LinearGradient(
      colors: [
        const Color(0xFF7C4DFF).withValues(alpha: 0.08),
        const Color(0xFF00BFA5).withValues(alpha: 0.10),
        const Color(0xFF1DE9B6).withValues(alpha: 0.05),
      ],
    ).createShader(rect);
    canvas.drawPath(nebulaPath2, nebulaPaint);

    // 3. Dynamic Twinkling Stars (Rich Starfield with variable pulse & sparkle)
    final starPaint = Paint()..style = PaintingStyle.fill;
    final starCoords = [
      Offset(size.width * 0.08, size.height * 0.04),
      Offset(size.width * 0.24, size.height * 0.07),
      Offset(size.width * 0.42, size.height * 0.03),
      Offset(size.width * 0.62, size.height * 0.06),
      Offset(size.width * 0.15, size.height * 0.14),
      Offset(size.width * 0.34, size.height * 0.18),
      Offset(size.width * 0.52, size.height * 0.12),
      Offset(size.width * 0.68, size.height * 0.16),
      Offset(size.width * 0.92, size.height * 0.11),
      Offset(size.width * 0.10, size.height * 0.25),
      Offset(size.width * 0.28, size.height * 0.29),
      Offset(size.width * 0.48, size.height * 0.24),
      Offset(size.width * 0.72, size.height * 0.27),
      Offset(size.width * 0.88, size.height * 0.22),
      Offset(size.width * 0.06, size.height * 0.38),
      Offset(size.width * 0.38, size.height * 0.36),
      Offset(size.width * 0.58, size.height * 0.41),
      Offset(size.width * 0.82, size.height * 0.35),
      Offset(size.width * 0.18, size.height * 0.48),
      Offset(size.width * 0.46, size.height * 0.50),
      Offset(size.width * 0.76, size.height * 0.46),
      Offset(size.width * 0.94, size.height * 0.49),
      Offset(size.width * 0.12, size.height * 0.60),
      Offset(size.width * 0.32, size.height * 0.62),
      Offset(size.width * 0.64, size.height * 0.58),
      Offset(size.width * 0.86, size.height * 0.64),
      Offset(size.width * 0.22, size.height * 0.72),
      Offset(size.width * 0.50, size.height * 0.70),
      Offset(size.width * 0.74, size.height * 0.75),
      Offset(size.width * 0.08, size.height * 0.84),
      Offset(size.width * 0.36, size.height * 0.82),
      Offset(size.width * 0.62, size.height * 0.86),
      Offset(size.width * 0.90, size.height * 0.81),
      Offset(size.width * 0.26, size.height * 0.93),
      Offset(size.width * 0.54, size.height * 0.91),
      Offset(size.width * 0.80, size.height * 0.94),
    ];

    for (int i = 0; i < starCoords.length; i++) {
      final s = starCoords[i];
      // Kecepatan dan fase kedipan acak unik tiap bintang
      final speedFactor = 3.0 + (i % 5);
      final phase = (progress * speedFactor * 2 * math.pi) + (i * 1.7);
      final twinkle = 0.15 + 0.85 * (0.5 + 0.5 * math.sin(phase));
      final starSize = 1.3 + (i % 3) * 0.7;

      starPaint.color = Colors.white.withValues(alpha: twinkle.clamp(0.0, 1.0));
      canvas.drawCircle(s, starSize, starPaint);

      // Sparkle cross untuk bintang-bintang utama
      if (i % 3 == 0) {
        final crossLen = 3.0 + (i % 4);
        final sparklePaint = Paint()
          ..color = (i % 2 == 0 ? const Color(0xFFE0F7FA) : Colors.white)
              .withValues(alpha: (twinkle * 0.75).clamp(0.0, 1.0))
          ..strokeWidth = 0.85;
        canvas.drawLine(Offset(s.dx - crossLen, s.dy), Offset(s.dx + crossLen, s.dy), sparklePaint);
        canvas.drawLine(Offset(s.dx, s.dy - crossLen), Offset(s.dx, s.dy + crossLen), sparklePaint);
      }
    }

    // 4. Floating Fireflies / Glowing Night Lights (Kunang-kunang malam melayang lembut)
    final fireflyPaint = Paint()..style = PaintingStyle.fill;
    final fireflies = [
      Offset(size.width * 0.16, size.height * 0.32),
      Offset(size.width * 0.80, size.height * 0.40),
      Offset(size.width * 0.28, size.height * 0.55),
      Offset(size.width * 0.70, size.height * 0.68),
      Offset(size.width * 0.40, size.height * 0.78),
      Offset(size.width * 0.85, size.height * 0.86),
    ];

    for (int i = 0; i < fireflies.length; i++) {
      final f = fireflies[i];
      final driftX = math.sin((progress * 2 * math.pi) + (i * 1.5)) * 14;
      final driftY = math.cos((progress * 2 * math.pi) + (i * 2.1)) * 10;
      final glowPulse = 0.3 + 0.6 * (0.5 + 0.5 * math.sin((progress * 6 * math.pi) + i));

      // Glow halo kunang-kunang
      fireflyPaint.color = const Color(0xFF64FFDA).withValues(alpha: (glowPulse * 0.25).clamp(0.0, 1.0));
      canvas.drawCircle(Offset(f.dx + driftX, f.dy + driftY), 6.0, fireflyPaint);

      // Core kunang-kunang
      fireflyPaint.color = const Color(0xFFE0F2F1).withValues(alpha: glowPulse.clamp(0.0, 1.0));
      canvas.drawCircle(Offset(f.dx + driftX, f.dy + driftY), 2.0, fireflyPaint);
    }

    // 5. Periodic Shooting Star (Bintang Jatuh yang melesat berkala)
    // Berjalan saat progress antara 0.20 - 0.40 dan 0.70 - 0.90
    double meteorT = -1;
    if (progress >= 0.15 && progress <= 0.35) {
      meteorT = (progress - 0.15) / 0.20;
    } else if (progress >= 0.65 && progress <= 0.85) {
      meteorT = (progress - 0.65) / 0.20;
    }

    if (meteorT >= 0.0 && meteorT <= 1.0) {
      final startMeteor = Offset(size.width * 0.75, size.height * 0.05);
      final meteorLen = 50.0;
      final curX = startMeteor.dx - meteorT * (size.width * 0.55);
      final curY = startMeteor.dy + meteorT * (size.height * 0.25);
      final tailX = curX + meteorLen * 0.85;
      final tailY = curY - meteorLen * 0.45;

      final meteorOpacity = math.sin(meteorT * math.pi); // Fade in & fade out
      final meteorPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.white.withValues(alpha: (meteorOpacity * 0.9).clamp(0.0, 1.0)),
            const Color(0xFF80DEEA).withValues(alpha: (meteorOpacity * 0.5).clamp(0.0, 1.0)),
            Colors.transparent,
          ],
        ).createShader(Rect.fromPoints(Offset(curX, curY), Offset(tailX, tailY)))
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(curX, curY), Offset(tailX, tailY), meteorPaint);

      // Head spark
      final sparkPaint = Paint()
        ..color = Colors.white.withValues(alpha: (meteorOpacity * 0.95).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(curX, curY), 2.2, sparkPaint);
    }

    // 6. Crescent Moon with Dynamic Pulsing Radiant Halo
    final moonCenter = Offset(size.width * 0.82, 105);
    final moonRadius = 34.0;
    final moonPulse = 1.0 + 0.06 * math.sin(progress * 2 * math.pi);

    // Radiant Moon Halo
    final moonGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF9C4).withValues(alpha: 0.40),
          const Color(0xFF80DEEA).withValues(alpha: 0.16),
          Colors.transparent,
        ],
        stops: const [0.25, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: moonCenter, radius: moonRadius * 3.2 * moonPulse));
    canvas.drawCircle(moonCenter, moonRadius * 3.2 * moonPulse, moonGlowPaint);

    // Crescent Moon Body
    final moonPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFFFDE7),
          Color(0xFFFFF59D),
          Color(0xFFFFEE58),
        ],
      ).createShader(Rect.fromCircle(center: moonCenter, radius: moonRadius));

    final moonPath = Path()
      ..addOval(Rect.fromCircle(center: moonCenter, radius: moonRadius));
    final cutCenter = Offset(moonCenter.dx - 10, moonCenter.dy - 6);
    final cutPath = Path()
      ..addOval(Rect.fromCircle(center: cutCenter, radius: moonRadius * 0.88));

    final crescentPath = Path.combine(PathOperation.difference, moonPath, cutPath);
    canvas.drawPath(crescentPath, moonPaint);
  }

  @override
  bool shouldRepaint(covariant DzikirFullScreenPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isPetang != isPetang;
  }
}
