import 'package:flutter/material.dart';

import '../../theme.dart';

class ButtonIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Icon icon;
  final Color color;
  final Color bgcolor;
  final Color iconColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final bool rounded;
  const ButtonIcon({
    Key? key,
    required this.onTap,
    required this.icon,
    this.color = AppColors.appPrimary,
    this.bgcolor = AppColors.textPrimary,
    this.iconColor = Colors.black,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.rounded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius:
            rounded ? BorderRadius.circular(50) : BorderRadius.circular(5.0),
        color: bgcolor,
        // border: Border.all(width: 2.0, color: Colors.white)
      ),
      // chevron-left
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: color.withAlpha(100),
          borderRadius:
              rounded ? BorderRadius.circular(50) : BorderRadius.circular(0),
          onTap: onTap,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
