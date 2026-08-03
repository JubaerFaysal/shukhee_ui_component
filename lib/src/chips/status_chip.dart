import 'package:flutter/material.dart';

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

  /// The brand color, used when no [color] is given.
  static const Color defaultColor = Color(0xFF00AAD0);

  /// The corner radius used when no [radius] is given.
  static const double defaultRadius = 4;

  /// The label.
  ///
  /// [placeholder] is rendered when this is `null` or empty.
  final String? status;

  /// Rendered in place of a missing [status]. Defaults to `'N/A'`.
  final String placeholder;

  /// Accent color of the chip.
  ///
  /// Colors the label and the border, and the background at
  /// [backgroundOpacity]. Defaults to [defaultColor]. Use [backgroundColor] or
  /// [borderColor] to override a single surface.
  final Color color;

  /// Background color of the chip.
  ///
  /// Defaults to [color] at [backgroundOpacity].
  final Color? backgroundColor;

  /// Opacity of [color] when it is used as the background.
  /// Defaults to `0.2`.
  ///
  /// Ignored when [backgroundColor] is given.
  final double backgroundOpacity;

  /// Color of the border. Defaults to [color] at full strength.
  final Color? borderColor;

  /// Width of the border. Defaults to `0.5`; zero draws no border.
  final double borderWidth;

  /// Corner radius of the chip. Defaults to [defaultRadius].
  final double radius;

  /// Space between the border and the label.
  ///
  /// Defaults to 8 logical pixels horizontally and 4 vertically.
  final EdgeInsetsGeometry? padding;

  /// Style of the label.
  ///
  /// Merged over [TextTheme.labelLarge] in semi-bold, so setting only a size
  /// or a weight keeps [color] as the label color.
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
