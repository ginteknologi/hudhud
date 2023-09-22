import 'package:flutter/material.dart';

import '../../theme.dart';

class ButtonText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final double radius;
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;
  final VoidCallback onPressed;
  const ButtonText(
      {Key? key,
      required this.text,
      this.color = AppColors.appPrimary,
      this.size = 15,
      this.radius = 0,
      this.height = 50,
      this.width = 100,
      this.margin = const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: size),
        ),
      ),
    );
  }
}
