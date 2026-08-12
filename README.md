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
| `StatusChip` | _Documentation coming soon_ |
| `CustomDialog` | _Documentation coming soon_ |
| `PriceViewWidget` | _Documentation coming soon_ |
| `CustomRefreshIndicator` | _Documentation coming soon_ |
| `CustomSearchBar` | _Documentation coming soon_ |
| `CustomTextFieldForm` | _Documentation coming soon_ |
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

## Additional information

Issues and feature requests are welcome. If you find a bug, please open an issue
with a small code sample that reproduces it.
