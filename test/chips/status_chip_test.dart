import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  /// Wraps [chip] in a minimal app.
  Widget wrap(StatusChip chip, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: chip)),
    );
  }

  /// Returns the decoration the chip paints itself with.
  BoxDecoration decorationOf(WidgetTester tester) {
    final Container container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(StatusChip),
            matching: find.byType(Container),
          )
          .first,
    );
    return container.decoration! as BoxDecoration;
  }

  /// Returns the style the label renders with.
  TextStyle styleOf(WidgetTester tester) {
    return tester
        .widget<Text>(
          find.descendant(
            of: find.byType(StatusChip),
            matching: find.byType(Text),
          ),
        )
        .style!;
  }

  group('label', () {
    testWidgets('renders the status', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const StatusChip(status: 'Approved')));

      expect(find.text('Approved'), findsOneWidget);
    });

    testWidgets('falls back to the placeholder when null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const StatusChip()));

      expect(find.text('N/A'), findsOneWidget);
    });

    testWidgets('falls back to the placeholder when empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const StatusChip(status: '')));

      expect(find.text('N/A'), findsOneWidget);
    });

    testWidgets('honours a custom placeholder', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const StatusChip(placeholder: 'Unknown')));

      expect(find.text('Unknown'), findsOneWidget);
      expect(find.text('N/A'), findsNothing);
    });
  });

  group('colors', () {
    testWidgets('defaults to the brand color', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const StatusChip(status: 'Pending')));

      const Color brand = StatusChip.defaultColor;
      expect(brand, const Color(0xFF00AAD0));
      expect(decorationOf(tester).color, brand.withValues(alpha: 0.2));
      expect(decorationOf(tester).border!.top.color, brand);
      expect(styleOf(tester).color, brand);
    });

    testWidgets('keeps the brand color in the dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(status: 'Pending'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
          ),
        ),
      );

      expect(styleOf(tester).color, StatusChip.defaultColor);
    });

    testWidgets('the accent drives label, border and background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const StatusChip(status: 'Approved', color: Colors.green)),
      );

      final BoxDecoration decoration = decorationOf(tester);
      expect(decoration.color, Colors.green.withValues(alpha: 0.2));
      expect(decoration.border!.top.color, Colors.green);
      expect(styleOf(tester).color, Colors.green);
    });

    testWidgets('honours a custom background opacity', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(
            status: 'Approved',
            color: Colors.green,
            backgroundOpacity: 0.5,
          ),
        ),
      );

      expect(decorationOf(tester).color, Colors.green.withValues(alpha: 0.5));
    });

    testWidgets('backgroundColor overrides the tint only', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(
            status: 'Approved',
            color: Colors.green,
            backgroundColor: Colors.white,
          ),
        ),
      );

      expect(decorationOf(tester).color, Colors.white);
      expect(decorationOf(tester).border!.top.color, Colors.green);
      expect(styleOf(tester).color, Colors.green);
    });

    testWidgets('borderColor overrides the border only', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(
            status: 'Approved',
            color: Colors.green,
            borderColor: Colors.black,
          ),
        ),
      );

      expect(decorationOf(tester).border!.top.color, Colors.black);
      expect(styleOf(tester).color, Colors.green);
    });
  });

  group('shape', () {
    testWidgets('defaults to a hairline border and the default radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const StatusChip(status: 'Pending')));

      expect(StatusChip.defaultRadius, 4);
      final BoxDecoration decoration = decorationOf(tester);
      expect(decoration.border!.top.width, 0.5);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(StatusChip.defaultRadius),
      );
    });

    testWidgets('draws no border when the width is zero', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const StatusChip(status: 'Pending', borderWidth: 0)),
      );

      expect(decorationOf(tester).border, isNull);
    });

    testWidgets('honours a custom border width and radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const StatusChip(status: 'Pending', borderWidth: 2, radius: 4)),
      );

      final BoxDecoration decoration = decorationOf(tester);
      expect(decoration.border!.top.width, 2);
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });
  });

  group('layout', () {
    testWidgets('shrink-wraps the label with the default padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const StatusChip(status: 'Approved')));

      final Size chip = tester.getSize(find.byType(StatusChip));
      final Size label = tester.getSize(
        find.descendant(
          of: find.byType(StatusChip),
          matching: find.byType(Text),
        ),
      );
      // 8 + 8 padding, plus the 0.5 border on each side.
      expect(chip.width, label.width + 16 + 1);
      expect(chip.height, label.height + 8 + 1);
    });

    testWidgets('honours custom padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(
            status: 'Approved',
            padding: EdgeInsets.all(10),
            borderWidth: 0,
          ),
        ),
      );

      final Size chip = tester.getSize(find.byType(StatusChip));
      final Size label = tester.getSize(
        find.descendant(
          of: find.byType(StatusChip),
          matching: find.byType(Text),
        ),
      );
      expect(chip.width, label.width + 20);
      expect(chip.height, label.height + 20);
    });
  });

  group('textStyle', () {
    testWidgets('defaults to semi-bold labelLarge in the accent color', (
      WidgetTester tester,
    ) async {
      final ThemeData theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      );
      await tester.pumpWidget(
        wrap(const StatusChip(status: 'Pending'), theme: theme),
      );

      // Read the localized text theme, since a raw ThemeData carries no
      // font sizes until MaterialApp applies the text geometry.
      final ThemeData resolved = Theme.of(
        tester.element(find.byType(StatusChip)),
      );
      final TextStyle style = styleOf(tester);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.fontSize, resolved.textTheme.labelLarge!.fontSize);
      expect(style.color, StatusChip.defaultColor);
    });

    testWidgets('merges over the default, keeping the accent color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(
            status: 'Pending',
            color: Colors.green,
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
      );

      final TextStyle style = styleOf(tester);
      expect(style.fontSize, 20);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.color, Colors.green);
    });

    testWidgets('a color in textStyle wins over the accent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const StatusChip(
            status: 'Pending',
            color: Colors.green,
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
      );

      expect(styleOf(tester).color, Colors.black);
      // The accent still colors the border.
      expect(decorationOf(tester).border!.top.color, Colors.green);
    });
  });
}
