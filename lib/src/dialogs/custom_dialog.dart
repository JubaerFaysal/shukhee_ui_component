import 'package:flutter/material.dart';

import '../buttons/custom_button.dart';
import '../theme/ui_tokens.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.positiveAction,
    required this.infoText,
    this.negativeAction,
    this.positiveText,
    this.negativeText,
    this.title,
    this.canClose,
    this.icon,
    this.body,
    this.showNegativeButton = true,
    this.isPositiveButtonLoading = false,
    this.isPositiveButtonEnabled = true,
    this.scrollable = false,
    this.accentColor,
    this.backgroundColor,
    this.borderRadius = defaultRadius,
    this.elevation,
    this.padding,
    this.insetPadding,
    this.titleStyle,
    this.infoTextStyle,
    this.positiveButtonColor,
    this.positiveButtonTextColor,
    this.positiveButtonTextStyle,
    this.negativeButtonColor,
    this.negativeButtonTextColor,
    this.negativeButtonTextStyle,
    this.buttonBorderColor,
    this.buttonBorderRadius = UiTokens.defaultRadius,
    this.buttonPadding,
    this.buttonHeight = 48,
    this.spaceBetweenButtons = 8,
    this.spaceUnderIcon = 15,
    this.spaceUnderTitle = 15,
    this.spaceUnderInfoText = 24,
    this.spaceUnderBody = 20,
  }) : assert(borderRadius >= 0, 'borderRadius must not be negative.'),
       assert(
         elevation == null || elevation >= 0,
         'elevation must not be negative.',
       ),
       assert(
         buttonBorderRadius >= 0,
         'buttonBorderRadius must not be negative.',
       ),
       assert(buttonHeight >= 0, 'buttonHeight must not be negative.'),
       assert(
         spaceBetweenButtons >= 0,
         'spaceBetweenButtons must not be negative.',
       ),
       assert(spaceUnderIcon >= 0, 'spaceUnderIcon must not be negative.'),
       assert(spaceUnderTitle >= 0, 'spaceUnderTitle must not be negative.'),
       assert(
         spaceUnderInfoText >= 0,
         'spaceUnderInfoText must not be negative.',
       ),
       assert(spaceUnderBody >= 0, 'spaceUnderBody must not be negative.');

  static const double defaultRadius = 20;
  static const String defaultTitle = 'Alert';
  static const String defaultPositiveText = 'Proceed';
  static const String defaultNegativeText = 'Cancel';

  final VoidCallback positiveAction;
  final String infoText;
  final VoidCallback? negativeAction;
  final String? positiveText;
  final String? negativeText;
  final String? title;
  final bool? canClose;
  final Widget? icon;
  final Widget? body;
  final bool showNegativeButton;
  final bool isPositiveButtonLoading;
  final bool isPositiveButtonEnabled;
  final bool scrollable;
  final Color? accentColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsets? insetPadding;
  final TextStyle? titleStyle;
  final TextStyle? infoTextStyle;
  final Color? positiveButtonColor;
  final Color? positiveButtonTextColor;
  final TextStyle? positiveButtonTextStyle;
  final Color? negativeButtonColor;
  final Color? negativeButtonTextColor;
  final TextStyle? negativeButtonTextStyle;
  final Color? buttonBorderColor;
  final double buttonBorderRadius;
  final EdgeInsetsGeometry? buttonPadding;
  final double buttonHeight;
  final double spaceBetweenButtons;
  final double spaceUnderIcon;
  final double spaceUnderTitle;
  final double spaceUnderInfoText;
  final double spaceUnderBody;

  Future<T?> show<T>(
    BuildContext context, {
    bool? barrierDismissible,
    Color? barrierColor,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible ?? canClose ?? false,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (BuildContext _) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = accentColor ?? UiTokens.accentColor;
    final Color surface =
        backgroundColor ??
        theme.dialogTheme.backgroundColor ??
        theme.colorScheme.surface;
    final BorderRadius corners = BorderRadius.circular(borderRadius);

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (icon != null) ...<Widget>[icon!, SizedBox(height: spaceUnderIcon)],
        Text(
          title ?? defaultTitle,
          style:
              titleStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: accent,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spaceUnderTitle),
        Text(
          infoText,
          style: infoTextStyle ?? theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spaceUnderInfoText),
        if (body != null) ...<Widget>[body!, SizedBox(height: spaceUnderBody)],
        _buildButtons(context, theme, accent, surface),
      ],
    );

    return PopScope(
      canPop: canClose ?? false,
      child: Dialog(
        backgroundColor: surface,
        elevation: elevation,
        insetPadding:
            insetPadding ??
            const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: corners),
        // The container paints the same corners, so a body that fills the
        // dialog cannot square them off.
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(color: surface, borderRadius: corners),
          child: scrollable ? SingleChildScrollView(child: content) : content,
        ),
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context,
    ThemeData theme,
    Color accent,
    Color surface,
  ) {
    final Color positiveTextColor =
        positiveButtonTextColor ?? theme.colorScheme.onPrimary;
    final Color negativeTextColor = negativeButtonTextColor ?? accent;
    final Color borderColor = buttonBorderColor ?? accent;
    final EdgeInsetsGeometry labelPadding =
        buttonPadding ?? const EdgeInsets.all(8);
    final TextStyle? labelStyle = theme.textTheme.bodySmall;

    final Widget positiveButton = CustomButton(
      onTap: positiveAction,
      isEnabled: isPositiveButtonEnabled,
      isLoading: isPositiveButtonLoading,
      backgroundColor: positiveButtonColor ?? accent,
      foregroundColor: positiveTextColor,
      borderColor: borderColor,
      radius: buttonBorderRadius,
      padding: labelPadding,
      height: buttonHeight,
      elevation: 0,
      centerWidget: Text(
        positiveText ?? defaultPositiveText,
        style:
            positiveButtonTextStyle ??
            labelStyle?.copyWith(color: positiveTextColor),
        textAlign: TextAlign.center,
      ),
    );

    if (!showNegativeButton) {
      return positiveButton;
    }

    return Row(
      spacing: spaceBetweenButtons,
      children: <Widget>[
        Expanded(
          child: CustomButton(
            onTap: negativeAction ?? () => Navigator.of(context).pop(),
            backgroundColor: negativeButtonColor ?? surface,
            foregroundColor: negativeTextColor,
            borderColor: borderColor,
            radius: buttonBorderRadius,
            padding: labelPadding,
            height: buttonHeight,
            elevation: 0,
            centerWidget: Text(
              negativeText ?? defaultNegativeText,
              style:
                  negativeButtonTextStyle ??
                  labelStyle?.copyWith(color: negativeTextColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(child: positiveButton),
      ],
    );
  }
}
