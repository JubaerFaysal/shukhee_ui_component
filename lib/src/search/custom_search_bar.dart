import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/ui_tokens.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.textEditingController,
    this.initialValue,
    this.focusNode,
    this.onTextChanged,
    this.onSubmitted,
    this.onClear,
    this.onIconTap,
    this.hintTextStyle,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = defaultRadius,
    this.icon,
    this.iconColor,
    this.iconSize = 24,
    this.showClearButton = true,
    this.leading,
    this.height = 56,
    this.margin,
    this.contentPadding,
    this.spacing = 10,
    this.enabled = true,
    this.autoFocus = false,
    this.inputType,
    this.textInputAction = TextInputAction.search,
    this.inputFormatters,
    this.unfocusOnTapOutside = true,
  }) : assert(
         textEditingController == null || initialValue == null,
         'Pass either textEditingController or initialValue, not both.',
       ),
       assert(height == null || height >= 0, 'height must not be negative.'),
       assert(borderWidth >= 0, 'borderWidth must not be negative.'),
       assert(borderRadius >= 0, 'borderRadius must not be negative.'),
       assert(spacing >= 0, 'spacing must not be negative.');

  static const double defaultRadius = UiTokens.defaultRadius;

  final String hintText;

  final TextEditingController? textEditingController;

  final String? initialValue;

  final FocusNode? focusNode;

  final ValueChanged<String>? onTextChanged;

  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onClear;

  final VoidCallback? onIconTap;

  final TextStyle? hintTextStyle;

  final TextStyle? textStyle;

  final Color? backgroundColor;

  final Color? borderColor;

  final double borderWidth;

  final double borderRadius;

  final Widget? icon;

  final Color? iconColor;

  final double iconSize;

  final bool showClearButton;

  final Widget? leading;

  final double? height;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? contentPadding;

  final double spacing;

  final bool enabled;

  final bool autoFocus;

  final TextInputType? inputType;

  final TextInputAction textInputAction;

  final List<TextInputFormatter>? inputFormatters;

  final bool unfocusOnTapOutside;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Widget bar = Container(
      height: height,
      padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      child: Row(
        spacing: spacing,
        children: <Widget>[
          if (leading != null) ...<Widget>[leading!, SizedBox(width: spacing)],
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              initialValue: initialValue,
              focusNode: focusNode,
              enabled: enabled,
              autofocus: autoFocus,
              autocorrect: false,
              keyboardType: inputType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              style: textStyle ?? theme.textTheme.bodySmall,
              onChanged: onTextChanged,
              onFieldSubmitted: onSubmitted,
              onTapOutside: unfocusOnTapOutside
                  ? (_) => FocusManager.instance.primaryFocus?.unfocus()
                  : null,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle:
                    hintTextStyle ??
                    theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            ),
          ),
          _buildTrailing(theme),
        ],
      ),
    );

    if (margin != null) {
      bar = Padding(padding: margin!, child: bar);
    }
    return bar;
  }

  Widget _buildTrailing(ThemeData theme) {
    final Color color = iconColor ?? theme.hintColor;
    final Widget searchIcon =
        icon ?? Icon(Icons.search, size: iconSize, color: color);
    final Widget idle = onIconTap == null
        ? searchIcon
        : InkResponse(onTap: onIconTap, radius: iconSize, child: searchIcon);

    if (!showClearButton || textEditingController == null || !enabled) {
      return idle;
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: textEditingController!,
      child: idle,
      builder: (BuildContext context, TextEditingValue value, Widget? child) {
        if (value.text.isEmpty) {
          return child!;
        }
        return InkResponse(
          onTap: _clear,
          radius: iconSize,
          child: Icon(Icons.close, size: iconSize, color: color),
        );
      },
    );
  }

  void _clear() {
    textEditingController!.clear();
    onTextChanged?.call('');
    onClear?.call();
  }
}
