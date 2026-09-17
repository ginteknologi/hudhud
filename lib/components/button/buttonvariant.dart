import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import '../../theme.dart';

class ButtonVariant extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final double border;
  final double radius;
  final bool isSelected;
  final EdgeInsetsGeometry margin;
  final Color bgcolor;
  final Color color;
  final bool shadow;
  final bool isInverted;
  final bool isDisabled;
  final bool isLoading;
  final bool isChild;
  final bool hasTooltip;
  final String textTooltip;
  final VoidCallback onPressed;
  final textStyle;
  final Widget child;
  const ButtonVariant({
    super.key,
    this.label = 'Label',
    this.color = AppColors.appPrimary,
    this.bgcolor = AppColors.textPrimary,
    this.border = 1,
    this.radius = 0,
    required this.onPressed,
    this.child = const Text(''),
    this.width = 100,
    this.height = 50,
    this.margin = const EdgeInsets.only(
      top: 5,
      bottom: 5,
    ),
    this.shadow = true,
    this.isInverted = false,
    this.isSelected = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.isChild = false,
    this.hasTooltip = false,
    this.textTooltip = '',
    // Text Config
    this.textStyle = "",
  });

  @override
  Widget build(BuildContext context) {
    var bgColor = isDisabled ? bgcolor.withValues(alpha: .5) : bgcolor;
    var fgColor = isDisabled ? color.withValues(alpha: .5) : color;
    var txtStyle =
        textStyle == "" ? Theme.of(context).textTheme.labelLarge : textStyle;
    txtStyle = txtStyle!.copyWith(color: isInverted ? bgColor : fgColor);
    var tooltipText = textTooltip.isEmpty ? label : textTooltip;
    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: isInverted ? bgColor : fgColor, padding: EdgeInsets.zero,
      backgroundColor: isInverted ? fgColor : bgColor,
      side: BorderSide(
          color: border > 0
              ? isInverted
                  ? bgColor
                  : fgColor
              : Colors.transparent,
          width: border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    final Widget buttonChild = isSelected
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              FlutterRemix.checkbox_circle_fill,
              color: Color(0xFF12A9DD),
              size: 20,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: isInverted ? bgColor : fgColor,
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  )
                : isChild
                    ? child
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: txtStyle,
                          ),
                        ],
                      ),
          );
    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        color: isDisabled || isLoading
            ? isInverted
                ? fgColor
                : bgColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: isDisabled || isLoading
                ? border > 0
                    ? isInverted
                        ? bgColor
                        : fgColor
                    : Colors.transparent
                : Colors.transparent,
            width: border),
        boxShadow: [
          if (shadow && !isDisabled)
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                offset: Offset(0, 3),
                blurRadius: 3)
        ],
      ),
      child: isDisabled || isLoading
          ? buttonChild
          : hasTooltip
              ? Tooltip(
                  message: tooltipText,
                  child: OutlinedButton(
                    onPressed: isDisabled ? () {} : onPressed,
                    style: buttonStyle,
                    child: buttonChild,
                  ),
                )
              : OutlinedButton(
                  onPressed: isDisabled ? () {} : onPressed,
                  style: buttonStyle,
                  child: buttonChild,
                ),
    );
  }
}
