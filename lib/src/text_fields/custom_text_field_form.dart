import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/ui_tokens.dart';

class CustomTextFieldForm extends StatelessWidget {
  const CustomTextFieldForm({
    super.key,
    this.textController,
    this.initialValue,
    this.focusNode,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.errorTextStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.hideText = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.maxLength,
    this.showCounter = true,
    this.minLines,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly,
    this.autofocus = false,
    this.onTap,
    this.onChange,
    this.onSubmitted,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderWidth = 1,
    this.borderRadius = defaultRadius,
    this.isDense = false,
    this.contentPadding,
    this.cursorColor,
    this.cursorWidth = 2,
    this.cursorHeight,
    this.unfocusOnTapOutside = true,
  }) : assert(
         textController == null || initialValue == null,
         'Pass either textController or initialValue, not both.',
       ),
       assert(
         !hideText || maxLines == 1,
         'An obscured field must be single-line, so maxLines must be 1.',
       ),
       assert(
         borderWidth >= 0,
         'borderWidth must be greater than or equal to zero.',
       ),
       assert(
         borderRadius >= 0,
         'borderRadius must be greater than or equal to zero.',
       );

  static const double defaultRadius = UiTokens.defaultRadius;

  final TextEditingController? textController;

  final String? initialValue;

  final FocusNode? focusNode;

  final String? labelText;

  final TextStyle? labelStyle;

  final String? hintText;

  final TextStyle? hintStyle;

  final TextStyle? errorTextStyle;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final TextInputType? inputType;

  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final List<TextInputFormatter>? inputFormatters;

  final TextStyle? textStyle;

  final TextAlign textAlign;

  final bool hideText;

  final String? Function(String?)? validator;

  final AutovalidateMode autovalidateMode;

  final int? maxLength;

  final bool showCounter;

  final int? minLines;

  final int? maxLines;

  final bool enabled;

  final bool? readOnly;

  final bool autofocus;

  final VoidCallback? onTap;

  final ValueChanged<String>? onChange;

  final ValueChanged<String>? onSubmitted;

  final Color? backgroundColor;

  final Color? borderColor;

  final Color? focusedBorderColor;

  final Color? errorBorderColor;

  final Color? disabledBorderColor;

  final double borderWidth;

  final double borderRadius;

  final bool isDense;

  final EdgeInsetsGeometry? contentPadding;

  final Color? cursorColor;

  final double cursorWidth;

  final double? cursorHeight;

  final bool unfocusOnTapOutside;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color errorColor = errorBorderColor ?? theme.colorScheme.error;

    OutlineInputBorder borderOf(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: borderWidth),
    );
    final OutlineInputBorder enabledBorder = borderOf(
      borderColor ?? theme.colorScheme.outline,
    );
    final OutlineInputBorder errorBorder = borderOf(errorColor);

    return TextFormField(
      controller: textController,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly ?? (onTap != null),
      autofocus: autofocus,
      onTap: onTap,
      onChanged: onChange,
      onFieldSubmitted: onSubmitted,
      onTapOutside: unfocusOnTapOutside
          ? (_) => FocusManager.instance.primaryFocus?.unfocus()
          : null,
      validator: validator,
      autovalidateMode: autovalidateMode,
      keyboardType: inputType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: textStyle ?? theme.textTheme.bodyMedium,
      textAlign: textAlign,
      obscureText: hideText,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: cursorColor,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            labelStyle ??
            theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        alignLabelWithHint: true,
        hintText: hintText,
        hintStyle:
            hintStyle ??
            theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        errorStyle:
            errorTextStyle ??
            theme.textTheme.labelLarge?.copyWith(color: errorColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: isDense,
        contentPadding: contentPadding,
        filled: backgroundColor != null,
        fillColor: backgroundColor,
        // An empty string removes the counter without removing maxLength.
        counterText: showCounter ? null : '',
        border: enabledBorder,
        enabledBorder: enabledBorder,
        focusedBorder: borderOf(focusedBorderColor ?? UiTokens.accentColor),
        disabledBorder: borderOf(disabledBorderColor ?? theme.disabledColor),
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
