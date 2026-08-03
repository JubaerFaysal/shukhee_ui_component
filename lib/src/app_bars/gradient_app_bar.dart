import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a gradient capable app bar.
  ///
  /// The [height] must be greater than or equal to zero.
  const GradientAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.leading,
    this.showBackButton = false,
    this.backButtonTooltip,
    this.actions,
    this.backgroundColor,
    this.gradient,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.centerTitle,
    this.bottom,
    this.height = kToolbarHeight,
    this.shape,
  }) : assert(height >= 0, 'height must be greater than or equal to zero.');

  /// Text rendered as the title.
  ///
  /// Ignored when [titleWidget] is provided.
  final String? title;

  /// Widget rendered as the title.
  ///
  /// Takes priority over [title].
  final Widget? titleWidget;

  /// Style applied to [title].
  ///
  /// Defaults to [AppBarTheme.titleTextStyle], falling back to the ambient
  /// [TextTheme]. It is also applied as the default text style of
  /// [titleWidget].
  final TextStyle? titleStyle;

  /// Widget displayed before the title.
  ///
  /// Takes priority over [showBackButton].
  final Widget? leading;

  /// Whether to show a back button that calls [Navigator.pop] when tapped.
  ///
  /// Ignored when [leading] is provided. No leading widget is implied when both
  /// are omitted.
  final bool showBackButton;

  /// Tooltip of the button rendered by [showBackButton].
  ///
  /// Defaults to [MaterialLocalizations.backButtonTooltip].
  final String? backButtonTooltip;

  /// Widgets displayed after the title.
  final List<Widget>? actions;

  /// Solid background color of the app bar.
  ///
  /// Ignored when [gradient] is provided. Defaults to
  /// [AppBarTheme.backgroundColor].
  final Color? backgroundColor;

  /// Gradient painted behind the whole app bar, including [bottom].
  ///
  /// Takes priority over [backgroundColor].
  final Gradient? gradient;

  /// Default color for the title, icons and actions.
  ///
  /// Defaults to [AppBarTheme.foregroundColor].
  final Color? foregroundColor;

  /// Icon theme applied to [leading] and the back button.
  final IconThemeData? iconTheme;

  /// Icon theme applied to [actions].
  final IconThemeData? actionsIconTheme;

  /// Z-coordinate at which to place the app bar.
  ///
  /// Defaults to [AppBarTheme.elevation].
  final double? elevation;

  /// Color of the shadow cast below the app bar.
  final Color? shadowColor;

  /// Surface tint overlay color used by Material 3 elevation.
  ///
  /// Defaults to [Colors.transparent] when a [gradient] is provided, so the
  /// tint does not wash out the gradient.
  final Color? surfaceTintColor;

  /// Whether the title should be centered.
  ///
  /// Defaults to [AppBarTheme.centerTitle], which is platform dependent.
  final bool? centerTitle;

  /// Widget displayed at the bottom of the app bar, typically a [TabBar].
  ///
  /// Its height is included in [preferredSize].
  final PreferredSizeWidget? bottom;

  /// Height of the toolbar, excluding [bottom].
  ///
  /// Defaults to [kToolbarHeight].
  final double height;

  /// Shape of the app bar's material, and of the [gradient] painted behind it.
  final ShapeBorder? shape;

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final bool hasGradient = gradient != null;

    return AppBar(
      title: _buildTitle(),
      titleTextStyle: titleStyle,
      leading: _buildLeading(context),
      automaticallyImplyLeading: false,
      actions: actions,
      // The gradient is painted by [flexibleSpace], so the material behind it
      // must not paint a competing color.
      backgroundColor: hasGradient ? Colors.transparent : backgroundColor,
      flexibleSpace: _buildGradientBackground(),
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: hasGradient
          ? (surfaceTintColor ?? Colors.transparent)
          : surfaceTintColor,
      centerTitle: centerTitle,
      bottom: bottom,
      toolbarHeight: height,
      shape: shape,
    );
  }

  Widget? _buildTitle() {
    if (titleWidget != null) {
      return titleWidget;
    }
    if (title != null) {
      return Text(title!);
    }
    return null;
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }
    if (!showBackButton) {
      return null;
    }
    return IconButton(
      icon: const BackButtonIcon(),
      tooltip:
          backButtonTooltip ??
          MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Widget? _buildGradientBackground() {
    if (gradient == null) {
      return null;
    }
    // [AppBar] stacks [flexibleSpace] with [StackFit.passthrough] and the
    // [Scaffold] hands it loose height constraints, so a childless
    // [DecoratedBox] would collapse to zero height and paint nothing. The
    // expansion makes it fill the whole app bar, status bar padding included.
    final Widget background = SizedBox.expand(
      child: DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
    );
    // [AppBar]'s material does not clip [flexibleSpace], so the gradient is
    // clipped here to keep it inside a custom [shape].
    if (shape == null) {
      return background;
    }
    return ClipPath(
      clipper: ShapeBorderClipper(shape: shape!),
      child: background,
    );
  }
}
