import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  /// Creates a button.
  ///
  /// The [height], [radius], [elevation] and [spacing] must be greater than or
  /// equal to zero.
  const CustomButton({
    super.key,
    required this.onTap,
    this.centerWidget,
    this.prefixWidget,
    this.suffixWidget,
    this.width,
    this.height = 56,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.radius = 12,
    this.borderColor,
    this.borderWidth,
    this.elevation = 2,
    this.margin,
    this.padding,
    this.contentAlignment = MainAxisAlignment.center,
    this.spacing = 8,
    this.splashColor,
    this.highlightColor,
    this.isLoading = false,
    this.isEnabled = true,
    this.loadingWidget,
    this.loadingBackgroundColor,
    this.loadingForegroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
  }) : assert(height >= 0, 'height must be greater than or equal to zero.'),
       assert(radius >= 0, 'radius must be greater than or equal to zero.'),
       assert(
         elevation >= 0,
         'elevation must be greater than or equal to zero.',
       ),
       assert(spacing >= 0, 'spacing must be greater than or equal to zero.');

  /// Called when the button is tapped.
  ///
  /// Passing `null` disables the button, exactly like [isEnabled] being
  /// `false`.
  final VoidCallback? onTap;

  /// Widget rendered between [prefixWidget] and [suffixWidget], typically the
  /// label.
  final Widget? centerWidget;

  /// Widget rendered before [centerWidget].
  final Widget? prefixWidget;

  /// Widget rendered after [centerWidget].
  final Widget? suffixWidget;

  /// Width of the button.
  ///
  /// Defaults to filling the available width. Give an explicit width, or wrap
  /// the button in an [Expanded], when the parent does not bound its width —
  /// inside a [Row], for instance.
  final double? width;

  /// Height of the button. Defaults to `56`.
  final double height;

  /// Background color while the button is enabled.
  ///
  /// Defaults to [ColorScheme.primary], and stays in place while the button is
  /// loading unless [loadingBackgroundColor] is given. While disabled
  /// [disabledBackgroundColor] is used instead.
  final Color? backgroundColor;

  /// Default color for the text and icons in the content slots.
  ///
  /// Defaults to [ColorScheme.onPrimary], and stays in place while the button
  /// is loading unless [loadingForegroundColor] is given. While disabled
  /// [disabledForegroundColor] is used instead.
  final Color? foregroundColor;

  /// Style applied to the text in the content slots.
  ///
  /// Defaults to [TextTheme.labelLarge]. A color set here wins over
  /// [foregroundColor], except while the button is disabled or loading, where
  /// the state's own foreground color applies.
  final TextStyle? textStyle;

  /// Corner radius of the button. Defaults to `12`.
  final double radius;

  /// Color of the border.
  ///
  /// No border is drawn unless [borderColor] or [borderWidth] is given.
  final Color? borderColor;

  /// Width of the border. Defaults to `1` when a border is drawn.
  final double? borderWidth;

  /// Z-coordinate at which to place the button. Defaults to `2`, and drops to
  /// zero while the button is disabled.
  final double elevation;

  /// Space around the outside of the button.
  final EdgeInsetsGeometry? margin;

  /// Space between the border and the content slots.
  ///
  /// Defaults to 16 logical pixels horizontally and 8 vertically.
  final EdgeInsetsGeometry? padding;

  /// How the content slots are distributed along the button.
  ///
  /// Defaults to [MainAxisAlignment.center]. Use
  /// [MainAxisAlignment.spaceBetween] to pin the prefix and suffix to the
  /// edges.
  final MainAxisAlignment contentAlignment;

  /// Gap inserted between adjacent content slots. Defaults to `8`.
  final double spacing;

  /// Splash color of the ink response.
  final Color? splashColor;

  /// Highlight color of the ink response.
  final Color? highlightColor;

  /// Whether to replace the content with a progress indicator.
  ///
  /// The button is disabled while this is `true`.
  final bool isLoading;

  /// Whether the button responds to taps.
  final bool isEnabled;

  /// Widget rendered in place of the content while [isLoading] is `true`.
  ///
  /// Defaults to a centred [CircularProgressIndicator] tinted with the
  /// resolved foreground color.
  final Widget? loadingWidget;

  /// Background color while [isLoading] is `true`.
  ///
  /// Defaults to [backgroundColor], so the button keeps its colour while it
  /// works. Ignored while [isEnabled] is `false` or [onTap] is `null`, which
  /// always paint as disabled.
  final Color? loadingBackgroundColor;

  /// Color of the progress indicator, and of the text and icons in
  /// [loadingWidget], while [isLoading] is `true`.
  ///
  /// Defaults to [foregroundColor]. Ignored while [isEnabled] is `false` or
  /// [onTap] is `null`.
  final Color? loadingForegroundColor;

  /// Background color while the button is disabled.
  ///
  /// Defaults to [ColorScheme.onSurface] at 12% opacity, the Material disabled
  /// container color.
  final Color? disabledBackgroundColor;

  /// Color for the text and icons in the content slots while the button is
  /// disabled.
  ///
  /// Defaults to [ColorScheme.onSurface] at 38% opacity, the Material disabled
  /// content color.
  final Color? disabledForegroundColor;

  /// Whether the button currently responds to taps.
  ///
  /// Loading suppresses taps without changing how the button looks; use
  /// [_showsDisabledColors] for the visual state.
  bool get _isInteractive => isEnabled && !isLoading && onTap != null;

  /// Whether the button paints itself with the disabled colors.
  bool get _showsDisabledColors => !isEnabled || onTap == null;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final bool interactive = _isInteractive;
    final bool disabled = _showsDisabledColors;

    // Loading suppresses taps but keeps the button's own colors, so only a
    // genuinely disabled button drops to the disabled palette.
    final Color effectiveBackground = disabled
        ? (disabledBackgroundColor ?? colors.onSurface.withValues(alpha: 0.12))
        : (isLoading ? loadingBackgroundColor : null) ??
              backgroundColor ??
              colors.primary;
    final Color effectiveForeground = disabled
        ? (disabledForegroundColor ?? colors.onSurface.withValues(alpha: 0.38))
        : (isLoading ? loadingForegroundColor : null) ??
              foregroundColor ??
              colors.onPrimary;

    final BorderRadius borderRadius = BorderRadius.circular(radius);
    final bool hasBorder = borderColor != null || borderWidth != null;

    // The size wraps the material rather than sitting inside it, so the whole
    // button — border and elevation included — is the requested size.
    Widget button = SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: effectiveBackground,
        elevation: disabled ? 0 : elevation,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: hasBorder
              ? BorderSide(
                  color: disabled
                      ? colors.onSurface.withValues(alpha: 0.12)
                      : (borderColor ?? colors.primary),
                  width: borderWidth ?? 1,
                )
              : BorderSide.none,
        ),
        // Keeps the ink splash inside the rounded corners.
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: interactive ? onTap : null,
          splashColor: splashColor,
          highlightColor: highlightColor,
          borderRadius: borderRadius,
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildContent(theme, effectiveForeground),
          ),
        ),
      ),
    );

    if (margin != null) {
      button = Padding(padding: margin!, child: button);
    }

    // InkWell only reports button semantics while it is tappable, so the
    // disabled state is announced here instead.
    return Semantics(button: true, enabled: interactive, child: button);
  }

  Widget _buildContent(ThemeData theme, Color foreground) {
    final TextStyle baseStyle =
        (theme.textTheme.labelLarge ?? const TextStyle()).merge(textStyle);
    // [TextTheme.labelLarge] already carries a color, so only a color the
    // caller set on [textStyle] counts as explicit. The disabled state, and a
    // loading state with its own foreground, resolve their color instead.
    final Color? explicitColor =
        _showsDisabledColors || (isLoading && loadingForegroundColor != null)
        ? null
        : textStyle?.color;

    return IconTheme.merge(
      data: IconThemeData(color: foreground),
      child: DefaultTextStyle.merge(
        style: baseStyle.copyWith(color: explicitColor ?? foreground),
        child: isLoading
            ? (loadingWidget ?? _buildLoader(foreground))
            : Row(
                mainAxisAlignment: contentAlignment,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildSlots(),
              ),
      ),
    );
  }

  /// Returns the non-null content slots, separated by [spacing].
  List<Widget> _buildSlots() {
    final List<Widget> slots = <Widget>[
      if (prefixWidget != null) prefixWidget!,
      if (centerWidget != null) centerWidget!,
      if (suffixWidget != null) suffixWidget!,
    ];
    if (slots.length < 2 || spacing == 0) {
      return slots;
    }
    return <Widget>[
      for (int i = 0; i < slots.length; i++) ...<Widget>[
        if (i > 0) SizedBox(width: spacing),
        slots[i],
      ],
    ];
  }

  Widget _buildLoader(Color foreground) {
    return Center(
      child: SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      ),
    );
  }
}
