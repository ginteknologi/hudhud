import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color appPrimary = Color(0xFFD06A4C); // Hudhud Terracotta / Cinnamon
  static const Color textPrimary = Colors.white;
  static const Color appPrimary2 = Color(0xFFECA843); // Hudhud Amber Gold
  static const Color appAccent = Color(0xFFF7EBE4); // Warm Sand Tint
  static const Color appAccent2 = Color(0xFFF0D6C8); // Soft Cinnamon Cream
  static const Color appWarning = Color(0xFFF1C40F);
  static const Color appSuccess = Color(0xFF2ECC71);
  static const Color appDanger = Color(0xFFE74C3C);
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFFBF7F2); // Warm Off-White
  static const Color primary = appPrimary;
  static const Color secondary = appAccent;
  static const Color backgroundDark = Color(0xFF212121);
  static const Color surfaceDark = Color(0xFF333333);
  static const Color primaryDark = Color(0xFF8C3B24);
  static const Color secondaryDark = appAccent;
  static const Color text = Colors.white;
  static const Color textDark = Color(0xFF2B2523); // Deep Charcoal
  static const Color grey = Color(0xFFE8E8E8);

  static Color switchColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
      WidgetState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return appPrimary;
    }
    return const Color(0xFFCBCBCB);
  }
}

final priceFormat = NumberFormat.currency(
  locale: 'id_ID',
  decimalDigits: 0,
  name: 'Rp. ',
);

final priceOnlyFormat = NumberFormat.currency(
  locale: 'id_ID',
  decimalDigits: 0,
  name: '',
);

String kmbGenerator({dynamic value, String format = 'kmb'}) {
  if (value > 999 && value < 99999) {
    final result = (value / 1000).toStringAsFixed(0);
    return format == 'kmb' ? result + 'K' : result + 'ribu';
  } else if (value > 99999 && value < 999999) {
    final result = (value / 1000).toStringAsFixed(0);
    return format == 'kmb' ? result + 'K' : result + 'ribu';
  } else if (value > 999999 && value < 999999999) {
    final result = (value / 1000000).toStringAsFixed(0);
    return format == 'kmb' ? result + 'M' : result + 'juta';
  } else if (value > 999999999) {
    final result = (value / 1000000000).toStringAsFixed(0);
    return format == 'kmb' ? result + 'B' : result + 'miliar';
  } else {
    final result = value.toString();
    return format == 'kmb' ? result : '${result}rupiah';
  }
}

Map<String, Object> bytesToSize(dynamic bytes) {
  var result = {
    'size': 0,
    'type': 'Bytes',
  };
  final sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  if (bytes == 0) return result;
  final i = log(bytes).floor() ~/ log(1024);
  result = {
    'size': (bytes / pow(1024, i)).round(),
    'type': sizes[i],
  };
  return result;
}

class AppVariables {
  static const appPadding = 20.0;
  static const EdgeInsets containerPadding = EdgeInsets.symmetric(
    horizontal: appPadding,
  );
  static const EdgeInsets containerSpacing = EdgeInsets.symmetric(
    vertical: appPadding,
  );
  static dynamic buatHargaPersen(dynamic harga, dynamic potongan) {
    final data = ((potongan / harga) * 100).round();
    return data;
  }
}

Color calculateTextColor(Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.light
      ? Colors.black
      : Colors.white;
}

TextTheme loadTextTheme(BuildContext context, String type) {
  TextStyle defaultTextStyle;
  if (type == 'dark') {
    defaultTextStyle = const TextStyle(
      color: AppColors.text,
    );
  } else {
    defaultTextStyle = const TextStyle(
      color: AppColors.textDark,
    );
  }
  return GoogleFonts.poppinsTextTheme(
    Theme.of(context)
        .textTheme
        .apply(
          displayColor: AppColors.textDark,
          bodyColor: AppColors.backgroundDark,
        )
        .copyWith(
          displayLarge: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 8,
          ),
          displayMedium: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 10,
          ),
          displaySmall: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 12,
          ),
          headlineMedium: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 14,
          ),
          headlineSmall: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 16,
          ),
          titleLarge: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 18,
          ),
          titleMedium: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 22,
          ),
          titleSmall: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 24,
          ),
          bodySmall: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 28,
          ),
          labelSmall: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 35,
          ),
          labelMedium: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 30,
          ),
          labelLarge: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 25,
          ),
          bodyLarge: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 22,
          ),
          bodyMedium: defaultTextStyle.copyWith(
            fontSize: MediaQuery.of(context).size.width / 22,
          ),
        ),
  );
}

bool isDarkMode() {
  // ignore: deprecated_member_use
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode;
}

ThemeData darkTheme(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme.copyWith(
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        primary: AppColors.primaryDark,
        error: AppColors.appDanger,
        secondary: AppColors.secondaryDark,
        surface: AppColors.surfaceDark,
      );

  const inputDecorationTheme = InputDecorationTheme(
    fillColor: AppColors.surfaceDark,
    hintStyle: TextStyle(color: AppColors.appAccent),
    border:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
  );

  final tabBarTheme = TabBarThemeData(
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white54,
    labelStyle: GoogleFonts.poppins(
      fontSize: MediaQuery.of(context).size.width / 30,
      color: Colors.white,
    ),
    unselectedLabelStyle: GoogleFonts.poppins(
      fontSize: MediaQuery.of(context).size.width / 30,
      color: Colors.white54,
    ),
  );

  final radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
  );
  final checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
  );
  final switchTheme = SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
    thumbColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
  );

  return ThemeData(
    tabBarTheme: tabBarTheme,
    inputDecorationTheme: inputDecorationTheme,
    textTheme: loadTextTheme(context, 'dark'),
    switchTheme: switchTheme,
    radioTheme: radioTheme,
    checkboxTheme: checkboxTheme,
    colorScheme: colorScheme.copyWith(error: AppColors.appDanger),
  );
}

ThemeData lightTheme(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme.copyWith(
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        primary: AppColors.primary,
        error: AppColors.appDanger,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
      );

  const inputDecorationTheme = InputDecorationTheme(
    fillColor: AppColors.appAccent,
    hintStyle: TextStyle(color: AppColors.appPrimary2),
    border:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
  );

  final tabBarTheme = TabBarThemeData(
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(color: AppColors.primary, width: 2.0),
    ),
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.primary,
    // ✅ versi kompatibel: langsung TextStyle
    labelStyle: GoogleFonts.poppins(
      fontSize: MediaQuery.of(context).size.width / 30,
      color: AppColors.primary,
    ),
    unselectedLabelStyle: GoogleFonts.poppins(
      fontSize: MediaQuery.of(context).size.width / 30,
      color: AppColors.primary.withAlpha(140),
    ),
  );

  final switchTheme = SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
    thumbColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
  );
  final radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
  );
  final checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith(AppColors.switchColor),
  );

  return ThemeData(
    tabBarTheme: tabBarTheme,
    inputDecorationTheme: inputDecorationTheme,
    textTheme: loadTextTheme(context, 'light'),
    switchTheme: switchTheme,
    radioTheme: radioTheme,
    checkboxTheme: checkboxTheme,
    primaryColor: AppColors.primary,
    colorScheme: colorScheme.copyWith(error: AppColors.appDanger),
  );
}
