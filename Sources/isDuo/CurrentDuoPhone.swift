#if canImport(UIKit)
import UIKit

extension DuoPhoneState {
    /// Safe-area insets and screen bounds of the key window.
    /// Trailing follows the window layout direction.
    @MainActor
    public static func current(in window: UIWindow? = nil) -> DuoPhoneState {
        guard let window = window ?? currentKeyWindow() else {
            return .notDuo
        }
        let insets = window.safeAreaInsets
        return DuoPhoneState(
            topInset: insets.top,
            trailingInset: insets.trailing(for: window.traitCollection.layoutDirection),
            screenFrame: window.screen.bounds
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
