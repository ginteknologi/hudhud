import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

class AppColors {
  static const Color appPrimary = Color(0xFFD06A4C);
  static const Color textPrimary = Colors.white;
  static const Color appPrimary2 = Color(0xFFECA843);
  static const Color appAccent = Color(0xFFF7EBE4);
  static const Color appAccent2 = Color(0xFFF0D6C8);
  static const Color appWarning = Color(0xFFECA843);
  static const Color appSuccess = Color(0xFF357A56);
  static const Color appDanger = Color(0xFFB6433D);
  static const Color background = Color(0xFFFBF7F2);
  static const Color surface = Colors.white;
  static const Color primary = appPrimary;
  static const Color secondary = appAccent;
  static const Color backgroundDark = Color(0xFF211C1A);
  static const Color surfaceDark = Color(0xFF302A27);
  static const Color primaryDark = Color(0xFF9E4B35);
  static const Color secondaryDark = appAccent;
  static const Color text = Colors.white;
  static const Color textDark = Color(0xFF2B2523);
  static const Color grey = Color(0xFFE4DCD6);

  static Color switchColor(Set<WidgetState> states) =>
      states.contains(WidgetState.selected)
          ? appPrimary
          : const Color(0xFFB8AEA9);
}

final priceFormat =
    NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, name: 'Rp. ');
final priceOnlyFormat =
    NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, name: '');

String kmbGenerator({dynamic value, String format = 'kmb'}) {
  if (value > 999999999) {
    return format == 'kmb'
        ? '${(value / 1000000000).round()}B'
        : '${(value / 1000000000).round()}miliar';
  }
  if (value > 999999) {
    return format == 'kmb'
        ? '${(value / 1000000).round()}M'
        : '${(value / 1000000).round()}juta';
  }
  if (value > 999) {
    return format == 'kmb'
        ? '${(value / 1000).round()}K'
        : '${(value / 1000).round()}ribu';
  }
  return format == 'kmb' ? '$value' : '${value}rupiah';
}

Map<String, Object> bytesToSize(dynamic bytes) {
  if (bytes == 0) return {'size': 0, 'type': 'Bytes'};
  final sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  final i = log(bytes).floor() ~/ log(1024);
  return {'size': (bytes / pow(1024, i)).round(), 'type': sizes[i]};
}

class AppVariables {
  static const appPadding = 20.0;
  static const EdgeInsets containerPadding =
      EdgeInsets.symmetric(horizontal: appPadding);
  static const EdgeInsets containerSpacing =
      EdgeInsets.symmetric(vertical: appPadding);
  static dynamic buatHargaPersen(dynamic harga, dynamic potongan) =>
      ((potongan / harga) * 100).round();
}

Color calculateTextColor(Color background) =>
    ThemeData.estimateBrightnessForColor(background) == Brightness.light
        ? Colors.black
        : Colors.white;

TextTheme loadTextTheme(BuildContext context, String type) {
  const ink = Color(0xFF2B2523);
  const muted = Color(0xFF675C57);
  const base = TextStyle(fontFamily: 'Roboto', color: ink, height: 1.35);
  return TextTheme(
    displayLarge:
        base.copyWith(fontSize: 40, fontWeight: FontWeight.w700, height: 1.1),
    displayMedium:
        base.copyWith(fontSize: 34, fontWeight: FontWeight.w700, height: 1.15),
    displaySmall:
        base.copyWith(fontSize: 28, fontWeight: FontWeight.w700, height: 1.15),
    headlineMedium: base.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
    headlineSmall: base.copyWith(fontSize: 21, fontWeight: FontWeight.w700),
    titleLarge: base.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
    titleMedium: base.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    titleSmall: base.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    bodyLarge: base.copyWith(fontSize: 16),
    bodyMedium: base.copyWith(fontSize: 14),
    bodySmall: base.copyWith(fontSize: 12, color: muted),
    labelLarge: base.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
    labelMedium: base.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
    labelSmall: base.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
  );
}

bool isDarkMode() => false;

ThemeData _theme(BuildContext context) {
  const tokens = HudhudTheme.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: tokens.terracotta,
    brightness: Brightness.light,
    primary: tokens.terracotta,
    secondary: tokens.amber,
    surface: tokens.surface,
    error: tokens.danger,
  );
  final radius = BorderRadius.circular(tokens.radiusMd);
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: tokens.sand,
    colorScheme: scheme,
    fontFamily: 'Roboto',
    textTheme: loadTextTheme(context, 'light'),
    extensions: const [HudhudTheme.light],
    dividerTheme: const DividerThemeData(
        color: Color(0xFFE4DCD6), thickness: 1, space: 1),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: tokens.sand,
      foregroundColor: tokens.charcoal,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: tokens.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: radius),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        backgroundColor: tokens.terracotta,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radius),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: tokens.terracottaDark,
        side: BorderSide(color: tokens.outline),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tokens.surface,
      hintStyle: TextStyle(color: tokens.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: radius, borderSide: BorderSide(color: tokens.outline)),
      enabledBorder: OutlineInputBorder(
          borderRadius: radius, borderSide: BorderSide(color: tokens.outline)),
      focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: tokens.terracotta, width: 2)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: tokens.surface,
      indicatorColor: tokens.terracotta.withValues(alpha: .14),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? tokens.terracottaDark
                : tokens.muted,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          )),
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? tokens.terracotta
                : tokens.muted,
            size: 23,
          )),
    ),
  );
}

ThemeData lightTheme(BuildContext context) => _theme(context);
ThemeData darkTheme(BuildContext context) => _theme(context);
