# isDuo

Detect an open Duo from the safe-area inset left by the hinge.

| Layout | Inset |
| --- | --- |
| Duo open landscape | `trailing == 84` |
| Duo open portrait | `top == 82` |

Any other insets are `.notDuo`. If both values match, landscape wins.

## Add the package

In Xcode: **File > Add Package Dependencies**, then enter:

```
https://github.com/AnhLeeJJ/isDuo.git
```

Or add it in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/AnhLeeJJ/isDuo.git", branch: "main"),
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["isDuo"]
    ),
]
```

## SwiftUI

Read the safe area from a `GeometryReader` and use the `EdgeInsets` helpers.

```swift
import SwiftUI
import isDuo

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let insets = proxy.safeAreaInsets

            if insets.isDuoOpenLandscape {
                Text("Duo open landscape")
            } else if insets.isDuoOpenPortrait {
                Text("Duo open portrait")
            } else {
                Text("Not an open Duo")
            }
        }
    }
}
```

`insets.duoPhoneState` is `.openLandscape`, `.openPortrait`, or `.notDuo`. `insets.isDuo` is `true` for either open layout.

## Insets you already have

```swift
import isDuo

let state = duoPhoneState(topInset: insets.top, trailingInset: insets.trailing)

if isDuo(topInset: insets.top, trailingInset: insets.trailing) {
    // open landscape or open portrait
}

if isDuoOpenLandscape(trailingInset: insets.trailing) {
    // trailing == 84
}

if isDuoOpenPortrait(topInset: insets.top) {
    // top == 82
}
```

## UIKit

`DuoPhoneState.current()` reads the key window. Trailing is the right inset in left-to-right layout, and the left inset in right-to-left. Call it on the main actor.

```swift
import isDuo

let state = DuoPhoneState.current()

switch state {
case .openLandscape:
    break
case .openPortrait:
    break
case .notDuo:
    break
}
```

Pass a window when you do not want the key window:

```swift
let state = DuoPhoneState.current(in: window)
```
