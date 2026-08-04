import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  /// Wraps [bar] in a minimal app.
  Widget wrap(CustomSearchBar bar, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: bar),
    );
  }

  /// Returns the decoration the bar paints itself with.
  BoxDecoration decorationOf(WidgetTester tester) {
    final Container container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(CustomSearchBar),
            matching: find.byType(Container),
          )
          .first,
    );
    return container.decoration! as BoxDecoration;
  }

  group('query', () {
    testWidgets('renders the hint', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const CustomSearchBar(hintText: 'Search')));

      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('reports every edit', (WidgetTester tester) async {
      final List<String> seen = <String>[];
      await tester.pumpWidget(
        wrap(CustomSearchBar(hintText: 'Search', onTextChanged: seen.add)),
      );

      await tester.enterText(find.byType(TextField), 'pa');
      expect(seen, <String>['pa']);
    });

    testWidgets('reports submission', (WidgetTester tester) async {
      String? submitted;
      await tester.pumpWidget(
        wrap(
          CustomSearchBar(
            hintText: 'Search',
            onSubmitted: (String value) => submitted = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'napa');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      expect(submitted, 'napa');
    });

    testWidgets('starts from initialValue without a controller', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const CustomSearchBar(hintText: 'Search', initialValue: 'seed')),
      );

      expect(find.text('seed'), findsOneWidget);
    });

    testWidgets('uses the supplied controller', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          CustomSearchBar(
            hintText: 'Search',
            textEditingController: controller,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'hello');
      expect(controller.text, 'hello');
    });

    testWidgets('rejects a controller and an initialValue together', (
      WidgetTester tester,
    ) async {
      expect(
        () => CustomSearchBar(
          hintText: 'Search',
          textEditingController: TextEditingController(),
          initialValue: 'seed',
        ),
        throwsAssertionError,
      );
    });
  });

  group('trailing icon', () {
    testWidgets('shows the search icon while empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const CustomSearchBar(hintText: 'Search')));

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('swaps to a clear button once there is text', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          CustomSearchBar(
            hintText: 'Search',
            textEditingController: controller,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'pa');
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.search), findsNothing);
    });

    testWidgets('stays a search icon without a controller', (
      WidgetTester tester,
    ) async {
      // Nothing to clear when the bar does not own the text.
      await tester.pumpWidget(wrap(const CustomSearchBar(hintText: 'Search')));

      await tester.enterText(find.byType(TextField), 'pa');
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('clearing empties the query and reports it', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      final List<String> seen = <String>[];
      bool cleared = false;

      await tester.pumpWidget(
        wrap(
          CustomSearchBar(
            hintText: 'Search',
            textEditingController: controller,
            onTextChanged: seen.add,
            onClear: () => cleared = true,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'pa');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(find.text('pa'), findsNothing);
      expect(seen.last, '');
      expect(cleared, isTrue);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('keeps the search icon when the clear button is off', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          CustomSearchBar(
            hintText: 'Search',
            textEditingController: controller,
            showClearButton: false,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'pa');
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('forwards taps on the icon', (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(CustomSearchBar(hintText: 'Search', onIconTap: () => taps++)),
      );

      await tester.tap(find.byIcon(Icons.search));
      expect(taps, 1);
    });

    testWidgets('renders a custom icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomSearchBar(
            hintText: 'Search',
            icon: Icon(Icons.mic, key: Key('mic')),
          ),
        ),
      );

      expect(find.byKey(const Key('mic')), findsOneWidget);
      expect(find.byIcon(Icons.search), findsNothing);
    });
  });

  group('appearance', () {
    testWidgets('fills with the theme surface by default', (
      WidgetTester tester,
    ) async {
      final ThemeData theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      );
      await tester.pumpWidget(
        wrap(const CustomSearchBar(hintText: 'Search'), theme: theme),
      );

      final BoxDecoration decoration = decorationOf(tester);
      expect(decoration.color, theme.colorScheme.surface);
      expect(decoration.borderRadius, BorderRadius.circular(4));
    });

    testWidgets('honours the background, border and radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const CustomSearchBar(
            hintText: 'Search',
            backgroundColor: Colors.amber,
            borderColor: Colors.green,
            borderWidth: 2,
            borderRadius: 24,
          ),
        ),
      );

      final BoxDecoration decoration = decorationOf(tester);
      expect(decoration.color, Colors.amber);
      expect(decoration.border!.top.color, Colors.green);
      expect(decoration.border!.top.width, 2);
      expect(decoration.borderRadius, BorderRadius.circular(24));
    });

    testWidgets('puts exactly one gap beside the leading widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const CustomSearchBar(
            hintText: 'Search',
            spacing: 20,
            leading: Icon(Icons.arrow_back, key: Key('leading')),
          ),
        ),
      );

      final double leadingRight = tester
          .getRect(find.byKey(const Key('leading')))
          .right;
      final double fieldLeft = tester.getRect(find.byType(TextField)).left;
      // Row.spacing already separates the children; a SizedBox as well would
      // make this 40.
      expect(fieldLeft - leadingRight, 20);
    });

    testWidgets('renders the leading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomSearchBar(
            hintText: 'Search',
            leading: Icon(Icons.arrow_back, key: Key('leading')),
          ),
        ),
      );

      expect(find.byKey(const Key('leading')), findsOneWidget);
    });
  });

  group('layout', () {
    testWidgets('defaults to 56 tall with no margin', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const CustomSearchBar(hintText: 'Search')));

      expect(tester.getSize(find.byType(CustomSearchBar)).height, 56);
    });

    testWidgets('adds the margin around the bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomSearchBar(
            hintText: 'Search',
            height: 40,
            margin: EdgeInsets.all(16),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomSearchBar)).height, 40 + 32);
    });
  });

  group('enabled', () {
    testWidgets('stops accepting input when disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const CustomSearchBar(hintText: 'Search', enabled: false)),
      );

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });

    testWidgets('hides the clear button while disabled', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'seed',
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          CustomSearchBar(
            hintText: 'Search',
            textEditingController: controller,
            enabled: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('applies the input formatters', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomSearchBar(
            hintText: 'Search',
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'a1b2');
      expect(find.text('12'), findsOneWidget);
    });
  });
}
