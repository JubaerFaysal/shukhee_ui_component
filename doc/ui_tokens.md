# UiTokens

`UiTokens` holds the shared design constants the package's widgets fall back to
when you do not override them. It is a plain constants holder — there is nothing
to instantiate and nothing to configure.

```dart
abstract final class UiTokens { ... }
```

Use it when you want your own widgets to line up with the package's defaults,
so a hand-built container matches a `CustomButton` sitting next to it.

## Usage

```dart
Container(
  padding: const EdgeInsets.all(UiTokens.defaultPadding),
  decoration: BoxDecoration(
    color: UiTokens.accentColor,
    borderRadius: BorderRadius.circular(UiTokens.smallRadius),
  ),
  child: const Text('Matches the package defaults'),
)
```

## Constants

| Constant | Type | Value | Used by |
| --- | --- | --- | --- |
| `accentColor` | `Color` | `Color(0xFF00AAD0)` | The default `StatusChip` color, the default `CustomDialog` theme color, and the default focused border of `CustomTextFieldForm`. |
| `defaultRadius` | `double` | `4` | The default corner radius of `CustomButton`, `StatusChip`, `CustomSearchBar`, `CustomTextFieldForm`, and of the `CustomDialog` buttons. |
| `smallRadius` | `double` | `8` | Not used by any widget — available for your own. |
| `largeRadius` | `double` | `12` | Not used by any widget — available for your own. |
| `defaultPadding` | `double` | `16` | Not used by any widget — available for your own. |

## Things worth knowing

- **It is not a theme.** Nothing reads `UiTokens` at runtime to restyle your
  app — the values are compile-time defaults baked into each widget. To change
  a widget's look, pass its properties, or use your `ThemeData` where the
  widget reads from it.
- **The values are `const`**, so they work in `const` constructors.
- **`accentColor` is the brand accent** and the one token you are most likely
  to want to replace with your own color on every widget that exposes it.

---

[← Back to all components](../README.md)
