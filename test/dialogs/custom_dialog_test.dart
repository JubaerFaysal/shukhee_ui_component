import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  /// Wraps [dialog] in a minimal app, without a dialog route.
  Widget wrap(CustomDialog dialog, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: dialog),
    );
  }

  /// Pumps a page whose only button opens [dialog] through [CustomDialog.show].
  Future<void> pumpOpener(
    WidgetTester tester,
    CustomDialog dialog, {
    bool? barrierDismissible,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) => TextButton(
              onPressed: () => dialog.show<void>(
                context,
                barrierDismissible: barrierDismissible,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  /// Returns the decoration of the container holding the dialog's content.
  BoxDecoration decorationOf(WidgetTester tester) {
    final Container container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(CustomDialog),
            matching: find.byType(Container),
          )
          .first,
    );
    return container.decoration! as BoxDecoration;
  }

  group('content', () {
    testWidgets('renders the message and the default title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(CustomDialog(infoText: 'Are you sure?', positiveAction: () {})),
      );

      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text(CustomDialog.defaultTitle), findsOneWidget);
    });

    testWidgets('renders the given title', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            title: 'Log out',
            infoText: 'You will need to sign in again.',
            positiveAction: () {},
          ),
        ),
      );

      expect(find.text('Log out'), findsOneWidget);
      expect(find.text(CustomDialog.defaultTitle), findsNothing);
    });

    testWidgets('renders the icon above the title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            icon: const Icon(Icons.warning_amber_rounded),
            infoText: 'Careful.',
            positiveAction: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      final Offset icon = tester.getCenter(
        find.byIcon(Icons.warning_amber_rounded),
      );
      expect(icon.dy, lessThan(tester.getCenter(find.text('Alert')).dy));
    });

    testWidgets('leaves out the icon and its gap when none is given', (
      WidgetTester tester,
    ) async {
      Future<double> heightWith(Widget? icon) async {
        await tester.pumpWidget(
          wrap(
            CustomDialog(
              icon: icon,
              spaceUnderIcon: 20,
              infoText: 'Careful.',
              positiveAction: () {},
            ),
          ),
        );
        return tester.getSize(find.byType(Column).first).height;
      }

      final double without = await heightWith(null);
      final double with40 = await heightWith(
        const SizedBox(height: 40, width: 40),
      );
      expect(with40 - without, 60);
    });

    testWidgets('renders the body between the message and the buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Pick a reason.',
            body: const Text('body'),
            positiveAction: () {},
          ),
        ),
      );

      final double body = tester.getCenter(find.text('body')).dy;
      expect(
        body,
        greaterThan(tester.getCenter(find.text('Pick a reason.')).dy),
      );
      expect(
        body,
        lessThan(
          tester.getCenter(find.text(CustomDialog.defaultPositiveText)).dy,
        ),
      );
    });

    testWidgets('scrolls the content when asked', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Long',
            scrollable: true,
            positiveAction: () {},
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(CustomDialog),
          matching: find.byType(SingleChildScrollView),
        ),
        findsOneWidget,
      );
    });
  });

  group('buttons', () {
    testWidgets('renders the default labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(CustomDialog(infoText: 'Sure?', positiveAction: () {})),
      );

      expect(find.text(CustomDialog.defaultPositiveText), findsOneWidget);
      expect(find.text(CustomDialog.defaultNegativeText), findsOneWidget);
    });

    testWidgets('reports the positive tap', (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Sure?',
            positiveText: 'Yes',
            positiveAction: () => taps++,
          ),
        ),
      );

      await tester.tap(find.text('Yes'));
      expect(taps, 1);
    });

    testWidgets('reports the negative tap', (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Sure?',
            negativeText: 'No',
            negativeAction: () => taps++,
            positiveAction: () {},
          ),
        ),
      );

      await tester.tap(find.text('No'));
      expect(taps, 1);
    });

    testWidgets('closes the dialog when no negative action is given', (
      WidgetTester tester,
    ) async {
      await pumpOpener(
        tester,
        CustomDialog(infoText: 'Sure?', positiveAction: () {}),
      );
      expect(find.byType(CustomDialog), findsOneWidget);

      await tester.tap(find.text(CustomDialog.defaultNegativeText));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsNothing);
    });

    testWidgets('leaves out the negative button when asked', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Sure?',
            showNegativeButton: false,
            positiveAction: () {},
          ),
        ),
      );

      expect(find.text(CustomDialog.defaultNegativeText), findsNothing);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('swallows the positive tap while loading', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Sure?',
            isPositiveButtonLoading: true,
            positiveAction: () => taps++,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(CustomDialog.defaultPositiveText), findsNothing);
      await tester.tap(find.byType(CircularProgressIndicator));
      expect(taps, 0);
    });

    testWidgets('swallows the positive tap while disabled', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Sure?',
            isPositiveButtonEnabled: false,
            positiveAction: () => taps++,
          ),
        ),
      );

      await tester.tap(find.text(CustomDialog.defaultPositiveText));
      expect(taps, 0);
    });
  });

  group('styling', () {
    testWidgets('paints the title in the accent color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            title: 'Alert',
            infoText: 'Sure?',
            accentColor: const Color(0xFF112233),
            positiveAction: () {},
          ),
        ),
      );

      final Text title = tester.widget<Text>(find.text('Alert'));
      expect(title.style!.color, const Color(0xFF112233));
      expect(title.style!.fontWeight, FontWeight.w600);
    });

    testWidgets('falls back to the brand accent', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            title: 'Alert',
            infoText: 'Sure?',
            positiveAction: () {},
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Alert')).style!.color,
        UiTokens.accentColor,
      );
    });

    testWidgets('honours the given text styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            title: 'Alert',
            infoText: 'Sure?',
            titleStyle: const TextStyle(fontSize: 30),
            infoTextStyle: const TextStyle(fontSize: 11),
            positiveButtonTextStyle: const TextStyle(fontSize: 12),
            negativeButtonTextStyle: const TextStyle(fontSize: 13),
            positiveAction: () {},
          ),
        ),
      );

      expect(tester.widget<Text>(find.text('Alert')).style!.fontSize, 30);
      expect(tester.widget<Text>(find.text('Sure?')).style!.fontSize, 11);
      expect(
        tester
            .widget<Text>(find.text(CustomDialog.defaultPositiveText))
            .style!
            .fontSize,
        12,
      );
      expect(
        tester
            .widget<Text>(find.text(CustomDialog.defaultNegativeText))
            .style!
            .fontSize,
        13,
      );
    });

    testWidgets('paints the given background and radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Sure?',
            backgroundColor: Colors.white,
            borderRadius: 30,
            positiveAction: () {},
          ),
        ),
      );

      final BoxDecoration decoration = decorationOf(tester);
      expect(decoration.color, Colors.white);
      expect(decoration.borderRadius, BorderRadius.circular(30));
      expect(
        tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
        Colors.white,
      );
    });

    testWidgets('falls back to the themed dialog background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(infoText: 'Sure?', positiveAction: () {}),
          theme: ThemeData(
            dialogTheme: const DialogThemeData(backgroundColor: Colors.amber),
          ),
        ),
      );

      expect(decorationOf(tester).color, Colors.amber);
    });

    testWidgets('sizes and spaces the buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomDialog(
            infoText: 'Sure?',
            buttonHeight: 40,
            spaceBetweenButtons: 24,
            positiveAction: () {},
          ),
        ),
      );

      final Finder buttons = find.byType(CustomButton);
      expect(tester.getSize(buttons.first).height, 40);
      expect(
        tester.getTopLeft(buttons.last).dx -
            tester.getTopRight(buttons.first).dx,
        24,
      );
    });
  });

  group('dismissal', () {
    testWidgets('refuses a back gesture by default', (
      WidgetTester tester,
    ) async {
      await pumpOpener(
        tester,
        CustomDialog(infoText: 'Sure?', positiveAction: () {}),
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsOneWidget);
    });

    testWidgets('allows a back gesture once canClose is set', (
      WidgetTester tester,
    ) async {
      await pumpOpener(
        tester,
        CustomDialog(infoText: 'Sure?', canClose: true, positiveAction: () {}),
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsNothing);
    });

    testWidgets('keeps the barrier solid by default', (
      WidgetTester tester,
    ) async {
      await pumpOpener(
        tester,
        CustomDialog(infoText: 'Sure?', positiveAction: () {}),
      );

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsOneWidget);
    });

    testWidgets('lets the barrier close a closable dialog', (
      WidgetTester tester,
    ) async {
      await pumpOpener(
        tester,
        CustomDialog(infoText: 'Sure?', canClose: true, positiveAction: () {}),
      );

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsNothing);
    });

    testWidgets('lets canClose overrule a dismissible barrier', (
      WidgetTester tester,
    ) async {
      await pumpOpener(
        tester,
        CustomDialog(infoText: 'Sure?', positiveAction: () {}),
        barrierDismissible: true,
      );

      // The barrier asks the navigator to pop, which PopScope refuses.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsOneWidget);
    });

    testWidgets('honours a barrierDismissible of false', (
      WidgetTester tester,
    ) async {
      await pumpOpener(
        tester,
        CustomDialog(infoText: 'Sure?', canClose: true, positiveAction: () {}),
        barrierDismissible: false,
      );

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byType(CustomDialog), findsOneWidget);
    });

    testWidgets('returns the value the dialog is popped with', (
      WidgetTester tester,
    ) async {
      String? result;
      late BuildContext pageContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                pageContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      final Future<String?> pending = CustomDialog(
        infoText: 'Sure?',
        positiveText: 'Yes',
        positiveAction: () => Navigator.of(pageContext).pop('yes'),
      ).show<String>(pageContext).then((String? value) => result = value);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      await pending;
      expect(result, 'yes');
    });
  });
}
