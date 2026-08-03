import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  const TextStyle priceStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF111111),
  );

  /// Wraps [widget] in a minimal app.
  Widget wrap(PriceViewWidgets widget) {
    return MaterialApp(
      home: Scaffold(body: Center(child: widget)),
    );
  }

  /// Returns the rendered spans that carry text, in order.
  List<TextSpan> textSpansOf(WidgetTester tester) {
    final RichText richText = tester.widget<RichText>(find.byType(RichText));
    final List<TextSpan> spans = <TextSpan>[];
    richText.text.visitChildren((InlineSpan span) {
      if (span is TextSpan && (span.text?.isNotEmpty ?? false)) {
        spans.add(span);
      }
      return true;
    });
    return spans;
  }

  /// Returns the widths of the gap spans, in order.
  List<double> gapsOf(WidgetTester tester) {
    final RichText richText = tester.widget<RichText>(find.byType(RichText));
    final List<double> gaps = <double>[];
    richText.text.visitChildren((InlineSpan span) {
      if (span is WidgetSpan) {
        gaps.add((span.child as SizedBox).width!);
      }
      return true;
    });
    return gaps;
  }

  group('content', () {
    testWidgets('renders the currency symbol and the amount', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const PriceViewWidgets(price: '1250', priceTextStyle: priceStyle)),
      );

      expect(textSpansOf(tester).map((TextSpan s) => s.text).toList(), <String>[
        PriceViewWidgets.defaultCurrencySymbol,
        '1250',
      ]);
    });

    testWidgets('renders every part in order', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            currencySymbol: r'$',
            prefixText: '1500',
            suffixText: '/kg',
          ),
        ),
      );

      expect(textSpansOf(tester).map((TextSpan s) => s.text).toList(), <String>[
        '1500',
        r'$',
        '1250',
        '/kg',
      ]);
    });

    testWidgets('omits the currency symbol when it is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            currencySymbol: null,
          ),
        ),
      );

      expect(textSpansOf(tester).map((TextSpan s) => s.text).toList(), <String>[
        '1250',
      ]);
    });
  });

  group('spacing', () {
    testWidgets('inserts no gaps when only the amount is rendered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            currencySymbol: null,
          ),
        ),
      );

      expect(gapsOf(tester), isEmpty);
    });

    testWidgets('inserts a gap only between neighbouring parts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            spacing: 4,
            suffixSpacing: 9,
          ),
        ),
      );

      // Symbol then amount: one gap, and none before the absent prefix.
      expect(gapsOf(tester), <double>[4]);
    });

    testWidgets('uses suffixSpacing before the suffix', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            prefixText: '1500',
            suffixText: '/kg',
            spacing: 4,
            suffixSpacing: 9,
          ),
        ),
      );

      expect(gapsOf(tester), <double>[4, 4, 9]);
    });
  });

  group('formatter', () {
    testWidgets('applies to the amount and the prefix, not the suffix', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            prefixText: '1500',
            suffixText: '/kg',
            formatter: (String value) => '<$value>',
          ),
        ),
      );

      expect(textSpansOf(tester).map((TextSpan s) => s.text).toList(), <String>[
        '<1500>',
        PriceViewWidgets.defaultCurrencySymbol,
        '<1250>',
        '/kg',
      ]);
    });

    testWidgets('accepts a converter declared as String? Function(String?)', (
      WidgetTester tester,
    ) async {
      // The shape an app-side locale converter usually has.
      String? convert(String? input) {
        if (input == null || input.isEmpty) {
          return '';
        }
        return input.replaceAll('1', '১').replaceAll('2', '২');
      }

      await tester.pumpWidget(
        wrap(
          PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            formatter: convert,
          ),
        ),
      );

      expect(textSpansOf(tester).last.text, '১২50');
    });

    testWidgets('keeps the value when the formatter returns null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            formatter: (String value) => null,
          ),
        ),
      );

      expect(textSpansOf(tester).last.text, '1250');
    });

    testWidgets('renders digits unchanged when no formatter is given', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const PriceViewWidgets(price: '1250', priceTextStyle: priceStyle)),
      );

      expect(textSpansOf(tester).last.text, '1250');
    });
  });

  group('strikeThrough', () {
    testWidgets('strikes the currency symbol and the amount only', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            prefixText: '1500',
            suffixText: '/kg',
            strikeThrough: true,
          ),
        ),
      );

      final List<TextSpan> spans = textSpansOf(tester);
      expect(spans[0].style?.decoration, isNot(TextDecoration.lineThrough));
      expect(spans[1].style?.decoration, TextDecoration.lineThrough);
      expect(spans[2].style?.decoration, TextDecoration.lineThrough);
      expect(spans[3].style?.decoration, isNot(TextDecoration.lineThrough));
    });

    testWidgets('applies the strike-through color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            strikeThrough: true,
            strikeThroughColor: Colors.red,
          ),
        ),
      );

      expect(textSpansOf(tester).last.style?.decorationColor, Colors.red);
    });

    testWidgets('leaves the style untouched when false', (
      WidgetTester tester,
    ) async {
      const TextStyle underlined = TextStyle(
        fontSize: 16,
        decoration: TextDecoration.underline,
      );
      await tester.pumpWidget(
        wrap(const PriceViewWidgets(price: '1250', priceTextStyle: underlined)),
      );

      // A decoration set by the caller survives.
      expect(
        textSpansOf(tester).last.style?.decoration,
        TextDecoration.underline,
      );
    });
  });

  group('styles', () {
    testWidgets('falls back to priceTextStyle for every part', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            prefixText: '1500',
            suffixText: '/kg',
          ),
        ),
      );

      for (final TextSpan span in textSpansOf(tester)) {
        expect(span.style, priceStyle);
      }
    });

    testWidgets('honours the per-part styles', (WidgetTester tester) async {
      const TextStyle prefix = TextStyle(fontSize: 10, color: Colors.grey);
      const TextStyle currency = TextStyle(fontSize: 12, color: Colors.green);
      const TextStyle suffix = TextStyle(fontSize: 8, color: Colors.blue);

      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            prefixText: '1500',
            prefixTextStyle: prefix,
            currencyTextStyle: currency,
            suffixText: '/kg',
            suffixTextStyle: suffix,
          ),
        ),
      );

      final List<TextSpan> spans = textSpansOf(tester);
      expect(spans[0].style, prefix);
      expect(spans[1].style, currency);
      expect(spans[2].style, priceStyle);
      expect(spans[3].style, suffix);
    });
  });

  group('layout', () {
    testWidgets('defaults to a single start-aligned line', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const PriceViewWidgets(price: '1250', priceTextStyle: priceStyle)),
      );

      final RichText richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.maxLines, 1);
      expect(richText.textAlign, TextAlign.start);
      expect(richText.overflow, TextOverflow.clip);
    });

    testWidgets('honours textAlign, maxLines and overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const PriceViewWidgets(
            price: '1250',
            priceTextStyle: priceStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

      final RichText richText = tester.widget<RichText>(find.byType(RichText));
      expect(richText.maxLines, 2);
      expect(richText.textAlign, TextAlign.center);
      expect(richText.overflow, TextOverflow.ellipsis);
    });
  });
}
