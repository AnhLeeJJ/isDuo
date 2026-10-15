# isDuo

Detect a Duo from the safe-area insets and the screen frame.

| Layout | Check |
| --- | --- |
| Duo closed | `top == 0`, `leading == 0`, `bottom == 34`, `trailing == 84`, and `screenFrame.width < screenFrame.height` |
| Duo open landscape | `trailing == 84` |
| Duo open portrait | `top == 82` |

Closed is checked first, because a closed Duo also has a trailing inset of 84. Any other insets are `.notDuo`. If the open landscape and open portrait values both match, the result is open landscape.

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
            let screenFrame = proxy.frame(in: .global)
            let insets = proxy.safeAreaInsets

            if insets.isDuoClosed(screenFrame: screenFrame) {
                Text("Duo closed")
            } else if insets.isDuoOpenLandscape(screenFrame: screenFrame) {
                Text("Duo open landscape")
            } else if insets.isDuoOpenPortrait(screenFrame: screenFrame) {
                Text("Duo open portrait")
            } else {
                Text("Not a Duo")
            }
        }
    }
}
```

`proxy.duoPhoneState` reads the same safe area and global frame. It is `.closed`, `.openLandscape`, `.openPortrait`, or `.notDuo`. Pass the screen frame yourself when the geometry view is smaller than the screen:

```swift
insets.duoPhoneState(screenFrame: screenFrame)
```

## Insets you already have

```swift
import isDuo

let state = duoPhoneState(
    topInset: insets.top,
    leadingInset: insets.leading,
    bottomInset: insets.bottom,
    trailingInset: insets.trailing,
    screenFrame: screenFrame
)

if state.isClosed {
    // top 0, leading 0, bottom 34, trailing 84, and screenFrame.width < screenFrame.height
}

if isDuoClosed(
    topInset: 0,
    leadingInset: 0,
    bottomInset: 34,
    trailingInset: 84,
    screenFrame: screenFrame
) {
    // same closed check
}

if isDuoOpenLandscape(trailingInset: insets.trailing) {
    // trailing == 84
}

if isDuoOpenPortrait(topInset: insets.top) {
    // top == 82
}
```

## UIKit

`DuoPhoneState.current()` reads the key window's safe area and `window.screen.bounds`. Leading and trailing follow the window layout direction. Call it on the main actor.

```swift
import isDuo

let state = DuoPhoneState.current()

switch state {
case .closed:
    break
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
