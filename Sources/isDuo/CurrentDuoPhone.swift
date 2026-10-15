#if canImport(UIKit)
import UIKit

extension DuoPhoneState {
    /// Safe-area insets of the key window, with `trailing` resolved from the window layout direction.
    @MainActor
    public static func current(in window: UIWindow? = nil) -> DuoPhoneState {
        guard let window = window ?? currentKeyWindow() else {
            return .notDuo
        }
        return DuoPhoneState(
            topInset: window.safeAreaInsets.top,
            trailingInset: window.safeAreaInsets.trailing(for: window.traitCollection.layoutDirection)
        )
    }
}

extension UIEdgeInsets {
    func trailing(for layoutDirection: UITraitEnvironmentLayoutDirection) -> CGFloat {
        layoutDirection == .rightToLeft ? left : right
    }
}

@MainActor
private func currentKeyWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let windows = scenes.flatMap(\.windows)
    return windows.first(where: \.isKeyWindow) ?? windows.first
}
#endif
