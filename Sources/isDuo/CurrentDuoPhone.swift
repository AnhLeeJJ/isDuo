#if canImport(UIKit)
import UIKit

extension DuoPhoneState {
    /// Safe-area insets and screen bounds of the key window.
    /// Leading and trailing follow the window layout direction.
    @MainActor
    public static func current(in window: UIWindow? = nil) -> DuoPhoneState {
        guard let window = window ?? currentKeyWindow() else {
            return .notDuo
        }
        let direction = window.traitCollection.layoutDirection
        let insets = window.safeAreaInsets
        return DuoPhoneState(
            topInset: insets.top,
            leadingInset: insets.leading(for: direction),
            bottomInset: insets.bottom,
            trailingInset: insets.trailing(for: direction),
            screenFrame: window.screen.bounds
        )
    }
}

extension UIEdgeInsets {
    func leading(for layoutDirection: UITraitEnvironmentLayoutDirection) -> CGFloat {
        layoutDirection == .rightToLeft ? right : left
    }

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
