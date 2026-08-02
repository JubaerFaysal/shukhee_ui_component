import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  /// Wraps [button] in a minimal app that bounds, but does not force, its
  /// width — the way a [Column] or a [ListView] would.
  Widget wrap(CustomButton button, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: button,
          ),
        ),
      ),
    );
  }

  /// Returns the [Material] the button paints its background with.
  Material materialOf(WidgetTester tester) {
    return tester.widget<Material>(
      find
          .descendant(
            of: find.byType(CustomButton),
            matching: find.byType(Material),
          )
          .first,
    );
  }

  group('content', () {
    testWidgets('renders the centre widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(CustomButton(onTap: () {}, centerWidget: const Text('Continue'))),
      );

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('renders the prefix and suffix widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            prefixWidget: const Icon(Icons.lock),
            centerWidget: const Text('Sign in'),
            suffixWidget: const Icon(Icons.arrow_forward),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('omits empty slots instead of padding them out', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(CustomButton(onTap: () {}, centerWidget: const Text('Only'))),
      );

      final Row row = tester.widget<Row>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Row),
        ),
      );
      expect(row.children, hasLength(1));
    });

    testWidgets('separates slots with the spacing gap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            centerWidget: const Text('Go'),
            suffixWidget: const Icon(Icons.arrow_forward),
            spacing: 24,
          ),
        ),
      );

      final Row row = tester.widget<Row>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Row),
        ),
      );
      // centre, gap, suffix
      expect(row.children, hasLength(3));
      expect((row.children[1] as SizedBox).width, 24);
    });
  });

  group('tap', () {
    testWidgets('forwards taps while enabled', (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          CustomButton(onTap: () => taps++, centerWidget: const Text('Tap me')),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      expect(taps, 1);
    });

    testWidgets('ignores taps when isEnabled is false', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () => taps++,
            isEnabled: false,
            centerWidget: const Text('Tap me'),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      expect(taps, 0);
      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
    });

    testWidgets('ignores taps while loading', (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () => taps++,
            isLoading: true,
            centerWidget: const Text('Tap me'),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      expect(taps, 0);
    });

    testWidgets('a null onTap disables the button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const CustomButton(onTap: null, centerWidget: Text('Tap me'))),
      );

      expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
    });
  });

  group('loading', () {
    testWidgets('swaps the content for a progress indicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            isLoading: true,
            centerWidget: const Text('Submit'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('renders a custom loading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            isLoading: true,
            centerWidget: const Text('Submit'),
            loadingWidget: const Text('Please wait'),
          ),
        ),
      );

      expect(find.text('Please wait'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('appearance', () {
    testWidgets('uses the theme primary color by default', (
      WidgetTester tester,
    ) async {
      final ThemeData theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      );
      await tester.pumpWidget(
        wrap(
          CustomButton(onTap: () {}, centerWidget: const Text('Go')),
          theme: theme,
        ),
      );

      expect(materialOf(tester).color, theme.colorScheme.primary);
    });

    testWidgets('honours a custom background color and radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            backgroundColor: Colors.green,
            radius: 30,
            centerWidget: const Text('Go'),
          ),
        ),
      );

      final Material material = materialOf(tester);
      expect(material.color, Colors.green);
      expect(
        (material.shape! as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(30),
      );
    });

    testWidgets('draws no border unless one is asked for', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(CustomButton(onTap: () {}, centerWidget: const Text('Go'))),
      );

      expect(
        (materialOf(tester).shape! as RoundedRectangleBorder).side,
        BorderSide.none,
      );
    });

    testWidgets('draws the requested border', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            borderColor: Colors.red,
            borderWidth: 3,
            centerWidget: const Text('Go'),
          ),
        ),
      );

      final BorderSide side =
          (materialOf(tester).shape! as RoundedRectangleBorder).side;
      expect(side.color, Colors.red);
      expect(side.width, 3);
    });

    testWidgets('flattens the elevation while disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            elevation: 8,
            isEnabled: false,
            centerWidget: const Text('Go'),
          ),
        ),
      );

      expect(materialOf(tester).elevation, 0);
    });

    testWidgets('applies foregroundColor to text and icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            foregroundColor: Colors.amber,
            centerWidget: const Text('Go'),
            suffixWidget: const Icon(Icons.arrow_forward),
          ),
        ),
      );

      // Read the styles the text and the icon glyph actually render with,
      // rather than any DefaultTextStyle that happens to sit above them.
      final RichText label = tester.widget<RichText>(
        find.descendant(of: find.text('Go'), matching: find.byType(RichText)),
      );
      final RichText icon = tester.widget<RichText>(
        find.descendant(
          of: find.byIcon(Icons.arrow_forward),
          matching: find.byType(RichText),
        ),
      );
      expect(label.text.style?.color, Colors.amber);
      expect(icon.text.style?.color, Colors.amber);
    });
  });

  group('sizing', () {
    testWidgets('defaults to 56 tall and fills the available width', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(CustomButton(onTap: () {}, centerWidget: const Text('Go'))),
      );

      expect(tester.getSize(find.byType(CustomButton)), const Size(300, 56));
    });

    testWidgets('honours an explicit width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            width: 180,
            height: 40,
            centerWidget: const Text('Go'),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomButton)), const Size(180, 40));
    });

    testWidgets('adds the margin around the button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomButton(
            onTap: () {},
            height: 40,
            margin: const EdgeInsets.all(12),
            centerWidget: const Text('Go'),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomButton)).height, 40 + 24);
      expect(
        tester
            .getSize(
              find
                  .descendant(
                    of: find.byType(CustomButton),
                    matching: find.byType(Material),
                  )
                  .first,
            )
            .height,
        40,
      );
    });
  });
}
