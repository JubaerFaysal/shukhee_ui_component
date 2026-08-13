# StatusChip

`StatusChip` is a small rounded label for showing a state — *Active*, *Pending*,
*Cancelled*, *Paid*, and so on. It is the tag you put next to a row in a list or
beside a title on a details page.

The whole chip is themed from **one color**. Pass `color` and the text, the
border and a faded version of the background all follow from it, so a chip always
looks coordinated without you picking three colors by hand.

The chip sizes itself to its text — it is as wide as the label plus the padding.

## Simple usage

```dart
const StatusChip(status: 'Active')
```

That gives you a chip in the package's default accent color.

## Coloring by status

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

## Missing or empty values

If `status` is `null` **or** an empty string, the chip shows `placeholder`
instead, which is `'N/A'` by default. You never get a blank chip:

```dart
const StatusChip(status: null)                          // shows "N/A"
const StatusChip(status: '')                            // shows "N/A"
const StatusChip(status: null, placeholder: 'Unknown')  // shows "Unknown"
```

This means you can pass a nullable field straight from your model without a
null check.

## Adjusting the background

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

## Border

A thin border is drawn in `color` by default. Set `borderWidth: 0` to remove it,
or `borderColor` to make it a different color from the text:

```dart
const StatusChip(status: 'Draft', color: Colors.grey, borderWidth: 0)
```

## Shape and text

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

## All properties

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

## Things worth knowing

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

[← Back to all components](../README.md)
