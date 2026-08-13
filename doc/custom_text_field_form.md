# CustomTextFieldForm

`CustomTextFieldForm` is an outlined text field for forms. It handles the four
border states — normal, focused, error and disabled — so you do not have to
build an `InputDecoration` for every field in your app.

It works inside a `Form` exactly like Flutter's `TextFormField`, so
`_formKey.currentState!.validate()` picks it up.

## Simple usage

Every property is optional. A field with a label:

```dart
CustomTextFieldForm(
  labelText: 'Full name',
  textController: _nameController,
)
```

`labelText` floats above the field once it has focus or text. `hintText` shows
inside the field while it is empty. You can use either or both.

## Validation

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

## Password fields

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

## Tap-only fields (date pickers and dropdowns)

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

## Multi-line fields

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

## Character limit

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

## Input type and formatting

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

## Colors and shape

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

## All properties

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

## Things worth knowing

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

---

[← Back to all components](../README.md)
