# CustomButton

`CustomButton` is a tappable button built from three content slots — a prefix, a
center, and a suffix — so one widget covers text buttons, icon-and-text buttons,
and buttons with something on each edge.

It also handles the two states every real app needs: a **loading** state that
swaps the content for a spinner, and a **disabled** state that greys the button
out. You do not have to build either one yourself.

## Simple usage

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

## Icon and text together

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

## Pushing slots to the edges

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

## Loading state

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

## Disabled state

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

## Colors, border and shape

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

## Spacing

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

## All properties

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

## Things worth knowing

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

[← Back to all components](../README.md)
