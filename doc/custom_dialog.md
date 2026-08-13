# CustomDialog

`CustomDialog` is the "are you sure?" dialog — an optional icon, a title, a
message, and two buttons at the bottom. It covers confirmations, alerts, and
success messages without you laying out a `Dialog` by hand.

It stacks its parts in this order, top to bottom:

```
    [ icon ]        ← optional
     Title
   Info text
    [ body ]        ← optional, your own widget
 [Cancel] [Proceed]
```

## Showing a dialog

The widget has a built-in `show()` method, so you do not need `showDialog`
yourself:

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

`infoText` and `positiveAction` are the only required properties. Everything else
has a sensible default — the title falls back to `'Alert'`, the buttons to
`'Proceed'` and `'Cancel'`.

> **Important:** the dialog does **not** close itself when the positive button is
> tapped. Call `Navigator.pop` inside `positiveAction` yourself. This is on
> purpose — it lets you keep the dialog open while an async action runs and show
> a spinner on the button.

`show()` returns the future from `showDialog`, so you can await a result:

```dart
final bool? confirmed = await CustomDialog(
  infoText: 'Log out of your account?',
  positiveText: 'Log out',
  positiveAction: () => Navigator.of(context).pop(true),
  negativeAction: () => Navigator.of(context).pop(false),
).show<bool>(context);
```

You can also use it as a plain widget with Flutter's own `showDialog` if you
prefer.

## The negative button

The left button closes the dialog on its own — if you do not pass
`negativeAction`, it just calls `Navigator.pop`. So a simple cancel needs no code
at all.

To show only one button, set `showNegativeButton: false`. The positive button
then fills the full width — good for an "OK" style alert:

```dart
CustomDialog(
  title: 'Saved',
  infoText: 'Your changes have been saved.',
  positiveText: 'OK',
  showNegativeButton: false,
  positiveAction: () => Navigator.of(context).pop(),
).show(context);
```

## Can the user dismiss it?

`canClose` controls whether the dialog can be escaped without pressing a button.
It defaults to `false`, which means:

- tapping the dark area outside the dialog does nothing, and
- the Android back button does nothing.

Set `canClose: true` for a dialog the user is allowed to walk away from:

```dart
const CustomDialog(
  infoText: 'Rate this app?',
  canClose: true,
  positiveAction: _rate,
)
```

If you need the two to differ, `show()` takes its own `barrierDismissible` which
overrides `canClose` for the tap-outside behaviour only.

## Loading while an action runs

Keep the dialog open, show a spinner on the positive button, then close it when
the work is done. This needs a `StatefulWidget` so you can rebuild:

```dart
CustomDialog(
  title: 'Submit order?',
  infoText: 'Your card will be charged.',
  isPositiveButtonLoading: _isSubmitting,
  positiveAction: () async {
    setState(() => _isSubmitting = true);
    await _submitOrder();
    if (mounted) Navigator.of(context).pop();
  },
  positiveText: 'Submit',
).show(context);
```

Use `isPositiveButtonEnabled: false` to grey the button out — for example until a
checkbox in `body` is ticked.

## Icon and custom body

`icon` goes above the title, `body` goes between the message and the buttons.
`body` can be any widget — a text field, a checkbox, a list:

```dart
CustomDialog(
  icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
  title: 'Low balance',
  infoText: 'Add funds to continue using the service.',
  body: TextField(
    controller: _amountController,
    decoration: const InputDecoration(labelText: 'Amount'),
  ),
  positiveText: 'Add funds',
  positiveAction: _addFunds,
).show(context);
```

If your content might not fit on a small screen, set `scrollable: true` and the
whole dialog content scrolls instead of overflowing.

## Colors

`themeColor` is the single color that themes the dialog — the title, the
positive button's background, the negative button's text, and both button
borders. Set it once and the dialog matches your brand:

```dart
CustomDialog(
  themeColor: Colors.deepPurple,
  title: 'Subscribe',
  infoText: 'Unlock all features for a month.',
  positiveAction: _subscribe,
).show(context);
```

For finer control, each part has its own override — `positiveButtonColor`,
`negativeButtonTextColor`, `buttonBorderColor`, and so on. See the table below.

## Spacing

The gaps between the parts are all adjustable, so you can tighten or loosen the
dialog without rebuilding it:

```dart
CustomDialog(
  infoText: 'Compact dialog.',
  spaceUnderIcon: 8,
  spaceUnderTitle: 8,
  spaceUnderInfoText: 16,
  spaceBetweenButtons: 12,
  positiveAction: _ok,
)
```

## All properties

**Content**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `infoText` | `String` | **required** | The message under the title. |
| `positiveAction` | `VoidCallback` | **required** | Runs when the positive button is tapped. Does not close the dialog for you. |
| `title` | `String?` | `'Alert'` | Heading above the message. |
| `positiveText` | `String?` | `'Proceed'` | Label of the positive button. |
| `negativeText` | `String?` | `'Cancel'` | Label of the negative button. |
| `negativeAction` | `VoidCallback?` | closes the dialog | Runs when the negative button is tapped. |
| `icon` | `Widget?` | `null` | Widget shown above the title. |
| `body` | `Widget?` | `null` | Your own widget between the message and the buttons. |

**Behaviour**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `canClose` | `bool?` | `false` | Allows dismissing by tapping outside or pressing back. |
| `showNegativeButton` | `bool` | `true` | Shows the negative button. When `false` the positive button fills the width. |
| `isPositiveButtonLoading` | `bool` | `false` | Shows a spinner on the positive button and blocks taps. |
| `isPositiveButtonEnabled` | `bool` | `true` | Whether the positive button responds to taps. |
| `scrollable` | `bool` | `false` | Lets the content scroll when it is too tall. |

**Appearance**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `themeColor` | `Color?` | brand color | Themes the title, positive button and button borders. |
| `backgroundColor` | `Color?` | `DialogTheme.backgroundColor` → `ColorScheme.surface` | Dialog background. |
| `borderRadius` | `double` | `defaultRadius` (20) | Corner radius of the dialog. Must be `>= 0`. |
| `elevation` | `double?` | theme default | Shadow depth. Must be `>= 0` when set. |
| `padding` | `EdgeInsetsGeometry?` | `16` horizontal, `24` vertical | Space inside the dialog. |
| `insetPadding` | `EdgeInsets?` | `40` horizontal, `24` vertical | Space between the dialog and the screen edges. |
| `titleStyle` | `TextStyle?` | semi-bold `bodyMedium` in the theme color | Style of the title. |
| `infoTextStyle` | `TextStyle?` | `TextTheme.bodySmall` | Style of the message. |

**Buttons**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `positiveButtonColor` | `Color?` | `themeColor` | Background of the positive button. |
| `positiveButtonTextColor` | `Color?` | `ColorScheme.onPrimary` | Text color of the positive button. |
| `positiveButtonTextStyle` | `TextStyle?` | `bodySmall` in the text color | Text style of the positive button. |
| `negativeButtonColor` | `Color?` | dialog background | Background of the negative button. |
| `negativeButtonTextColor` | `Color?` | `themeColor` | Text color of the negative button. |
| `negativeButtonTextStyle` | `TextStyle?` | `bodySmall` in the text color | Text style of the negative button. |
| `buttonBorderColor` | `Color?` | `themeColor` | Border color of both buttons. |
| `buttonBorderRadius` | `double` | `4` | Corner radius of both buttons. Must be `>= 0`. |
| `buttonPadding` | `EdgeInsetsGeometry?` | `8` on all sides | Space inside each button. |
| `buttonHeight` | `double` | `48` | Height of both buttons. Must be `>= 0`. |

**Spacing**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `spaceBetweenButtons` | `double` | `8` | Gap between the two buttons. |
| `spaceUnderIcon` | `double` | `15` | Gap below the icon. |
| `spaceUnderTitle` | `double` | `15` | Gap below the title. |
| `spaceUnderInfoText` | `double` | `24` | Gap below the message. |
| `spaceUnderBody` | `double` | `20` | Gap below the body. |

All spacing values must be `>= 0`.

## `show()` parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `BuildContext` | **required** | Used to find the navigator. |
| `barrierDismissible` | `bool?` | `canClose` | Whether tapping outside closes the dialog. |
| `barrierColor` | `Color?` | Flutter's default | Color of the area behind the dialog. |
| `useRootNavigator` | `bool` | `true` | Whether to use the root navigator. |
| `routeSettings` | `RouteSettings?` | `null` | Settings for the dialog route. |

## Things worth knowing

- **You close the dialog, not the widget.** `positiveAction` never pops on its
  own; call `Navigator.pop` when you are ready. The negative button *does* pop by
  default.
- **`canClose` blocks the back button too**, not just taps outside. A dialog left
  at the default `false` must be answered with a button.
- **One `themeColor` themes the whole dialog.** Reach for the individual color
  properties only when you want to break that link.
- **Only two things are required** — `infoText` and `positiveAction`. Everything
  else already has a default.

---

[← Back to all components](../README.md)
