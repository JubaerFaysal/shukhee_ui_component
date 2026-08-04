import 'package:flutter/material.dart';

import '../theme/ui_tokens.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    this.status,
    this.placeholder = 'N/A',
    this.color = defaultColor,
    this.backgroundColor,
    this.backgroundOpacity = 0.2,
    this.borderColor,
    this.borderWidth = 0.5,
    this.radius = defaultRadius,
    this.padding,
    this.textStyle,
  }) : assert(
         backgroundOpacity >= 0 && backgroundOpacity <= 1,
         'backgroundOpacity must be between zero and one.',
       ),
       assert(
         borderWidth >= 0,
         'borderWidth must be greater than or equal to zero.',
       ),
       assert(radius >= 0, 'radius must be greater than or equal to zero.');

  static const Color defaultColor = UiTokens.accentColor;
  static const double defaultRadius = UiTokens.defaultRadius;

  final String? status;
  final String placeholder;
  final Color color;
  final Color? backgroundColor;
  final double backgroundOpacity;
  final Color? borderColor;
  final double borderWidth;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String label = (status == null || status!.isEmpty)
        ? placeholder
        : status!;

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: backgroundOpacity),
        borderRadius: BorderRadius.circular(radius),
        border: borderWidth > 0
            ? Border.all(color: borderColor ?? color, width: borderWidth)
            : null,
      ),
      child: Text(
        label,
        style: (theme.textTheme.labelLarge ?? const TextStyle())
            .copyWith(color: color, fontWeight: FontWeight.w600)
            .merge(textStyle),
      ),
    );
  }
}
