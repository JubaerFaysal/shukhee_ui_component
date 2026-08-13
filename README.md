# shukhee_ui_component

[![pub package](https://img.shields.io/pub/v/shukhee_ui_component.svg)](https://pub.dev/packages/shukhee_ui_component)
[![platforms](https://img.shields.io/badge/platforms-android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows%20%7C%20linux-blue.svg)](https://pub.dev/packages/shukhee_ui_component)

A collection of ready-to-use Flutter widgets — app bar, button, dialog, text
field, search bar, chip, price label and pull-to-refresh — that keep your app's
look consistent without writing the same UI code again and again.

Every widget is a plain Flutter widget. There is no controller to set up, no
global state, and no theme you are forced to adopt: drop a widget in, pass a few
values, and it works.

<!--
  TODO: add a screenshot or GIF of the widgets here, before the Features list.
  pub.dev renders images from absolute URLs only, e.g.
  ![Widget gallery](https://raw.githubusercontent.com/JubaerFaysal/shukhee_ui_component/main/doc/images/gallery.png)
-->

## Features

- **[GradientAppBar]** — an `AppBar` that can be painted with a gradient, with
  optional back button, actions, tabs and rounded corners.
- **[CustomButton]** — prefix / center / suffix slots, plus built-in loading and
  disabled states.
- **[CustomDialog]** — a confirm-or-alert dialog with two buttons, an optional
  icon, and a slot for your own body widget.
- **[CustomTextFieldForm]** — an outlined form field that handles the normal,
  focused, error and disabled border states for you.
- **[CustomSearchBar]** — a search field with a search icon that becomes a clear
  button once the user types.
- **[StatusChip]** — a small status label themed from a single color, with a
  fallback for null or empty values.
- **[PriceViewWidgets]** — a price with a currency symbol, unit and
  strike-through discount styling, rendered as one wrapping line.
- **[CustomRefreshIndicator]** — pull-to-refresh that draws the Material or iOS
  indicator to match the platform.
- **[UiTokens]** — the shared radius, spacing and accent-color constants the
  widgets fall back to.

All widgets are pure Dart and Flutter, so they run on every platform Flutter
supports.

## Getting started

Requires Dart SDK `^3.9.2` and Flutter `>=1.17.0`.

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  shukhee_ui_component: ^0.0.1
```

Install it:

```bash
flutter pub get
```

Then import it once — a single import gives you every widget in the package:

```dart
import 'package:shukhee_ui_component/shukhee_ui_component.dart';
```

## Usage

Each snippet below is the smallest useful version of a widget. Follow the link
under it for the full guide, including every property and its default.

### GradientAppBar

```dart
Scaffold(
  appBar: const GradientAppBar(
    title: 'Dashboard',
    gradient: LinearGradient(
      colors: [Color(0xFF00AAD0), Color(0xFF005F75)],
    ),
    foregroundColor: Colors.white,
    showBackButton: true,
  ),
  body: const SizedBox.shrink(),
)
```

→ [Full `GradientAppBar` documentation][GradientAppBar]

### CustomButton

```dart
CustomButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  prefixWidget: const Icon(Icons.save),
  centerWidget: const Text('Save changes'),
)
```

→ [Full `CustomButton` documentation][CustomButton]

### CustomDialog

```dart
CustomDialog(
  title: 'Delete file?',
  infoText: 'This cannot be undone.',
  positiveText: 'Delete',
  positiveAction: () {
    Navigator.of(context).pop();
    _deleteFile();
  },
).show(context);
```

→ [Full `CustomDialog` documentation][CustomDialog]

### CustomTextFieldForm

```dart
CustomTextFieldForm(
  labelText: 'Email',
  textController: _emailController,
  inputType: TextInputType.emailAddress,
  validator: (value) =>
      (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
)
```

→ [Full `CustomTextFieldForm` documentation][CustomTextFieldForm]

### CustomSearchBar

```dart
CustomSearchBar(
  hintText: 'Search products',
  textEditingController: _controller,
  onTextChanged: (value) => setState(() => _query = value),
)
```

→ [Full `CustomSearchBar` documentation][CustomSearchBar]

### StatusChip

```dart
StatusChip(
  status: order.status,
  color: Colors.green,
)
```

→ [Full `StatusChip` documentation][StatusChip]

### PriceViewWidgets

```dart
PriceViewWidgets(
  prefixText: '৳1500',
  price: '999',
  suffixText: '/month',
  priceTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)
```

→ [Full `PriceViewWidgets` documentation][PriceViewWidgets]

### CustomRefreshIndicator

```dart
CustomRefreshIndicator.slivers(
  onRefresh: () async => _loadData(),
  slivers: [
    SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, i) => ListTile(title: Text(items[i])),
    ),
  ],
)
```

→ [Full `CustomRefreshIndicator` documentation][CustomRefreshIndicator]

## Documentation

| Widget | What it is for | Guide |
| --- | --- | --- |
| `GradientAppBar` | An app bar that can be painted with a gradient | [Read][GradientAppBar] |
| `CustomButton` | A button with prefix/center/suffix slots, loading and disabled states | [Read][CustomButton] |
| `CustomDialog` | A confirm / alert dialog with two buttons | [Read][CustomDialog] |
| `CustomTextFieldForm` | An outlined text field with validation built in | [Read][CustomTextFieldForm] |
| `CustomSearchBar` | A search field with a built-in clear button | [Read][CustomSearchBar] |
| `StatusChip` | A small colored label for showing a status | [Read][StatusChip] |
| `PriceViewWidgets` | A price with a currency symbol, unit and discount styling | [Read][PriceViewWidgets] |
| `CustomRefreshIndicator` | Pull-to-refresh that matches the platform | [Read][CustomRefreshIndicator] |
| `UiTokens` | Shared radius, spacing and accent-color constants | [Read][UiTokens] |

## Additional information

Issues and feature requests are welcome on the
[issue tracker](https://github.com/JubaerFaysal/shukhee_ui_component/issues).
If you find a bug, please open an issue with a small code sample that
reproduces it.

Pull requests are welcome. Please run `dart format .`, `flutter analyze` and
`flutter test` before opening one.

[GradientAppBar]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/gradient_app_bar.md
[CustomButton]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/custom_button.md
[CustomDialog]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/custom_dialog.md
[CustomTextFieldForm]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/custom_text_field_form.md
[CustomSearchBar]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/custom_search_bar.md
[StatusChip]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/status_chip.md
[PriceViewWidgets]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/price_view_widgets.md
[CustomRefreshIndicator]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/custom_refresh_indicator.md
[UiTokens]: https://github.com/JubaerFaysal/shukhee_ui_component/blob/main/doc/ui_tokens.md
