import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../../theme.dart';

class ButtonElevated extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final double size;
  final double radius;
  final bool selected;
  final String showIcon;
  final bool iconOnly;
  final Icon iconLeft;
  final Icon iconRight;
  final bool justify;
  final bool disabled;
  final EdgeInsetsGeometry margin;
  final Color bgcolor;
  final Color color;
  final bool shadow;
  final VoidCallback onPressed;
  const ButtonElevated({
    Key? key,
    required this.title,
    this.color = AppColors.textPrimary,
    this.bgcolor = AppColors.primary,
    this.size = 15,
    this.radius = 0,
    required this.onPressed,
    this.width = 100,
    this.height = 50,
    this.margin = const EdgeInsets.only(
      top: 5,
      bottom: 5,
    ),
    this.shadow = true,
    this.selected = false,
    this.disabled = false,
    this.showIcon = 'none',
    this.iconOnly = false,
    this.iconLeft = const Icon(FlutterRemix.user_line),
    this.iconRight = const Icon(FlutterRemix.user_line),
    this.justify = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bgcolor = disabled ? bgcolor.withAlpha(200) : bgcolor;
    var _color = disabled ? color.withAlpha(200) : color;
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (shadow && !disabled)
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                offset: Offset(0, 3),
                blurRadius: 3)
        ],
      ),
      child: ElevatedButton(
        onPressed: disabled ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          onPrimary: _color,
          elevation: 0,
          shadowColor: Colors.transparent,
          primary: _bgcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: selected
            ? const Icon(
                FlutterRemix.checkbox_circle_fill,
                color: Color(0xFF12A9DD),
                size: 20,
              )
            : iconOnly
                ? iconLeft
                : Row(
                    mainAxisAlignment: justify
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if (showIcon == 'left' || showIcon == 'both')
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 5,
                          ),
                          child: iconLeft,
                        ),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.button!.copyWith(
                              color: color,
                              fontSize: size,
                            ),
                      ),
                      if (showIcon == 'right' || showIcon == 'both')
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: iconRight,
                        ),
                    ],
                  ),
      ),
    );
  }
}
