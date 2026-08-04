import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shukhee_ui_component/shukhee_ui_component.dart';

void main() {
  /// Wraps [field] in a form so validation can be driven.
  Widget wrap(
    CustomTextFieldForm field, {
    GlobalKey<FormState>? formKey,
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Form(key: formKey, child: field),
      ),
    );
  }

  /// Returns the decoration the underlying field renders with.
  InputDecoration decorationOf(WidgetTester tester) {
    return tester.widget<TextField>(find.byType(TextField)).decoration!;
  }

  /// Returns the color of an outline border.
  Color colorOf(InputBorder? border) =>
      (border! as OutlineInputBorder).borderSide.color;

  group('content', () {
    testWidgets('renders the label and the hint', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextFieldForm(labelText: 'Email', hintText: 'you@x.com'),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('you@x.com'), findsOneWidget);
    });

    testWidgets('edits through the controller and reports changes', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      String? seen;

      await tester.pumpWidget(
        wrap(
          CustomTextFieldForm(
            textController: controller,
            onChange: (String value) => seen = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'hello');
      expect(controller.text, 'hello');
      expect(seen, 'hello');
    });

    testWidgets('starts from initialValue', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(const CustomTextFieldForm(initialValue: 'preset')),
      );

      expect(find.text('preset'), findsOneWidget);
    });

    testWidgets('rejects a controller and an initialValue together', (
      WidgetTester tester,
    ) async {
      expect(
        () => CustomTextFieldForm(
          textController: TextEditingController(),
          initialValue: 'preset',
        ),
        throwsAssertionError,
      );
    });

    testWidgets('rejects an obscured multiline field', (
      WidgetTester tester,
    ) async {
      // Not const: a const assert failure is a compile-time error.
      expect(
        () => CustomTextFieldForm(hideText: true, maxLines: 3),
        throwsAssertionError,
      );
    });
  });

  group('behaviour', () {
    testWidgets('defaults to a single line', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const CustomTextFieldForm()));

      expect(tester.widget<TextField>(find.byType(TextField)).maxLines, 1);
    });

    testWidgets('obscures the text when hideText is set', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const CustomTextFieldForm(hideText: true)));

      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isTrue,
      );
    });

    testWidgets('onTap makes the field read-only', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(CustomTextFieldForm(onTap: () {})));

      expect(tester.widget<TextField>(find.byType(TextField)).readOnly, isTrue);
    });

    testWidgets('an explicit readOnly wins over onTap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(CustomTextFieldForm(onTap: () {}, readOnly: false)),
      );

      expect(
        tester.widget<TextField>(find.byType(TextField)).readOnly,
        isFalse,
      );
    });

    testWidgets('applies the input formatters', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          CustomTextFieldForm(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'a1b2c3');
      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('is not editable when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const CustomTextFieldForm(enabled: false)));

      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });
  });

  group('validation', () {
    testWidgets('shows the validator message', (WidgetTester tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        wrap(
          CustomTextFieldForm(
            validator: (String? value) =>
                (value == null || value.isEmpty) ? 'Required' : null,
          ),
          formKey: formKey,
        ),
      );

      expect(find.text('Required'), findsNothing);
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('paints the error border when invalid', (
      WidgetTester tester,
    ) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        wrap(
          const CustomTextFieldForm(
            errorBorderColor: Colors.purple,
            validator: _alwaysInvalid,
          ),
          formKey: formKey,
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      // Both error states are styled, so a focused invalid field stays red.
      expect(colorOf(decorationOf(tester).errorBorder), Colors.purple);
      expect(colorOf(decorationOf(tester).focusedErrorBorder), Colors.purple);
    });
  });

  group('borders', () {
    testWidgets('resolves a color per state', (WidgetTester tester) async {
      final ThemeData theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      );
      await tester.pumpWidget(wrap(const CustomTextFieldForm(), theme: theme));

      final InputDecoration decoration = decorationOf(tester);
      final ThemeData resolved = Theme.of(
        tester.element(find.byType(CustomTextFieldForm)),
      );
      expect(colorOf(decoration.enabledBorder), resolved.colorScheme.outline);
      expect(colorOf(decoration.focusedBorder), UiTokens.accentColor);
      expect(colorOf(decoration.disabledBorder), resolved.disabledColor);
      expect(colorOf(decoration.errorBorder), resolved.colorScheme.error);
    });

    testWidgets('honours the per-state color overrides', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextFieldForm(
            borderColor: Colors.grey,
            focusedBorderColor: Colors.green,
            disabledBorderColor: Colors.black,
            errorBorderColor: Colors.purple,
          ),
        ),
      );

      final InputDecoration decoration = decorationOf(tester);
      expect(colorOf(decoration.enabledBorder), Colors.grey);
      expect(colorOf(decoration.focusedBorder), Colors.green);
      expect(colorOf(decoration.disabledBorder), Colors.black);
      expect(colorOf(decoration.errorBorder), Colors.purple);
    });

    testWidgets('shares the radius and width across every state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(const CustomTextFieldForm(borderRadius: 20, borderWidth: 3)),
      );

      final InputDecoration decoration = decorationOf(tester);
      for (final InputBorder? border in <InputBorder?>[
        decoration.border,
        decoration.enabledBorder,
        decoration.focusedBorder,
        decoration.disabledBorder,
        decoration.errorBorder,
        decoration.focusedErrorBorder,
      ]) {
        final OutlineInputBorder outline = border! as OutlineInputBorder;
        expect(outline.borderRadius, BorderRadius.circular(20));
        expect(outline.borderSide.width, 3);
      }
    });

    testWidgets('defaults the radius to the large token', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const CustomTextFieldForm()));

      expect(CustomTextFieldForm.defaultRadius, UiTokens.largeRadius);
      expect(
        (decorationOf(tester).enabledBorder! as OutlineInputBorder)
            .borderRadius,
        BorderRadius.circular(UiTokens.largeRadius),
      );
    });
  });

  group('decoration', () {
    testWidgets('fills only when a background color is given', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrap(const CustomTextFieldForm()));
      expect(decorationOf(tester).filled, isFalse);

      await tester.pumpWidget(
        wrap(const CustomTextFieldForm(backgroundColor: Colors.amber)),
      );
      expect(decorationOf(tester).filled, isTrue);
      expect(decorationOf(tester).fillColor, Colors.amber);
    });

    testWidgets('hides the counter when asked', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(const CustomTextFieldForm(maxLength: 5, showCounter: false)),
      );

      expect(decorationOf(tester).counterText, '');
      expect(find.text('0/5'), findsNothing);
    });

    testWidgets('shows the counter by default', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(const CustomTextFieldForm(maxLength: 5)));

      expect(decorationOf(tester).counterText, isNull);
      expect(find.text('0/5'), findsOneWidget);
    });

    testWidgets('renders the prefix and suffix icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextFieldForm(
            prefixIcon: Icon(Icons.mail),
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
      );

      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}

String? _alwaysInvalid(String? value) => 'Invalid';
