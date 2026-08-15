# whats_new_kit

A simple Flutter package to show "What's New" releases in your app.

`whats_new_kit` lets you define a list of releases once, and it automatically
tracks which release the user has already seen using `SharedPreferences`. It
ships with a built-in `AlertDialog`, but you can also build your own UI with a
single call to get the latest unseen release.

## Features

- Define releases once and display them as "What's New" screens.
- Automatically tracks the last seen release using `SharedPreferences`.
- Built-in `AlertDialog` UI that marks the release as seen.
- Flexible custom UI via `getLatestUnseenRelease()`.
- `debugMode` to always show the latest release during development.
- Simple item types: `added`, `improved`, and `fixed`.

## Installation

Add `whats_new_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  whats_new_kit: ^0.0.1
```

Or install it with:

```bash
flutter pub add whats_new_kit
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:whats_new_kit/whats_new_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WhatsNew.initialize(
    releases: releases,
  );

  runApp(const MyApp());
}

final releases = [
  WhatsNewRelease(
    id: '1.2.0',
    version: '1.2.0',
    title: "What's New",
    date: 'August 2026',
    items: [
      WhatsNewItem(
        WhatsNewItemType.added,
        'Added a new dashboard.',
      ),
      WhatsNewItem(
        WhatsNewItemType.improved,
        'Improved app performance.',
      ),
      WhatsNewItem(
        WhatsNewItemType.fixed,
        'Fixed notification issues.',
      ),
    ],
  ),
];
```

Then, wherever you want to show the latest release:

```dart
await WhatsNew.showIfNeeded(context);
```

## Usage

### Define releases

A `WhatsNewRelease` represents a single app release. Define your releases in a
list **ordered from newest to oldest**. The package uses this order to determine
which releases the user has not seen yet.

```dart
final releases = [
  WhatsNewRelease(
    id: '1.2.0',
    version: '1.2.0',
    build: '42',
    title: "What's New",
    date: 'August 2026',
    items: [
      WhatsNewItem(
        WhatsNewItemType.added,
        'Added a new dashboard.',
      ),
      WhatsNewItem(
        WhatsNewItemType.improved,
        'Improved app performance.',
      ),
      WhatsNewItem(
        WhatsNewItemType.fixed,
        'Fixed notification issues.',
      ),
    ],
  ),
  WhatsNewRelease(
    id: '1.1.0',
    version: '1.1.0',
    title: "What's New",
    date: 'July 2026',
    items: [
      WhatsNewItem(
        WhatsNewItemType.added,
        'Added dark mode.',
      ),
    ],
  ),
];
```

### Initialize

Initialize the package before running your app. This loads the last seen release
from `SharedPreferences`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WhatsNew.initialize(
    releases: releases,
  );

  runApp(const MyApp());
}
```

### Built-in UI

The simplest approach. `showIfNeeded` shows the latest unseen release in a
built-in `AlertDialog` and automatically marks it as seen.

```dart
await WhatsNew.showIfNeeded(context);
```

<img
  src="https://raw.githubusercontent.com/FahrendraKhoirul/whats_new_kit/main/screenshots/built_in_ui.png"
  width="280"
/>

### Custom UI

If you want to control the UI yourself, get the latest unseen release and mark
it as seen after the user finishes viewing it.

```dart
final release = await WhatsNew.getLatestUnseenRelease();

if (release != null) {
  // Build your own UI using `release`.
  //
  // After the user finishes viewing:
  await WhatsNew.markAsSeen(release.id);
}
```

<img
  src="https://raw.githubusercontent.com/Fahrendrakhoirul/whats_new_kit/main/screenshots/custom_ui.webp"
  width="280"
/>

### Debug mode

Enable `debugMode` to always show the latest release during development. In
debug mode, `markAsSeen` does not persist, so the release keeps showing up.

```dart
await WhatsNew.initialize(
  releases: releases,
  debugMode: true,
);
```

## Release ordering

Releases must be ordered **from newest to oldest**. The first release in the
list is considered the latest. The package compares the stored last seen release
ID against this list to find which releases are newer than what the user has
already seen.

## API overview

| Method | Description |
| ------ | ----------- |
| `WhatsNew.initialize({required List<WhatsNewRelease> releases, bool debugMode = false})` | Initializes the package and loads the last seen release. |
| `WhatsNew.showIfNeeded(BuildContext context)` | Shows the latest unseen release in the built-in dialog and marks it as seen. |
| `WhatsNew.getLatestUnseenRelease()` | Returns the latest release the user has not seen yet, without marking it as seen. Returns `null` when there is nothing to show. |
| `WhatsNew.markAsSeen(String id)` | Marks the release with `id` as seen. No-op in debug mode. |

## Models

### `WhatsNewRelease`

| Parameter | Type | Required | Description |
| --------- | ---- | -------- | ----------- |
| `id` | `String` | Yes | Unique identifier for the release. |
| `version` | `String` | Yes | Version number. |
| `build` | `String?` | No | Optional build number. |
| `title` | `String` | Yes | Dialog title. |
| `date` | `String?` | No | Optional release date. |
| `items` | `List<WhatsNewItem>` | Yes | List of changes in this release. |

### `WhatsNewItem`

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `type` | `WhatsNewItemType` | The type of change. |
| `description` | `String` | A short description of the change. |

## Supported item types

| Type | Label |
| ---- | ----- |
| `WhatsNewItemType.added` | Added |
| `WhatsNewItemType.improved` | Improved |
| `WhatsNewItemType.fixed` | Fixed |

## How it works

1. You define a list of releases, ordered from newest to oldest.
2. `WhatsNew.initialize()` initializes the package.
3. The package stores the last seen release ID using `SharedPreferences`.
4. `WhatsNew.showIfNeeded(context)` uses the built-in `AlertDialog` and
   automatically marks the release as seen.
5. For a custom UI, call `getLatestUnseenRelease()`.
6. After displaying your custom UI, call `markAsSeen(release.id)`.
7. `debugMode: true` makes the latest release always available and prevents
   `markAsSeen()` from persisting.


## The Journey 

This package started from a simple problem: how can Flutter apps show users what's new after an update?

I wrote about the idea, the problems I encountered, and the decisions behind building `whats_new_kit` in this Medium article:

👉 [I Built a “What’s New” System for Flutter + Shorebird](https://medium.com/@fahrendra.khoirul/i-built-a-whats-new-system-for-flutter-shorebird-d5aeaea7304d)

## Contributing

This package is still in its early stage, and there is a lot that can be improved.

Things like more UI variants, customization options, animations, and styling are still open for exploration.

If you have an idea, improvement, or bug fix, contributions are very welcome. Feel free to open an issue or submit a pull request.

Let's make `whats_new_kit` better together.

## License

This project is licensed under the terms of the [LICENSE](./LICENSE) file.
