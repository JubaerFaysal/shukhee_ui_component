# GradientAppBar

`GradientAppBar` is a drop-in replacement for Flutter's `AppBar` that can paint a
gradient behind the whole bar. It behaves like a normal app bar in every other
way, so you can give it a title, a back button, action buttons, and a `TabBar` at
the bottom.

It implements `PreferredSizeWidget`, which means you can pass it straight to the
`appBar` property of a `Scaffold`.

## Simple usage

The smallest thing you can write — a plain app bar with a title:

```dart
Scaffold(
  appBar: const GradientAppBar(title: 'Home'),
  body: const Center(child: Text('Hello')),
)
```

## Adding a gradient

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

## Back button

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

## Actions

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

## Custom title widget

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

## Tabs at the bottom

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

## Rounded bottom corners

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

## Taller app bar

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

## All properties

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

## Things worth knowing

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

[← Back to all components](../README.md)
