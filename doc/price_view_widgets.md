# PriceViewWidgets

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

## Simple usage

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

## Changing the currency

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

## Units and labels

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

## Striking out a price

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

## Formatting numbers

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

## Long prices

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

## All properties

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

## Things worth knowing

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

[← Back to all components](../README.md)
