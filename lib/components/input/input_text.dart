import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InputText extends StatelessWidget {
  final String placeholder;
  final String label;
  final EdgeInsets margin;
  final EdgeInsets inputPadding;
  final bool isDense;
  final bool enabled;
  final bool multiText;
  final bool autofocus;
  final bool isPassword;
  final bool customErrorLayout;
  final bool showCounter;
  final bool enableBorder;
  final bool isFill;
  final bool hasErrorText;
  final int maxLength;
  final int maxLine;
  final double radius;
  final TextAlign textAlign;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextEditingController controller;
  final String labelPosition;
  final Color fillColor;
  final dynamic inputStyle;
  final dynamic labelStyle;
  final dynamic placeholderStyle;
  final void Function() onEditingComplete;
  final void Function(String newValue) onSubmit;
  final void Function(String newValue) onChanged;
  final String? Function(String? newValue) validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  const InputText({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.onEditingComplete,
    required this.onChanged,
    required this.validator,
    this.label = 'Label',
    this.placeholder = '',
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.enabled = true,
    this.isDense = false,
    this.customErrorLayout = false,
    this.inputPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    this.autofocus = false,
    this.enableBorder = true,
    this.textAlign = TextAlign.start,
    this.inputType = TextInputType.name,
    this.inputAction = TextInputAction.done,
    this.inputStyle = "",
    this.labelStyle = "",
    this.placeholderStyle = "",
    this.labelPosition = 'float',
    this.radius = 5,
    this.multiText = false,
    this.isPassword = false,
    this.showCounter = false,
    this.hasErrorText = false,
    this.maxLength = TextField.noMaxLength,
    this.maxLine = 3,
    this.isFill = false,
    this.fillColor = Colors.transparent,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final inputStyleVal =
        inputStyle == "" ? Theme.of(context).textTheme.bodySmall : inputStyle;
    final placeholderStyleVal = placeholderStyle == ""
        ? Theme.of(context).textTheme.bodySmall
        : placeholderStyle;
    final labelStyleVal =
        labelStyle == "" ? Theme.of(context).textTheme.titleMedium : labelStyle;
    var counterText = "".obs;
    final TextFormField textChild = TextFormField(
      textInputAction: inputAction,
      obscureText: isPassword,
      maxLength: maxLength,
      autofocus: autofocus,
      style: inputStyleVal,
      textAlign: textAlign,
      keyboardType: inputType,
      inputFormatters: <TextInputFormatter>[
        if (inputType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
        if (inputType == TextInputType.number)
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      maxLines: multiText
          ? maxLine == 0
              ? null
              : maxLine
          : 1,
      controller: controller,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: Colors.red)),
        errorStyle: hasErrorText
            ? inputStyleVal!.merge(const TextStyle(color: Colors.red))
            : const TextStyle(height: .01, color: Colors.transparent),
        filled: !enabled || isFill,
        fillColor: !enabled ? fillColor.withValues(alpha: .25) : fillColor,
        isDense: isDense,
        enabled: enabled,
        contentPadding: inputPadding,
        counterText: showCounter ? null : "",
        counterStyle: TextStyle(
            height: showCounter ? 1 : 0, fontSize: showCounter ? 12 : 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
              color: enableBorder
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: .1)
                  : Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: enableBorder
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent),
        ),
        floatingLabelBehavior: labelPosition == 'float'
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
        floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
        hintText: placeholder,
        hintStyle: placeholderStyleVal!
            .copyWith(color: placeholderStyleVal!.color!.withValues(alpha: .5)),
        labelText: labelPosition == 'float' ? label : null,
        labelStyle: labelStyleVal,
        // icon:,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      onChanged: showCounter
          ? (newValue) {
              counterText.value = controller.text;
            }
          : onChanged,
      onFieldSubmitted: onSubmit,
      onEditingComplete: onEditingComplete,
      validator: validator,
    );
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelPosition == 'outside' && label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                label,
                style: labelStyleVal!.copyWith(
                    color: !enabled
                        ? Colors.grey.withValues(alpha: .1)
                        : labelStyleVal!.color),
              ),
            ),
          textChild,
        ],
      ),
    );
  }
}
