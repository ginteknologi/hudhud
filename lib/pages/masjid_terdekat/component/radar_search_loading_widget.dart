import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadarPulsePainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;

  RadarPulsePainter({
    required this.animationValue,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // 1. Gambar beberapa gelombang radar (3 wave ripples)
    for (int i = 0; i < 3; i++) {
      final waveProgress = (animationValue + (i / 3.0)) % 1.0;
      final currentRadius = waveProgress * maxRadius;
      final opacity = (1.0 - waveProgress).clamp(0.0, 1.0);

      final wavePaint = Paint()
        ..color = baseColor.withValues(alpha: opacity * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      canvas.drawCircle(center, currentRadius, wavePaint);

      // Isi transparan halus di dalam gelombang
      final fillPaint = Paint()
        ..color = baseColor.withValues(alpha: opacity * 0.05)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, currentRadius, fillPaint);
    }

    // 2. Garis scanner berputar (Rotating radar sweep line)
    final sweepAngle = animationValue * 2 * math.pi;
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          baseColor.withValues(alpha: 0.0),
          baseColor.withValues(alpha: 0.35),
        ],
        transform: GradientRotation(sweepAngle),
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius, sweepPaint);

    // Garis ujung sweep
    final lineLength = maxRadius * 0.95;
    final lineEnd = Offset(
      center.dx + lineLength * math.cos(sweepAngle + math.pi / 2),
      center.dy + lineLength * math.sin(sweepAngle + math.pi / 2),
    );
    final linePaint = Paint()
      ..color = baseColor.withValues(alpha: 0.7)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, lineEnd, linePaint);

    // 3. Titik tengah (Center radar circle)
    final centerPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, centerPaint);

    final centerRing = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 8, centerRing);
  }

  @override
  bool shouldRepaint(covariant RadarPulsePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class RadarSearchLoadingWidget extends StatefulWidget {
  final String? message;
  final Color color;

  const RadarSearchLoadingWidget({
    super.key,
    this.message,
    this.color = const Color(0xFF048C7C),
  });

  @override
  State<RadarSearchLoadingWidget> createState() => _RadarSearchLoadingWidgetState();
}

class _RadarSearchLoadingWidgetState extends State<RadarSearchLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Custom Painter Animasi Radar
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(180, 180),
                      painter: RadarPulsePainter(
                        animationValue: _controller.value,
                        baseColor: widget.color,
                      ),
                    );
                  },
                ),
                // Icon Masjid di tengah
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mosque,
                    color: widget.color,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.message ?? 'Memindai masjid di sekitar Anda...',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Menggunakan data OpenStreetMap & GPS',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
