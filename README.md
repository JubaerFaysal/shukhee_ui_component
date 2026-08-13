# shukhee_ui_component

A collection of ready-to-use Flutter widgets that keep your app's look consistent
without writing the same UI code again and again.

Every widget is a plain Flutter widget. There is no controller to set up, no
global state, and no theme you are forced to adopt — drop a widget in, pass a few
values, and it works.

## Getting started

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

## Components

| Widget | What it is for |
| --- | --- |
| [`GradientAppBar`](#gradientappbar) | An app bar that can be painted with a gradient |
| [`CustomButton`](#custombutton) | A button with prefix/center/suffix slots, loading and disabled states |
| [`StatusChip`](#statuschip) | A small colored label for showing a status |
| [`CustomDialog`](#customdialog) | A confirm / alert dialog with two buttons |
| [`PriceViewWidgets`](#priceviewwidgets) | A price with a currency symbol, unit and discount styling |
| [`CustomRefreshIndicator`](#customrefreshindicator) | Pull-to-refresh that matches the platform |
| [`CustomSearchBar`](#customsearchbar) | A search field with a built-in clear button |
| [`CustomTextFieldForm`](#customtextfieldform) | An outlined text field with validation built in |
| `UiTokens` | _Documentation coming soon_ |

---

## GradientAppBar

`GradientAppBar` is a drop-in replacement for Flutter's `AppBar` that can paint a
gradient behind the whole bar. It behaves like a normal app bar in every other
way, so you can give it a title, a back button, action buttons, and a `TabBar` at
the bottom.

It implements `PreferredSizeWidget`, which means you can pass it straight to the
`appBar` property of a `Scaffold`.

### Simple usage

The smallest thing you can write — a plain app bar with a title:

```dart
Scaffold(
  appBar: const GradientAppBar(title: 'Home'),
  body: const Center(child: Text('Hello')),
)
```

### Adding a gradient

Pass any Flutter `Gradient` to the `gradient` property:

```dart
Scaffold(
  appBar: const GradientAppBar(
    title: 'Dashboard',
    gradient: LinearGradient(
      colors: [Color(0xFF00AAD0), Color(0xFF005F75)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    foregroundColor: Colors.white,
  ),
  body: const SizedBox.shrink(),
)
```

`foregroundColor` sets the color of the title text and all the icons at once, so
you do not have to style them one by one.

> **Tip:** `gradient` wins over `backgroundColor`. Use `backgroundColor` when you
> want a plain solid color, and `gradient` when you want a blend. Setting both
> just means the gradient is what you see.

### Back button

Set `showBackButton: true` and the app bar draws a back button that calls
`Navigator.pop` when tapped:

```dart
const GradientAppBar(
  title: 'Details',
  showBackButton: true,
)
```

No back button is shown unless you ask for one — this widget never guesses. If
you want your own leading widget instead, pass `leading`; it takes priority and
`showBackButton` is then ignored:

```dart
GradientAppBar(
  title: 'Inbox',
  leading: IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () => Scaffold.of(context).openDrawer(),
  ),
)
```

### Actions

`actions` are the buttons shown on the right side of the bar:

```dart
GradientAppBar(
  title: 'Products',
  actions: [
    IconButton(icon: const Icon(Icons.search), onPressed: _openSearch),
    IconButton(icon: const Icon(Icons.filter_list), onPressed: _openFilter),
  ],
)
```

### Custom title widget

When plain text is not enough, use `titleWidget` instead of `title`. It takes
priority over `title`:

```dart
GradientAppBar(
  gradient: const LinearGradient(colors: [Colors.purple, Colors.indigo]),
  titleWidget: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CircleAvatar(radius: 14, child: Text('J')),
      const SizedBox(width: 8),
      const Text('Jubaer'),
    ],
  ),
)
```

### Tabs at the bottom

Anything that is a `PreferredSizeWidget` can go in `bottom` — usually a `TabBar`.
Its height is added to the app bar's height automatically, so you do not have to
do the math yourself:

```dart
DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: const GradientAppBar(
      title: 'Orders',
      gradient: LinearGradient(colors: [Colors.teal, Colors.green]),
      foregroundColor: Colors.white,
      bottom: TabBar(
        tabs: [Tab(text: 'Active'), Tab(text: 'Completed')],
      ),
    ),
    body: const TabBarView(children: [Text('Active'), Text('Completed')]),
  ),
)
```

The gradient is painted behind the tab bar too, so the whole header looks like
one piece.

### Rounded bottom corners

Use `shape` to change the outline of the bar. The gradient is clipped to the same
shape, so the corners stay clean:

```dart
const GradientAppBar(
  title: 'Profile',
  gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
  ),
)
```

### Taller app bar

`height` controls the toolbar height. It defaults to Flutter's standard
`kToolbarHeight` (56):

```dart
const GradientAppBar(
  title: 'Welcome back',
  height: 96,
)
```

`height` must be zero or greater; a negative value throws an assertion error in
debug mode.

### All properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `String?` | `null` | Text shown as the title. Ignored when `titleWidget` is set. |
| `titleWidget` | `Widget?` | `null` | Custom title widget. Takes priority over `title`. |
| `titleStyle` | `TextStyle?` | `AppBarTheme.titleTextStyle` | Style for the title. Also applies as the default text style of `titleWidget`. |
| `leading` | `Widget?` | `null` | Widget shown before the title. Takes priority over `showBackButton`. |
| `showBackButton` | `bool` | `false` | Shows a back button that calls `Navigator.pop`. Ignored when `leading` is set. |
| `backButtonTooltip` | `String?` | localized default | Tooltip for the back button. |
| `actions` | `List<Widget>?` | `null` | Widgets shown after the title. |
| `backgroundColor` | `Color?` | `AppBarTheme.backgroundColor` | Solid background color. Ignored when `gradient` is set. |
| `gradient` | `Gradient?` | `null` | Gradient painted behind the whole bar, including `bottom`. |
| `foregroundColor` | `Color?` | `AppBarTheme.foregroundColor` | Default color for the title, icons and actions. |
| `iconTheme` | `IconThemeData?` | `null` | Icon theme for `leading` and the back button. |
| `actionsIconTheme` | `IconThemeData?` | `null` | Icon theme for `actions`. |
| `elevation` | `double?` | `AppBarTheme.elevation` | Z-coordinate of the app bar. |
| `shadowColor` | `Color?` | `null` | Color of the shadow below the app bar. |
| `surfaceTintColor` | `Color?` | `Colors.transparent` when a gradient is set | Material 3 elevation tint. Kept transparent by default so it does not wash out the gradient. |
| `centerTitle` | `bool?` | `AppBarTheme.centerTitle` | Whether the title is centered. Platform dependent by default. |
| `bottom` | `PreferredSizeWidget?` | `null` | Widget at the bottom of the bar, usually a `TabBar`. Its height is included in `preferredSize`. |
| `height` | `double` | `kToolbarHeight` | Toolbar height, not counting `bottom`. Must be `>= 0`. |
| `shape` | `ShapeBorder?` | `null` | Shape of the app bar's material and of the gradient behind it. |

### Things worth knowing

- **`gradient` beats `backgroundColor`.** When a gradient is set, the background
  color is ignored and the surface tint is turned off automatically so the
  gradient shows through at its real colors.
- **`titleWidget` beats `title`.** If both are set, only `titleWidget` is drawn.
- **`leading` beats `showBackButton`.** If both are set, only `leading` is drawn.
- **Nothing is implied.** Unlike Flutter's `AppBar`, no leading widget appears on
  its own. If you want a back button or a drawer button, ask for it.
- **Height is handled for you.** `preferredSize` is `height` plus the height of
  `bottom`, so `Scaffold` always reserves the right amount of space.

---

## CustomButton

`CustomButton` is a tappable button built from three content slots — a prefix, a
center, and a suffix — so one widget covers text buttons, icon-and-text buttons,
and buttons with something on each edge.

It also handles the two states every real app needs: a **loading** state that
swaps the content for a spinner, and a **disabled** state that greys the button
out. You do not have to build either one yourself.

### Simple usage

`onTap` is the only required property. Put your label in `centerWidget`:

```dart
CustomButton(
  onTap: () => print('tapped'),
  centerWidget: const Text('Continue'),
)
```

By default the button fills the width it is given and is 56 pixels tall.

> **Note:** because the default width is "as wide as possible", a `CustomButton`
> inside a `Row` needs either a `width` or an `Expanded` around it — a `Row` does
> not bound its children's width.

### Icon and text together

Use `prefixWidget` or `suffixWidget` for the icon. The gap between slots is
controlled by `spacing` (8 by default):

```dart
CustomButton(
  onTap: _save,
  prefixWidget: const Icon(Icons.save),
  centerWidget: const Text('Save changes'),
)
```

Icons pick up the button's `foregroundColor` automatically, so you rarely need to
colour them yourself.

### Pushing slots to the edges

By default all slots sit together in the middle. Set `contentAlignment` to
`MainAxisAlignment.spaceBetween` to pin the prefix and suffix to the two edges:

```dart
CustomButton(
  onTap: _next,
  contentAlignment: MainAxisAlignment.spaceBetween,
  prefixWidget: const Icon(Icons.info_outline),
  centerWidget: const Text('Read the terms'),
  suffixWidget: const Icon(Icons.arrow_forward),
)
```

### Loading state

Set `isLoading: true` and the content is replaced with a small spinner. The
button stops responding to taps while loading, so a user cannot fire your action
twice:

```dart
CustomButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  centerWidget: const Text('Submit'),
)
```

A loading button **keeps its normal colors** — it does not look disabled, it just
looks busy. If you want it to change colour while it works, use
`loadingBackgroundColor` and `loadingForegroundColor`. To show something other
than the default spinner, pass `loadingWidget`:

```dart
CustomButton(
  onTap: _submit,
  isLoading: true,
  loadingWidget: const Text('Sending…'),
  centerWidget: const Text('Submit'),
)
```

### Disabled state

There are two ways to disable the button, and both look and behave the same:

```dart
// 1. Say so explicitly
CustomButton(
  onTap: _submit,
  isEnabled: false,
  centerWidget: const Text('Submit'),
)

// 2. Pass a null callback
CustomButton(
  onTap: _formIsValid ? _submit : null,
  centerWidget: const Text('Submit'),
)
```

A disabled button uses the Material disabled colors (a faded background and
faded content) and drops its elevation to zero. Override them with
`disabledBackgroundColor` and `disabledForegroundColor` if you need to.

### Colors, border and shape

```dart
CustomButton(
  onTap: _delete,
  backgroundColor: Colors.white,
  foregroundColor: Colors.red,
  borderColor: Colors.red,
  borderWidth: 1.5,
  radius: 12,
  elevation: 0,
  centerWidget: const Text('Delete account'),
)
```

- `backgroundColor` defaults to your theme's `ColorScheme.primary`.
- `foregroundColor` defaults to `ColorScheme.onPrimary` and colors both text and
  icons at once.
- A border is only drawn when you set `borderColor` **or** `borderWidth`. Set
  just one and the other gets a sensible default.
- `radius` defaults to `CustomButton.defaultRadius` (4, from `UiTokens`).

### Spacing

`padding` is the space **inside** the button, between its edge and the content.
`margin` is the space **outside** it:

```dart
CustomButton(
  onTap: _go,
  margin: const EdgeInsets.symmetric(horizontal: 16),
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  centerWidget: const Text('Go'),
)
```

### All properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `onTap` | `VoidCallback?` | **required** | Called when tapped. Passing `null` disables the button. |
| `centerWidget` | `Widget?` | `null` | Widget between the prefix and suffix — usually the label. |
| `prefixWidget` | `Widget?` | `null` | Widget shown before `centerWidget`. |
| `suffixWidget` | `Widget?` | `null` | Widget shown after `centerWidget`. |
| `width` | `double?` | fills available width | Width of the button. |
| `height` | `double` | `56` | Height of the button. Must be `>= 0`. |
| `backgroundColor` | `Color?` | `ColorScheme.primary` | Background while enabled. |
| `foregroundColor` | `Color?` | `ColorScheme.onPrimary` | Default color for text and icons. |
| `textStyle` | `TextStyle?` | `TextTheme.labelLarge` | Style for text in the slots. A color set here wins over `foregroundColor`, except while disabled or loading. |
| `radius` | `double` | `defaultRadius` (4) | Corner radius. Must be `>= 0`. |
| `borderColor` | `Color?` | `ColorScheme.primary` when a border is drawn | Border color. No border unless this or `borderWidth` is set. |
| `borderWidth` | `double?` | `1` when a border is drawn | Border width. |
| `elevation` | `double` | `2` | Shadow depth. Drops to `0` while disabled. Must be `>= 0`. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Space outside the button. |
| `padding` | `EdgeInsetsGeometry?` | `16` horizontal, `8` vertical | Space inside the button. |
| `contentAlignment` | `MainAxisAlignment` | `center` | How the slots are spread along the button. |
| `spacing` | `double` | `8` | Gap between neighbouring slots. Must be `>= 0`. |
| `splashColor` | `Color?` | `null` | Ripple color on tap. |
| `highlightColor` | `Color?` | `null` | Color while held down. |
| `isLoading` | `bool` | `false` | Replaces the content with a spinner and blocks taps. |
| `isEnabled` | `bool` | `true` | Whether the button responds to taps. |
| `loadingWidget` | `Widget?` | centred `CircularProgressIndicator` | Shown in place of the content while loading. |
| `loadingBackgroundColor` | `Color?` | `backgroundColor` | Background while loading. |
| `loadingForegroundColor` | `Color?` | `foregroundColor` | Spinner / content color while loading. |
| `disabledBackgroundColor` | `Color?` | `onSurface` at 12% | Background while disabled. |
| `disabledForegroundColor` | `Color?` | `onSurface` at 38% | Text and icon color while disabled. |

### Things worth knowing

- **Loading is not disabled.** A loading button ignores taps but keeps its normal
  colors. A disabled button changes color and flattens to zero elevation. That is
  the difference between "working on it" and "not available".
- **Two ways to disable, same result.** `isEnabled: false` and `onTap: null` are
  interchangeable; either one wins over `isLoading` for how the button looks.
- **The button is accessible by default.** It reports itself to screen readers as
  a button, and reports whether it is currently tappable.
- **Give it a width inside a `Row`.** The default width is "fill the space
  available", which is unbounded in a `Row` — use `width` or wrap in `Expanded`.

---

## StatusChip

`StatusChip` is a small rounded label for showing a state — *Active*, *Pending*,
*Cancelled*, *Paid*, and so on. It is the tag you put next to a row in a list or
beside a title on a details page.

The whole chip is themed from **one color**. Pass `color` and the text, the
border and a faded version of the background all follow from it, so a chip always
looks coordinated without you picking three colors by hand.

The chip sizes itself to its text — it is as wide as the label plus the padding.

### Simple usage

```dart
const StatusChip(status: 'Active')
```

That gives you a chip in the package's default accent color.

### Coloring by status

This is the normal way to use it — map your status to a color:

```dart
Color colorFor(String status) {
  switch (status) {
    case 'Active':
      return Colors.green;
    case 'Pending':
      return Colors.orange;
    case 'Cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

StatusChip(
  status: order.status,
  color: colorFor(order.status),
)
```

One color gives you dark text, a matching border, and a light tinted background.

### Missing or empty values

If `status` is `null` **or** an empty string, the chip shows `placeholder`
instead, which is `'N/A'` by default. You never get a blank chip:

```dart
const StatusChip(status: null)                          // shows "N/A"
const StatusChip(status: '')                            // shows "N/A"
const StatusChip(status: null, placeholder: 'Unknown')  // shows "Unknown"
```

This means you can pass a nullable field straight from your model without a
null check.

### Adjusting the background

The background is `color` faded to 20% by default. Change how strong that tint
is with `backgroundOpacity` (a value from 0 to 1):

```dart
const StatusChip(
  status: 'Paid',
  color: Colors.green,
  backgroundOpacity: 0.08, // barely tinted
)
```

For a background that has nothing to do with `color`, set `backgroundColor` —
it replaces the tint completely:

```dart
const StatusChip(
  status: 'Featured',
  color: Colors.white,
  backgroundColor: Colors.black,
)
```

### Border

A thin border is drawn in `color` by default. Set `borderWidth: 0` to remove it,
or `borderColor` to make it a different color from the text:

```dart
const StatusChip(status: 'Draft', color: Colors.grey, borderWidth: 0)
```

### Shape and text

```dart
const StatusChip(
  status: 'Delivered',
  color: Colors.teal,
  radius: 20, // fully rounded pill
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  textStyle: TextStyle(fontSize: 11, letterSpacing: 0.5),
)
```

`textStyle` is merged on top of the default, so you can change just the parts you
care about and leave the rest alone.

### All properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `status` | `String?` | `null` | The text to show. Falls back to `placeholder` when `null` or empty. |
| `placeholder` | `String` | `'N/A'` | Shown when `status` is `null` or empty. |
| `color` | `Color` | `defaultColor` (the brand accent) | Drives the text, the border, and the tinted background. |
| `backgroundColor` | `Color?` | `color` at `backgroundOpacity` | A solid background that replaces the tint. |
| `backgroundOpacity` | `double` | `0.2` | How strongly `color` tints the background. Must be between `0` and `1`. Ignored when `backgroundColor` is set. |
| `borderColor` | `Color?` | `color` | Border color. |
| `borderWidth` | `double` | `0.5` | Border thickness. `0` removes the border. Must be `>= 0`. |
| `radius` | `double` | `defaultRadius` (4) | Corner radius. Must be `>= 0`. |
| `padding` | `EdgeInsetsGeometry?` | `8` horizontal, `4` vertical | Space between the border and the text. |
| `textStyle` | `TextStyle?` | `TextTheme.labelLarge`, semi-bold, in `color` | Merged over the default text style. |

### Things worth knowing

- **One color does the work.** Setting `color` alone gives you a matching text
  color, border and background tint. Override the others only when you want to
  break that link.
- **Empty counts as missing.** Both `null` and `''` fall back to `placeholder`,
  so an empty API field will not render an empty chip.
- **`textStyle` wins over `color` for text.** It is merged last, so a color set
  inside `textStyle` overrides `color` for the label — the border and background
  still follow `color`.
- **It hugs its text.** The chip has no fixed width; wrap it in a `SizedBox` if
  you need a set of chips to line up.

---

## CustomDialog

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

### Showing a dialog

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

### The negative button

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

### Can the user dismiss it?

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

### Loading while an action runs

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

### Icon and custom body

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

### Colors

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

### Spacing

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

### All properties

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

### `show()` parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `BuildContext` | **required** | Used to find the navigator. |
| `barrierDismissible` | `bool?` | `canClose` | Whether tapping outside closes the dialog. |
| `barrierColor` | `Color?` | Flutter's default | Color of the area behind the dialog. |
| `useRootNavigator` | `bool` | `true` | Whether to use the root navigator. |
| `routeSettings` | `RouteSettings?` | `null` | Settings for the dialog route. |

### Things worth knowing

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

## PriceViewWidgets

`PriceViewWidgets` renders a price as a single line of text, with the currency
symbol, the amount, an optional original price, and an optional unit — each with
its own style.

It is one `Text` widget under the hood, so the parts wrap, align and truncate
together instead of drifting apart the way a hand-built `Row` of `Text`s does.

The parts appear in this order:

```
  ৳1,200      ৳999    /month
  └ prefix    └ symbol + price   └ suffix
```

### Simple usage

`price` and `priceTextStyle` are required. The currency symbol defaults to the
Bangladeshi taka sign (`৳`):

```dart
PriceViewWidgets(
  price: '999',
  priceTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)
// ৳999
```

`price` is a `String`, not a number — the widget prints exactly what you give it
and never rounds or reformats on its own. Format the value yourself, or use
`formatter` below.

### Changing the currency

```dart
PriceViewWidgets(
  price: '49.99',
  currencySymbol: r'$',
  priceTextStyle: _style,
)
// $49.99
```

Pass `null` or an empty string to show the amount with no symbol at all.

To make the symbol smaller than the amount — a common price style — give it its
own style:

```dart
PriceViewWidgets(
  price: '999',
  priceTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  currencyTextStyle: const TextStyle(fontSize: 13),
)
```

### Units and labels

`suffixText` goes after the amount — good for units like `/kg` or `/month`:

```dart
PriceViewWidgets(
  price: '120',
  suffixText: '/kg',
  priceTextStyle: _priceStyle,
  suffixTextStyle: const TextStyle(fontSize: 12, color: Colors.grey),
)
// ৳120 /kg
```

`prefixText` goes at the very front, before the currency symbol. It is usually
the original price in a discount:

```dart
PriceViewWidgets(
  prefixText: '৳1500',
  price: '999',
  priceTextStyle: _priceStyle,
  prefixTextStyle: const TextStyle(
    fontSize: 13,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
  ),
)
// ৳1500 ৳999
```

Note that the prefix has no currency symbol of its own — include it in the
string, as above.

### Striking out a price

`strikeThrough: true` draws a line through **the currency symbol and the
amount**:

```dart
PriceViewWidgets(
  price: '1500',
  strikeThrough: true,
  strikeThroughColor: Colors.red,
  priceTextStyle: _oldPriceStyle,
)
```

It deliberately does not touch `prefixText` or `suffixText`, so a struck-out
price can still carry a readable unit next to it. To strike the prefix, put the
decoration in `prefixTextStyle` as shown above.

### Formatting numbers

`formatter` is called on `price` and on `prefixText` just before they are drawn.
Use it for thousand separators, digit localisation, or anything else — the widget
never reformats values by itself:

```dart
PriceViewWidgets(
  price: '1200000',
  priceTextStyle: _style,
  formatter: (value) => NumberFormat('#,##0').format(num.parse(value)),
)
// ৳1,200,000
```

Returning `null` from the formatter leaves the value untouched, so an existing
app-side converter that may not handle every input can be passed in directly.
`suffixText` is never formatted.

### Long prices

Everything is one line by default and clipped if it does not fit. Change that
with `maxLines` and `overflow`:

```dart
PriceViewWidgets(
  price: '999',
  suffixText: 'per person per night',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  priceTextStyle: _style,
)
```

### All properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `price` | `String` | **required** | The amount, exactly as it should read. |
| `priceTextStyle` | `TextStyle` | **required** | Style of the amount, and the fallback style for every other part. |
| `currencySymbol` | `String?` | `'৳'` | Symbol before the amount. `null` or `''` hides it. |
| `currencyTextStyle` | `TextStyle?` | `priceTextStyle` | Style of the currency symbol. |
| `prefixText` | `String?` | `null` | Text at the very front, usually the original price. Formatted by `formatter`. |
| `prefixTextStyle` | `TextStyle?` | `priceTextStyle` | Style of the prefix. Not affected by `strikeThrough`. |
| `suffixText` | `String?` | `null` | Text after the amount, usually a unit. Never formatted. |
| `suffixTextStyle` | `TextStyle?` | `priceTextStyle` | Style of the suffix. |
| `strikeThrough` | `bool` | `false` | Strikes through the currency symbol and the amount only. |
| `strikeThroughColor` | `Color?` | the text color | Color of the strike-through line. |
| `spacing` | `double` | `2` | Gap between the prefix, the symbol and the amount. Must be `>= 0`. |
| `suffixSpacing` | `double` | `5` | Gap before the suffix. Must be `>= 0`. |
| `textAlign` | `TextAlign?` | `TextAlign.start` | Horizontal alignment of the line. |
| `maxLines` | `int` | `1` | Maximum number of lines. Must be `> 0`. |
| `overflow` | `TextOverflow` | `TextOverflow.clip` | What happens to text past `maxLines`. |
| `formatter` | `String? Function(String)?` | `null` | Transforms `price` and `prefixText` before drawing. |

### Things worth knowing

- **The class name is plural** — `PriceViewWidgets`, not `PriceViewWidget`.
- **`price` is a `String`.** Nothing is rounded, padded or grouped unless you do
  it, or supply a `formatter`.
- **`priceTextStyle` is the fallback for everything.** Any part without its own
  style inherits it, so a single style gets you a consistent line.
- **`strikeThrough` covers the symbol and amount, not the prefix or suffix.**
  Strike the prefix through `prefixTextStyle` instead.
- **Empty parts disappear cleanly.** A `null` or empty prefix, symbol or suffix
  takes its spacing with it — no stray gaps.

---

## CustomRefreshIndicator

`CustomRefreshIndicator` adds pull-to-refresh to a screen and picks the right
look for the platform on its own — the Material spinner on Android, the iOS
spinner on iOS and macOS.

Normally that means writing two code paths. Here you write one, and the widget
chooses.

It **builds the scroll view for you**, so you hand it your content, not a
`ListView`. See the note below before you use it.

### Simple usage

```dart
CustomRefreshIndicator(
  onRefresh: () async {
    await _loadData();
  },
  child: Column(
    children: const [
      ListTile(title: Text('First')),
      ListTile(title: Text('Second')),
    ],
  ),
)
```

`onRefresh` must return a `Future`. The spinner stays on screen until that future
completes, so just `await` your network call and the indicator handles itself.

### Important: do not pass a scrollable as `child`

The widget wraps `child` in its own `CustomScrollView`. Passing a `ListView`,
`GridView` or `SingleChildScrollView` as the child puts one scroll view inside
another, which breaks the pull gesture.

```dart
// ❌ Wrong — a scrollable inside a scrollable
CustomRefreshIndicator(
  onRefresh: _refresh,
  child: ListView(children: items),
)

// ✅ Right — use the .slivers constructor for lists
CustomRefreshIndicator.slivers(
  onRefresh: _refresh,
  slivers: [
    SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, i) => ListTile(title: Text(items[i])),
    ),
  ],
)
```

Rule of thumb: use `child` for a screen of fixed content (a form, a details
page), and `.slivers` for anything list-shaped or long.

### Long lists with slivers

The `.slivers` constructor takes a list of slivers, so you can mix headers,
grids and lists on one refreshable screen:

```dart
CustomRefreshIndicator.slivers(
  onRefresh: _refresh,
  slivers: [
    const SliverAppBar(title: Text('Feed'), floating: true),
    SliverList.builder(
      itemCount: posts.length,
      itemBuilder: (context, i) => PostCard(post: posts[i]),
    ),
  ],
)
```

Everything else works exactly the same on both constructors.

### Choosing the style

`style` decides which indicator is drawn:

| Value | Behaviour |
| --- | --- |
| `RefreshIndicatorStyle.adaptive` | **Default.** iOS spinner on iOS and macOS, Material spinner everywhere else. |
| `RefreshIndicatorStyle.material` | Always the Material spinner. |
| `RefreshIndicatorStyle.cupertino` | Always the iOS spinner. |

```dart
CustomRefreshIndicator(
  onRefresh: _refresh,
  style: RefreshIndicatorStyle.material, // same look on every platform
  child: _content,
)
```

Pick `material` when you want your app to look identical everywhere, and leave it
on `adaptive` when you want it to feel native.

The platform is read from `Theme.of(context).platform`, so setting
`ThemeData.platform` in tests or previews switches the indicator too.

### Styling the indicator

Which properties apply depends on which indicator is showing:

```dart
CustomRefreshIndicator(
  onRefresh: _refresh,
  // Material only
  color: Colors.teal,
  backgroundColor: Colors.white,
  displacement: 60,
  // Cupertino only
  triggerPullDistance: 140,
  indicatorExtent: 70,
  child: _content,
)
```

Setting all of them is harmless — each one is ignored by the style it does not
belong to — so an adaptive screen can be tuned for both platforms at once.

For a fully custom iOS spinner, pass `cupertinoIndicatorBuilder`.

### Scrolling behaviour

The scroll view bounces by default (`BouncingScrollPhysics`), and is always
scrollable even when the content is short — otherwise a nearly empty screen could
not be pulled to refresh. Override it with `physics` if you need something else:

```dart
CustomRefreshIndicator(
  onRefresh: _refresh,
  physics: const AlwaysScrollableScrollPhysics(),
  child: _content,
)
```

Pass a `scrollController` if you need to read or drive the scroll position — to
jump back to the top after a refresh, for example.

### All properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `onRefresh` | `Future<void> Function()` | **required** | Runs on pull. The spinner shows until the future completes. |
| `child` | `Widget?` | — | Content for the default constructor. Must **not** be a scrollable. |
| `slivers` | `List<Widget>?` | — | Slivers for the `.slivers` constructor. |
| `style` | `RefreshIndicatorStyle` | `adaptive` | Which indicator to draw. |
| `scrollController` | `ScrollController?` | `null` | Controller for the scroll view. |
| `physics` | `ScrollPhysics?` | `defaultPhysics` (bouncing, always scrollable) | Scroll physics. |
| `color` | `Color?` | theme default | Spinner color. **Material only.** |
| `backgroundColor` | `Color?` | theme default | Circle behind the spinner. **Material only.** |
| `displacement` | `double` | `40` | How far down the spinner settles. **Material only.** |
| `triggerPullDistance` | `double` | `120` | How far to pull before a refresh fires. **Cupertino only.** |
| `indicatorExtent` | `double` | `60` | Space the spinner occupies while refreshing. **Cupertino only.** |
| `cupertinoIndicatorBuilder` | `RefreshControlIndicatorBuilder?` | the standard iOS spinner | Builds a custom iOS indicator. **Cupertino only.** |

### Things worth knowing

- **It creates the scroll view.** Never give it a `ListView` or
  `SingleChildScrollView` as `child` — use `.slivers` instead.
- **`onRefresh` controls the spinner.** It disappears when your future
  completes, so do not resolve early or the user will see the spinner vanish
  before the data lands.
- **Style properties are per-platform, and the unused ones are ignored.** Set
  both sets and each platform picks what it needs.
- **The view always scrolls**, even with little content, so pull-to-refresh keeps
  working on a short or empty screen.

---

## CustomSearchBar

`CustomSearchBar` is a single-line search field in a rounded box, with a search
icon on the right that turns into a clear (✕) button once the user types.

Layout, left to right:

```
[ leading ]  Search products…            [ 🔍 / ✕ ]
  optional     hint / text                 trailing
```

### Simple usage

`hintText` is the only required property:

```dart
CustomSearchBar(
  hintText: 'Search products',
  onTextChanged: (value) => setState(() => _query = value),
)
```

`onTextChanged` fires on every keystroke. `onSubmitted` fires when the user
presses the search key on the keyboard — use it when searching is expensive and
you do not want to hit the server on every letter:

```dart
CustomSearchBar(
  hintText: 'Search',
  onSubmitted: (value) => _runSearch(value),
)
```

### The clear button

The trailing icon swaps to a ✕ as soon as there is text, and tapping it empties
the field.

**This only works when you pass a `textEditingController`** — the widget needs
one to watch the text and to clear it:

```dart
final _controller = TextEditingController();

CustomSearchBar(
  hintText: 'Search',
  textEditingController: _controller,
  onTextChanged: _onQueryChanged,
  onClear: () => setState(() => _results = []),
)
```

Without a controller the search icon simply stays put. Set
`showClearButton: false` if you have a controller but want the icon to stay a
search icon anyway.

When the user taps clear, three things happen in order: the field is emptied,
`onTextChanged` is called with `''`, and then `onClear` runs. So your existing
`onTextChanged` handler already resets the results — `onClear` is for extra work
on top, like closing a suggestions panel.

Remember to dispose the controller in your `State.dispose`.

### Starting text

Use `initialValue` for a starting value when you do not need a controller:

```dart
CustomSearchBar(
  hintText: 'Search',
  initialValue: 'shoes',
  onTextChanged: _onQueryChanged,
)
```

You cannot pass `textEditingController` and `initialValue` together — that throws
an assertion error. With a controller, set the starting text on the controller
instead: `TextEditingController(text: 'shoes')`.

### Making the icon tappable

By default the search icon is decoration. Give it `onIconTap` to make it a
button:

```dart
CustomSearchBar(
  hintText: 'Search',
  textEditingController: _controller,
  onIconTap: () => _runSearch(_controller.text),
)
```

Swap the icon itself with `icon` — for a filter or scan button, say:

```dart
CustomSearchBar(
  hintText: 'Search',
  icon: const Icon(Icons.tune),
  onIconTap: _openFilters,
)
```

Note that the clear button replaces whatever `icon` you set while there is text.

### A leading widget

`leading` sits before the text field — handy for a back button on a dedicated
search screen:

```dart
CustomSearchBar(
  hintText: 'Search',
  autoFocus: true,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Navigator.of(context).pop(),
  ),
)
```

`autoFocus: true` opens the keyboard as soon as the screen appears, which is what
you usually want on a search page.

### Appearance

```dart
CustomSearchBar(
  hintText: 'Search',
  backgroundColor: Colors.grey.shade100,
  borderColor: Colors.grey.shade300,
  borderRadius: 28, // pill shape
  height: 48,
  margin: const EdgeInsets.symmetric(horizontal: 16),
  iconColor: Colors.grey,
)
```

The border is transparent by default, so the bar reads as a filled box until you
set `borderColor`.

### Keyboard and input rules

```dart
CustomSearchBar(
  hintText: 'Search by phone number',
  inputType: TextInputType.phone,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  textInputAction: TextInputAction.search,
)
```

`textInputAction` is already `TextInputAction.search`, so the keyboard shows a
search key out of the box.

Tapping outside the bar closes the keyboard by default. Set
`unfocusOnTapOutside: false` to keep it open — for example when your suggestions
list is tappable and should not dismiss the keyboard.

### All properties

**Content and callbacks**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `hintText` | `String` | **required** | Placeholder shown when the field is empty. |
| `textEditingController` | `TextEditingController?` | `null` | Controls the text. **Required for the clear button.** |
| `initialValue` | `String?` | `null` | Starting text. Cannot be combined with a controller. |
| `focusNode` | `FocusNode?` | `null` | Controls focus from outside. |
| `onTextChanged` | `ValueChanged<String>?` | `null` | Fires on every change, including a clear. |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Fires when the keyboard's search key is pressed. |
| `onClear` | `VoidCallback?` | `null` | Fires after the clear button empties the field. |
| `onIconTap` | `VoidCallback?` | `null` | Makes the trailing icon tappable. |

**Appearance**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `textStyle` | `TextStyle?` | `TextTheme.bodySmall` | Style of the typed text. |
| `hintTextStyle` | `TextStyle?` | `bodySmall` in the theme's hint color | Style of the hint. |
| `backgroundColor` | `Color?` | `ColorScheme.surface` | Fill color of the bar. |
| `borderColor` | `Color?` | transparent | Border color. |
| `borderWidth` | `double` | `1` | Border thickness. Must be `>= 0`. |
| `borderRadius` | `double` | `defaultRadius` (4) | Corner radius. Must be `>= 0`. |
| `icon` | `Widget?` | search icon | Trailing icon while the field is empty. |
| `iconColor` | `Color?` | the theme's hint color | Color of the default and clear icons. |
| `iconSize` | `double` | `24` | Size of the default and clear icons. |
| `showClearButton` | `bool` | `true` | Whether the ✕ appears once there is text. |
| `leading` | `Widget?` | `null` | Widget before the text field. |
| `height` | `double?` | `56` | Height of the bar. `null` sizes to the content. Must be `>= 0`. |
| `margin` | `EdgeInsetsGeometry?` | `null` | Space outside the bar. |
| `contentPadding` | `EdgeInsetsGeometry?` | `15` horizontal | Space inside the bar. |
| `spacing` | `double` | `10` | Gap between the leading widget, the field and the icon. Must be `>= 0`. |

**Behaviour**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `bool` | `true` | Whether the field accepts input. Also hides the clear button when `false`. |
| `autoFocus` | `bool` | `false` | Opens the keyboard when the bar appears. |
| `inputType` | `TextInputType?` | `null` | Keyboard type. |
| `textInputAction` | `TextInputAction` | `TextInputAction.search` | The keyboard's action key. |
| `inputFormatters` | `List<TextInputFormatter>?` | `null` | Rules limiting what can be typed. |
| `unfocusOnTapOutside` | `bool` | `true` | Closes the keyboard when the user taps elsewhere. |

### Things worth knowing

- **No controller, no clear button.** The ✕ needs a `textEditingController` to
  watch and clear the text. This is the most common surprise with this widget.
- **Controller or `initialValue`, never both.** Passing both throws an assertion
  error. With a controller, set the starting text on the controller.
- **Clearing calls `onTextChanged('')` before `onClear`.** Your normal search
  handler already sees the empty query, so `onClear` is only for extra cleanup.
- **Autocorrect is always off**, which is what you want for search terms.
- **The clear button hides when `enabled` is `false`**, so a disabled bar cannot
  be emptied by accident.

---

## CustomTextFieldForm

`CustomTextFieldForm` is an outlined text field for forms. It handles the four
border states — normal, focused, error and disabled — so you do not have to
build an `InputDecoration` for every field in your app.

It works inside a `Form` exactly like Flutter's `TextFormField`, so
`_formKey.currentState!.validate()` picks it up.

### Simple usage

Every property is optional. A field with a label:

```dart
CustomTextFieldForm(
  labelText: 'Full name',
  textController: _nameController,
)
```

`labelText` floats above the field once it has focus or text. `hintText` shows
inside the field while it is empty. You can use either or both.

### Validation

Pass a `validator` that returns an error message, or `null` when the value is
fine:

```dart
CustomTextFieldForm(
  labelText: 'Email',
  textController: _emailController,
  inputType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email';
    return null;
  },
)
```

By default the field validates **as the user types**, but only after they have
touched it — so a form does not open covered in red errors. Change that with
`autovalidateMode`:

```dart
CustomTextFieldForm(
  labelText: 'Email',
  autovalidateMode: AutovalidateMode.disabled, // only on validate()
  validator: _validateEmail,
)
```

A full form looks like this:

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      CustomTextFieldForm(
        labelText: 'Email',
        textController: _emailController,
        validator: _validateEmail,
      ),
      const SizedBox(height: 16),
      CustomTextFieldForm(
        labelText: 'Password',
        textController: _passwordController,
        hideText: true,
        validator: _validatePassword,
      ),
      const SizedBox(height: 24),
      CustomButton(
        onTap: () {
          if (_formKey.currentState!.validate()) _submit();
        },
        centerWidget: const Text('Log in'),
      ),
    ],
  ),
)
```

### Password fields

`hideText: true` masks the input. An obscured field must stay single-line, so
`maxLines` has to remain `1` — anything else throws an assertion error.

To add a show/hide toggle, use `suffixIcon` and flip a flag in your `State`:

```dart
CustomTextFieldForm(
  labelText: 'Password',
  hideText: _obscured,
  suffixIcon: IconButton(
    icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
    onPressed: () => setState(() => _obscured = !_obscured),
  ),
)
```

### Tap-only fields (date pickers and dropdowns)

Passing `onTap` automatically makes the field **read-only**, so tapping it opens
your picker instead of the keyboard. This is the usual pattern for dates:

```dart
CustomTextFieldForm(
  labelText: 'Date of birth',
  textController: _dateController,
  suffixIcon: const Icon(Icons.calendar_today),
  onTap: () async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );
    if (picked != null) {
      _dateController.text = DateFormat('dd MMM yyyy').format(picked);
    }
  },
)
```

If you want a tap callback *and* a working keyboard, set `readOnly: false`
explicitly to override this.

### Multi-line fields

```dart
CustomTextFieldForm(
  labelText: 'Notes',
  minLines: 3,
  maxLines: 6,
  textCapitalization: TextCapitalization.sentences,
)
```

The field starts three lines tall and grows to six as the user types. For a box
that never grows, set `minLines` and `maxLines` to the same number.

### Character limit

`maxLength` both enforces the limit and shows a counter under the field. Hide the
counter but keep the limit with `showCounter: false`:

```dart
CustomTextFieldForm(
  labelText: 'Bio',
  maxLength: 150,
  showCounter: false,
  maxLines: 4,
)
```

### Input type and formatting

```dart
CustomTextFieldForm(
  labelText: 'Phone',
  inputType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(11),
  ],
  prefixIcon: const Icon(Icons.phone),
)
```

`textInputAction` controls the keyboard's action key — use
`TextInputAction.next` to move to the following field and `TextInputAction.done`
on the last one.

### Colors and shape

Each border state has its own color:

```dart
CustomTextFieldForm(
  labelText: 'Search',
  backgroundColor: Colors.grey.shade50,
  borderColor: Colors.grey.shade300,   // normal
  focusedBorderColor: Colors.blue,     // while focused
  errorBorderColor: Colors.red,        // when the validator fails
  disabledBorderColor: Colors.grey,    // while disabled
  borderRadius: 12,
  borderWidth: 1.5,
)
```

The field is transparent unless you set `backgroundColor`, which turns the fill
on for you.

Use `isDense: true` for a shorter field when you are packing many into one
screen, and `contentPadding` for exact control.

### All properties

**Value and callbacks**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `textController` | `TextEditingController?` | `null` | Controls the text. |
| `initialValue` | `String?` | `null` | Starting text. Cannot be combined with a controller. |
| `focusNode` | `FocusNode?` | `null` | Controls focus from outside. |
| `onChange` | `ValueChanged<String>?` | `null` | Fires on every change. |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Fires when the keyboard's action key is pressed. |
| `onTap` | `VoidCallback?` | `null` | Fires when tapped. **Makes the field read-only unless `readOnly` says otherwise.** |

**Labels and icons**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `labelText` | `String?` | `null` | Label that floats above the field. |
| `labelStyle` | `TextStyle?` | `bodySmall` in the hint color | Style of the label. |
| `hintText` | `String?` | `null` | Placeholder inside an empty field. |
| `hintStyle` | `TextStyle?` | `bodySmall` in the hint color | Style of the hint. |
| `errorTextStyle` | `TextStyle?` | `labelLarge` in the error color | Style of the validation message. |
| `prefixIcon` | `Widget?` | `null` | Widget inside the field, before the text. |
| `suffixIcon` | `Widget?` | `null` | Widget inside the field, after the text. |
| `textStyle` | `TextStyle?` | `TextTheme.bodyMedium` | Style of the typed text. |
| `textAlign` | `TextAlign` | `TextAlign.start` | Horizontal alignment of the text. |

**Validation and limits**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `validator` | `String? Function(String?)?` | `null` | Returns an error message, or `null` when valid. |
| `autovalidateMode` | `AutovalidateMode` | `onUserInteraction` | When validation runs. |
| `maxLength` | `int?` | `null` | Maximum characters. Also shows a counter. |
| `showCounter` | `bool` | `true` | Whether the character counter is shown. |
| `minLines` | `int?` | `null` | Minimum visible lines. |
| `maxLines` | `int?` | `1` | Maximum visible lines. Must be `1` when `hideText` is `true`. |

**Behaviour**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `hideText` | `bool` | `false` | Masks the text, for passwords. |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `readOnly` | `bool?` | `true` when `onTap` is set | Whether typing is blocked while the field stays tappable. |
| `autofocus` | `bool` | `false` | Opens the keyboard when the field appears. |
| `inputType` | `TextInputType?` | `null` | Keyboard type. |
| `textInputAction` | `TextInputAction?` | `null` | The keyboard's action key. |
| `textCapitalization` | `TextCapitalization` | `none` | Automatic capitalisation rule. |
| `inputFormatters` | `List<TextInputFormatter>?` | `null` | Rules limiting what can be typed. |
| `unfocusOnTapOutside` | `bool` | `true` | Closes the keyboard when the user taps elsewhere. |

**Appearance**

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `backgroundColor` | `Color?` | transparent | Fill color. Setting it turns the fill on. |
| `borderColor` | `Color?` | `ColorScheme.outline` | Border in the normal state. |
| `focusedBorderColor` | `Color?` | brand accent | Border while focused. |
| `errorBorderColor` | `Color?` | `ColorScheme.error` | Border when validation fails. Also colors the message. |
| `disabledBorderColor` | `Color?` | the theme's disabled color | Border while disabled. |
| `borderWidth` | `double` | `1` | Border thickness. Must be `>= 0`. |
| `borderRadius` | `double` | `defaultRadius` (4) | Corner radius. Must be `>= 0`. |
| `isDense` | `bool` | `false` | Makes the field shorter. |
| `contentPadding` | `EdgeInsetsGeometry?` | Flutter's default | Space inside the field. |
| `cursorColor` | `Color?` | theme default | Color of the caret. |
| `cursorWidth` | `double` | `2` | Width of the caret. |
| `cursorHeight` | `double?` | line height | Height of the caret. |

### Things worth knowing

- **`onTap` makes the field read-only.** That is what you want for date pickers
  and dropdowns. Pass `readOnly: false` if you want a tap callback *and* typing.
- **Errors appear as the user types, not before.** The default
  `onUserInteraction` mode keeps a fresh form clean and still gives quick
  feedback.
- **A password field must be single-line.** `hideText: true` with `maxLines`
  other than `1` throws an assertion error.
- **Controller or `initialValue`, never both** — passing both throws an assertion
  error.
- **No background unless you ask.** The fill turns on only when you set
  `backgroundColor`.
- **`errorBorderColor` colors the message too**, so the border and the text stay
  in step.

## Additional information

Issues and feature requests are welcome. If you find a bug, please open an issue
with a small code sample that reproduces it.
