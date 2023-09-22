import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontListV2 {
  static title({
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

  static subtitle({
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

  static _coreFonts({
    required type,
    required context,
    required height,
    required weight,
    required color,
    required size,
  }) {
    late double _size;
    if (size != null) {
      _size = size.toDouble();
    } else {
      if (type == 'title') {
        _size = Theme.of(context).textTheme.subtitle1!.fontSize!;
      } else {
        _size = Theme.of(context).textTheme.caption!.fontSize!;
      }
    }
    final fontConfig = GoogleFonts.poppins(
      fontSize: _size,
      color: color,
      height: height,
      fontWeight: weight,
    );
    late TextStyle fontFinal;
    if (type == 'title') {
      fontFinal = Theme.of(context).textTheme.subtitle1!.merge(fontConfig);
    } else {
      fontFinal = Theme.of(context).textTheme.caption!.merge(fontConfig);
    }
    return fontFinal;
  }
}
