# CustomRefreshIndicator

`CustomRefreshIndicator` adds pull-to-refresh to a screen and picks the right
look for the platform on its own — the Material spinner on Android, the iOS
spinner on iOS and macOS.

Normally that means writing two code paths. Here you write one, and the widget
chooses.

It **builds the scroll view for you**, so you hand it your content, not a
`ListView`. See the note below before you use it.

## Simple usage

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

## Important: do not pass a scrollable as `child`

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

## Long lists with slivers

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

## Choosing the style

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

## Styling the indicator

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

## Scrolling behaviour

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

## All properties

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

## Things worth knowing

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

[← Back to all components](../README.md)
