import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontListV2 {
  static dynamic title({
    required context,
    weight = FontWeight.w400,
    height = 1.2,
    color = Colors.black,
    size,
  }) {
    return _coreFonts(
        type: "title",
        context: context,
        height: height,
        weight: weight,
        size: size,
        color: color);
  }

  static dynamic subtitle({
    required context,
    weight = FontWeight.w400,
    height = 1.2,
    color = Colors.black,
    size,
  }) {
    return _coreFonts(
        type: "subtitle",
        context: context,
        height: height,
        weight: weight,
        size: size,
        color: color);
  }

  static TextStyle _coreFonts({
    required type,
    required context,
    required height,
    required weight,
    required color,
    required size,
  }) {
    late double size0;
    if (size != null) {
      size0 = size.toDouble();
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
