import 'package:flutter/material.dart';

class PriceViewWidget extends StatelessWidget {
  /// Creates a price line.
  ///
  /// The [spacing] and [suffixSpacing] must be greater than or equal to zero,
  /// and [maxLines] must be greater than zero.
  const PriceViewWidget({
    super.key,
    required this.price,
    required this.priceTextStyle,
    this.currencySymbol = defaultCurrencySymbol,
    this.currencyTextStyle,
    this.prefixText,
    this.prefixTextStyle,
    this.suffixText,
    this.suffixTextStyle,
    this.strikeThrough = false,
    this.strikeThroughColor,
    this.spacing = 2,
    this.suffixSpacing = 5,
    this.textAlign,
    this.maxLines = 1,
    this.overflow = TextOverflow.clip,
    this.formatter,
  }) : assert(spacing >= 0, 'spacing must be greater than or equal to zero.'),
       assert(
         suffixSpacing >= 0,
         'suffixSpacing must be greater than or equal to zero.',
       ),
       assert(maxLines > 0, 'maxLines must be greater than zero.');

  /// The Bangladeshi taka sign, used when no [currencySymbol] is given.
  static const String defaultCurrencySymbol = '৳';

  /// The amount, as it should read before [formatter] is applied.
  final String price;

  /// Style of the amount, and the fallback style of every other part.
  final TextStyle priceTextStyle;

  /// Symbol rendered before the amount.
  ///
  /// Defaults to [defaultCurrencySymbol]. Pass `null` or an empty string to
  /// render the amount on its own.
  final String? currencySymbol;

  /// Style of [currencySymbol]. Defaults to [priceTextStyle].
  final TextStyle? currencyTextStyle;

  /// Text rendered before the currency symbol, typically the original price.
  ///
  /// [formatter] applies to it, since it is usually an amount too.
  final String? prefixText;

  /// Style of [prefixText]. Defaults to [priceTextStyle].
  ///
  /// [strikeThrough] does not reach this part — set the decoration here to
  /// strike an original price.
  final TextStyle? prefixTextStyle;

  /// Text rendered after the amount, typically a unit such as `/kg`.
  ///
  /// [formatter] does not apply to it.
  final String? suffixText;

  /// Style of [suffixText]. Defaults to [priceTextStyle].
  final TextStyle? suffixTextStyle;

  /// Whether to strike through the currency symbol and the amount.
  ///
  /// [prefixText] and [suffixText] keep their own decoration.
  final bool strikeThrough;

  /// Color of the strike-through line. Defaults to the text color.
  final Color? strikeThroughColor;

  /// Gap between the prefix, the currency symbol and the amount.
  /// Defaults to `2`.
  final double spacing;

  /// Gap before [suffixText]. Defaults to `5`.
  final double suffixSpacing;

  /// How the line is aligned horizontally. Defaults to [TextAlign.start].
  final TextAlign? textAlign;

  /// Maximum number of lines. Defaults to `1`.
  final int maxLines;

  /// How text that overflows [maxLines] is handled.
  /// Defaults to [TextOverflow.clip].
  final TextOverflow overflow;

  /// Transforms [price] and [prefixText] before they are rendered.
  ///
  /// Use it to localise digits or to group thousands. The widget itself never
  /// reformats the values, and a `null` result leaves the value as it was, so
  /// an app-side converter can be passed straight in:
  ///
  /// ```dart
  /// formatter: AppServices.convertToBanglaFormatter,
  /// ```
  ///
  /// The nullable parameter and return type make the widget accept converters
  /// declared as `String? Function(String?)`, which is the common shape.
  final String? Function(String value)? formatter;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: _buildSpans()),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Returns the spans for the parts that have content, gap-separated.
  List<InlineSpan> _buildSpans() {
    final List<InlineSpan> spans = <InlineSpan>[];

    void add(String? text, TextStyle style, double gapBefore) {
      if (text == null || text.isEmpty) {
        return;
      }
      if (spans.isNotEmpty && gapBefore > 0) {
        spans.add(WidgetSpan(child: SizedBox(width: gapBefore)));
      }
      spans.add(TextSpan(text: text, style: style));
    }

    add(_format(prefixText), prefixTextStyle ?? priceTextStyle, 0);
    add(currencySymbol, _struck(currencyTextStyle ?? priceTextStyle), spacing);
    add(_format(price), _struck(priceTextStyle), spacing);
    add(suffixText, suffixTextStyle ?? priceTextStyle, suffixSpacing);

    return spans;
  }

  String? _format(String? value) {
    if (value == null || value.isEmpty) {
      return value;
    }
    return formatter?.call(value) ?? value;
  }

  /// Applies the strike-through, leaving any decoration in [style] untouched
  /// when [strikeThrough] is `false`.
  TextStyle _struck(TextStyle style) {
    if (!strikeThrough) {
      return style;
    }
    return style.copyWith(
      decoration: TextDecoration.lineThrough,
      decorationColor: strikeThroughColor,
    );
  }
}
