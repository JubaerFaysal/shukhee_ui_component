import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  /// Wraps [appBar] in a minimal app so it can be pumped on its own.
  Widget wrap(GradientAppBar appBar, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(appBar: appBar, body: const SizedBox.shrink()),
    );
  }

  group('title', () {
    testWidgets('renders the title string', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const GradientAppBar(title: 'Profile')));

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('titleWidget takes priority over title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const GradientAppBar(
            title: 'Ignored',
            titleWidget: Text('Custom title'),
          ),
        ),
      );

      expect(find.text('Custom title'), findsOneWidget);
      expect(find.text('Ignored'), findsNothing);
    });

    testWidgets('applies titleStyle to the title', (WidgetTester tester) async {
      const TextStyle style = TextStyle(fontSize: 27, color: Color(0xFFAABBCC));
      await tester.pumpWidget(
        wrap(const GradientAppBar(title: 'Styled', titleStyle: style)),
      );

      final DefaultTextStyle defaultStyle = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('Styled'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      expect(defaultStyle.style.fontSize, 27);
      expect(defaultStyle.style.color, const Color(0xFFAABBCC));
    });

    testWidgets('renders no title when both are omitted', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const GradientAppBar()));

      expect(tester.widget<AppBar>(find.byType(AppBar)).title, isNull);
    });
  });

  group('leading', () {
    testWidgets('shows no leading widget by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const GradientAppBar(title: 'Home')));

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('showBackButton pops the current route', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const Scaffold(
                      appBar: GradientAppBar(
                        title: 'Details',
                        showBackButton: true,
                      ),
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Details'), findsOneWidget);

      await tester.tap(find.byType(BackButtonIcon));
      await tester.pumpAndSettle();
      expect(find.text('Details'), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('uses the default back button tooltip', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const GradientAppBar(title: 'Home', showBackButton: true)),
      );

      expect(find.byTooltip('Back'), findsOneWidget);
    });

    testWidgets('uses a custom back button tooltip', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const GradientAppBar(
            title: 'Home',
            showBackButton: true,
            backButtonTooltip: 'Go back home',
          ),
        ),
      );

      expect(find.byTooltip('Go back home'), findsOneWidget);
      expect(find.byTooltip('Back'), findsNothing);
    });

    testWidgets('renders a custom leading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          const GradientAppBar(
            title: 'Home',
            leading: Icon(Icons.menu, key: Key('leading')),
          ),
        ),
      );

      expect(find.byKey(const Key('leading')), findsOneWidget);
    });

    testWidgets('leading takes priority over showBackButton', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const GradientAppBar(
            title: 'Home',
            showBackButton: true,
            leading: Icon(Icons.menu, key: Key('leading')),
          ),
        ),
      );

      expect(find.byKey(const Key('leading')), findsOneWidget);
      expect(find.byType(BackButtonIcon), findsNothing);
    });
  });

  group('actions', () {
    testWidgets('renders actions and forwards taps', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          GradientAppBar(
            title: 'Home',
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => taps++,
              ),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      expect(taps, 1);
    });
  });

  group('background', () {
    const LinearGradient gradient = LinearGradient(
      colors: <Color>[Color(0xFF6A11CB), Color(0xFF2575FC)],
    );

    /// Returns the decoration painted behind the app bar, if any.
    BoxDecoration? gradientDecoration(WidgetTester tester) {
      final Finder finder = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(DecoratedBox),
      );
      for (final DecoratedBox box in tester.widgetList<DecoratedBox>(finder)) {
        final Decoration decoration = box.decoration;
        if (decoration is BoxDecoration && decoration.gradient != null) {
          return decoration;
        }
      }
      return null;
    }

    testWidgets('paints the gradient behind the app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const GradientAppBar(title: 'Home', gradient: gradient)),
      );

      expect(gradientDecoration(tester)?.gradient, gradient);
    });

    testWidgets('the gradient fills the whole app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: const GradientAppBar(
                  title: 'Home',
                  height: 72,
                  gradient: gradient,
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(text: 'One'),
                      Tab(text: 'Two'),
                    ],
                  ),
                ),
                body: const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      );

      final Finder gradientBox = find
          .descendant(
            of: find.byType(AppBar),
            matching: find.byType(DecoratedBox),
          )
          .first;

      // A childless DecoratedBox collapses to zero height inside the
      // flexibleSpace slot, which paints nothing at all.
      expect(tester.getSize(gradientBox), tester.getSize(find.byType(AppBar)));
      expect(tester.getSize(gradientBox).height, greaterThan(0));
    });

    testWidgets('gradient takes priority over backgroundColor', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const GradientAppBar(
            title: 'Home',
            backgroundColor: Colors.green,
            gradient: gradient,
          ),
        ),
      );

      expect(gradientDecoration(tester)?.gradient, gradient);
      final Material material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, Colors.transparent);
      expect(material.surfaceTintColor, Colors.transparent);
    });

    testWidgets('uses backgroundColor when no gradient is given', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const GradientAppBar(title: 'Home', backgroundColor: Colors.green),
        ),
      );

      expect(gradientDecoration(tester), isNull);
      final Material material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, Colors.green);
    });

    testWidgets('clips the gradient to a custom shape', (
      WidgetTester tester,
    ) async {
      const ShapeBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      );
      await tester.pumpWidget(
        wrap(
          const GradientAppBar(title: 'Home', gradient: gradient, shape: shape),
        ),
      );

      final Iterable<ClipPath> clips = tester.widgetList<ClipPath>(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(ClipPath),
        ),
      );
      expect(
        clips.any(
          (ClipPath clip) =>
              clip.clipper is ShapeBorderClipper &&
              (clip.clipper! as ShapeBorderClipper).shape == shape,
        ),
        isTrue,
      );
    });

    testWidgets('follows the ambient theme when no colors are given', (
      WidgetTester tester,
    ) async {
      final ThemeData dark = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpWidget(
        wrap(const GradientAppBar(title: 'Home'), theme: dark),
      );

      final Material material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, dark.colorScheme.surface);
    });
  });

  group('bottom', () {
    testWidgets('renders the bottom widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: const GradientAppBar(
                title: 'Home',
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(text: 'One'),
                    Tab(text: 'Two'),
                  ],
                ),
              ),
              body: const SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
    });
  });

  group('sizing', () {
    testWidgets('defaults to kToolbarHeight', (WidgetTester tester) async {
      const GradientAppBar appBar = GradientAppBar(title: 'Home');
      await tester.pumpWidget(wrap(appBar));

      expect(appBar.preferredSize.height, kToolbarHeight);
      expect(tester.getSize(find.byType(AppBar)).height, kToolbarHeight);
    });

    testWidgets('honours a custom height', (WidgetTester tester) async {
      const GradientAppBar appBar = GradientAppBar(title: 'Home', height: 96);
      await tester.pumpWidget(wrap(appBar));

      expect(appBar.preferredSize.height, 96);
      expect(tester.getSize(find.byType(AppBar)).height, 96);
    });

    testWidgets('preferredSize includes the bottom widget height', (
      WidgetTester tester,
    ) async {
      const TabBar bottom = TabBar(
        tabs: <Widget>[
          Tab(text: 'One'),
          Tab(text: 'Two'),
        ],
      );
      const GradientAppBar appBar = GradientAppBar(
        title: 'Home',
        height: 72,
        bottom: bottom,
      );

      expect(appBar.preferredSize.width, double.infinity);
      expect(appBar.preferredSize.height, 72 + bottom.preferredSize.height);

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(appBar: appBar, body: const SizedBox.shrink()),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(AppBar)).height,
        72 + bottom.preferredSize.height,
      );
    });
  });
}
