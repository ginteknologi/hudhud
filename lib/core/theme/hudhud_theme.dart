import 'package:flutter/material.dart';

@immutable
class HudhudTheme extends ThemeExtension<HudhudTheme> {
  const HudhudTheme({
    required this.terracotta,
    required this.terracottaDark,
    required this.amber,
    required this.sand,
    required this.surface,
    required this.charcoal,
    required this.muted,
    required this.outline,
    required this.success,
    required this.danger,
    this.spaceXs = 4,
    this.spaceSm = 8,
    this.spaceMd = 12,
    this.spaceLg = 16,
    this.spaceXl = 24,
    this.radiusSm = 4,
    this.radiusMd = 8,
    this.controlHeight = 48,
    this.motionFast = const Duration(milliseconds: 180),
    this.motionNormal = const Duration(milliseconds: 220),
  });

  static const light = HudhudTheme(
    terracotta: Color(0xFFD06A4C),
    terracottaDark: Color(0xFF9E4B35),
    amber: Color(0xFFECA843),
    sand: Color(0xFFFBF7F2),
    surface: Color(0xFFFFFFFF),
    charcoal: Color(0xFF2B2523),
    muted: Color(0xFF675C57),
    outline: Color(0xFFE4DCD6),
    success: Color(0xFF357A56),
    danger: Color(0xFFB6433D),
  );

  final Color terracotta;
  final Color terracottaDark;
  final Color amber;
  final Color sand;
  final Color surface;
  final Color charcoal;
  final Color muted;
  final Color outline;
  final Color success;
  final Color danger;
  final double spaceXs;
  final double spaceSm;
  final double spaceMd;
  final double spaceLg;
  final double spaceXl;
  final double radiusSm;
  final double radiusMd;
  final double controlHeight;
  final Duration motionFast;
  final Duration motionNormal;

  @override
  HudhudTheme copyWith({
    Color? terracotta,
    Color? terracottaDark,
    Color? amber,
    Color? sand,
    Color? surface,
    Color? charcoal,
    Color? muted,
    Color? outline,
    Color? success,
    Color? danger,
    double? spaceXs,
    double? spaceSm,
    double? spaceMd,
    double? spaceLg,
    double? spaceXl,
    double? radiusSm,
    double? radiusMd,
    double? controlHeight,
    Duration? motionFast,
    Duration? motionNormal,
  }) =>
      HudhudTheme(
        terracotta: terracotta ?? this.terracotta,
        terracottaDark: terracottaDark ?? this.terracottaDark,
        amber: amber ?? this.amber,
        sand: sand ?? this.sand,
        surface: surface ?? this.surface,
        charcoal: charcoal ?? this.charcoal,
        muted: muted ?? this.muted,
        outline: outline ?? this.outline,
        success: success ?? this.success,
        danger: danger ?? this.danger,
        spaceXs: spaceXs ?? this.spaceXs,
        spaceSm: spaceSm ?? this.spaceSm,
        spaceMd: spaceMd ?? this.spaceMd,
        spaceLg: spaceLg ?? this.spaceLg,
        spaceXl: spaceXl ?? this.spaceXl,
        radiusSm: radiusSm ?? this.radiusSm,
        radiusMd: radiusMd ?? this.radiusMd,
        controlHeight: controlHeight ?? this.controlHeight,
        motionFast: motionFast ?? this.motionFast,
        motionNormal: motionNormal ?? this.motionNormal,
      );

  @override
  HudhudTheme lerp(covariant HudhudTheme? other, double t) {
    if (other == null) return this;
    return copyWith(
      terracotta: Color.lerp(terracotta, other.terracotta, t),
      terracottaDark: Color.lerp(terracottaDark, other.terracottaDark, t),
      amber: Color.lerp(amber, other.amber, t),
      sand: Color.lerp(sand, other.sand, t),
      surface: Color.lerp(surface, other.surface, t),
      charcoal: Color.lerp(charcoal, other.charcoal, t),
      muted: Color.lerp(muted, other.muted, t),
      outline: Color.lerp(outline, other.outline, t),
      success: Color.lerp(success, other.success, t),
      danger: Color.lerp(danger, other.danger, t),
      spaceXs: _lerp(spaceXs, other.spaceXs, t),
      spaceSm: _lerp(spaceSm, other.spaceSm, t),
      spaceMd: _lerp(spaceMd, other.spaceMd, t),
      spaceLg: _lerp(spaceLg, other.spaceLg, t),
      spaceXl: _lerp(spaceXl, other.spaceXl, t),
      radiusSm: _lerp(radiusSm, other.radiusSm, t),
      radiusMd: _lerp(radiusMd, other.radiusMd, t),
      controlHeight: _lerp(controlHeight, other.controlHeight, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
}

extension HudhudThemeContext on BuildContext {
  HudhudTheme get hudhud => Theme.of(this).extension<HudhudTheme>()!;
}
