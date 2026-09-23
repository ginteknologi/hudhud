import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontListV2 {
  static TextStyle title({
    required BuildContext context,
    FontWeight weight = FontWeight.w400,
    double height = 1.2,
    Color color = Colors.black,
    double? size,
  }) {
    return _coreFonts(
      type: "title",
      context: context,
      height: height,
      weight: weight,
      size: size,
      color: color,
    );
  }

  static TextStyle subtitle({
    required BuildContext context,
    FontWeight weight = FontWeight.w400,
    double height = 1.2,
    Color color = Colors.black,
    double? size,
  }) {
    return _coreFonts(
      type: "subtitle",
      context: context,
      height: height,
      weight: weight,
      size: size,
      color: color,
    );
  }

  static TextStyle _coreFonts({
    required String type,
    required BuildContext context,
    required double height,
    required FontWeight weight,
    required Color color,
    required double? size,
  }) {
    late double size0;
    if (size != null) {
      size0 = size;
    } else {
      if (type == 'title') {
        size0 = Theme.of(context).textTheme.titleMedium!.fontSize!;
      } else {
        size0 = Theme.of(context).textTheme.bodySmall!.fontSize!;
      }
    }

    final fontConfig = GoogleFonts.poppins(
      fontSize: size0,
      color: color,
      height: height,
      fontWeight: weight,
    );

    late TextStyle fontFinal;
    if (type == 'title') {
      fontFinal = Theme.of(context).textTheme.titleMedium!.merge(fontConfig);
    } else {
      fontFinal = Theme.of(context).textTheme.bodySmall!.merge(fontConfig);
    }

    return fontFinal;
  }
}