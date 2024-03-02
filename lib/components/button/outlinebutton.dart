import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../../theme.dart';

class ButtonOutline extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final double size;
  final double border;
  final double radius;
  final bool selected;
  final String showIcon;
  final bool iconOnly;
  final iconLeft;
  final bool vertical;
  final iconRight;
  final double letterSpacing;
  final double textGap;
  final double textHeight;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry margin;
  final Color bgcolor;
  final Color color;
  final bool shadow;
  final bool inverted;
  final bool justify;
  final bool disabled;
  final VoidCallback onPressed;
  const ButtonOutline({
    Key? key,
    this.title = 'Label',
    this.color = AppColors.appPrimary,
    this.bgcolor = AppColors.textPrimary,
    this.size = 15,
    this.border = 1,
    this.textGap = 0,
    this.radius = 0,
    this.letterSpacing = 0,
    this.textAlign = TextAlign.left,
    required this.onPressed,
    this.width = 100,
    this.height = 50,
    this.textHeight = 1.5,
    this.fontWeight = FontWeight.normal,
    this.margin = const EdgeInsets.only(
      top: 5,
      bottom: 5,
    ),
    this.shadow = true,
    this.vertical = false,
    this.inverted = false,
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
    var _bgcolor = disabled ? bgcolor.withOpacity(.5) : bgcolor;
    var _color = disabled ? color.withOpacity(.5) : color;
    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: inverted ? _bgcolor : _color, padding: EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: inverted ? _color : _bgcolor,
      side: BorderSide(
          color: border > 0
              ? inverted
                  ? _bgcolor
                  : _color
              : Colors.transparent,
          width: border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    final Widget buttonChild = selected
        ? const Icon(
            FlutterRemix.checkbox_circle_fill,
            color: Color(0xFF12A9DD),
            size: 20,
          )
        : iconOnly
            ? iconLeft
            : vertical
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: justify
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if (showIcon == 'left' || showIcon == 'both')
                        Padding(
                          padding: EdgeInsets.only(
                            right: vertical ? 0 : 5,
                          ),
                          child: iconLeft,
                        ),
                      if (showIcon == 'left' || showIcon == 'both')
                        Container(height: textGap),
                      Text(
                        title,
                        textAlign: textAlign,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: inverted ? _bgcolor : _color,
                              fontSize: size,
                              letterSpacing: letterSpacing,
                              height: textHeight,
                              fontWeight: fontWeight,
                            ),
                      ),
                      if (showIcon == 'right' || showIcon == 'both')
                        Container(height: textGap),
                      if (showIcon == 'right' || showIcon == 'both')
                        Padding(
                          padding: EdgeInsets.only(
                            left: vertical ? 0 : 5,
                          ),
                          child: iconRight,
                        ),
                    ],
                  )
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
                      if (showIcon == 'left' || showIcon == 'both')
                        Container(width: textGap),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: inverted ? _bgcolor : _color,
                              fontSize: size,
                              letterSpacing: letterSpacing,
                              height: textHeight,
                              fontWeight: fontWeight,
                            ),
                      ),
                      if (showIcon == 'right' || showIcon == 'both')
                        Container(width: textGap),
                      if (showIcon == 'right' || showIcon == 'both')
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: iconRight,
                        ),
                    ],
                  );
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: disabled
            ? inverted
                ? _color
                : _bgcolor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: disabled
                ? border > 0
                    ? inverted
                        ? _bgcolor
                        : _color
                    : Colors.transparent
                : Colors.transparent,
            width: border),
        boxShadow: [
          if (shadow && !disabled)
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                offset: Offset(0, 3),
                blurRadius: 3)
        ],
      ),
      child: disabled
          ? buttonChild
          : OutlinedButton(
              onPressed: disabled ? () {} : onPressed,
              style: buttonStyle,
              child: buttonChild,
            ),
    );
  }
}
