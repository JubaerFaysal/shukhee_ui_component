# CustomSearchBar

`CustomSearchBar` is a single-line search field in a rounded box, with a search
icon on the right that turns into a clear (✕) button once the user types.

Layout, left to right:

```
[ leading ]  Search products…            [ 🔍 / ✕ ]
  optional     hint / text                 trailing
```

## Simple usage

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

## The clear button

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

## Starting text

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

## Making the icon tappable

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

## A leading widget

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

## Appearance

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

## Keyboard and input rules

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

## All properties

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

## Things worth knowing

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

[← Back to all components](../README.md)
