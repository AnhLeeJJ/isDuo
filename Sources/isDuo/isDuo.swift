import CoreGraphics

/// Open-Duo layout inferred from the hinge safe-area inset.
public enum DuoPhoneState: Sendable, Equatable {
    /// Spanned landscape. The hinge is the trailing inset of 84.
    case openLandscape
    /// Spanned portrait. The hinge is the top inset of 82.
    case openPortrait
    /// Insets do not match an open Duo.
    case notDuo

    /// Trailing safe-area inset reported when a Duo is open in landscape.
    public static let openLandscapeTrailingInset: CGFloat = 84
    /// Top safe-area inset reported when a Duo is open in portrait.
    public static let openPortraitTopInset: CGFloat = 82

    public var isDuo: Bool {
        self != .notDuo
    }

    public var isOpenLandscape: Bool {
        self == .openLandscape
    }

    public var isOpenPortrait: Bool {
        self == .openPortrait
    }

    /// - Duo open landscape: `trailingInset == 84`
    /// - Duo open portrait: `topInset == 82`
    public init(topInset: CGFloat, trailingInset: CGFloat) {
        if trailingInset == Self.openLandscapeTrailingInset {
            self = .openLandscape
        } else if topInset == Self.openPortraitTopInset {
            self = .openPortrait
        } else {
            self = .notDuo
        }
    }
}

/// Classifies the current phone from the safe-area insets that mark an open Duo.
public func duoPhoneState(topInset: CGFloat, trailingInset: CGFloat) -> DuoPhoneState {
    DuoPhoneState(topInset: topInset, trailingInset: trailingInset)
}

public func isDuo(topInset: CGFloat, trailingInset: CGFloat) -> Bool {
    duoPhoneState(topInset: topInset, trailingInset: trailingInset).isDuo
}

public func isDuoOpenLandscape(trailingInset: CGFloat) -> Bool {
    trailingInset == DuoPhoneState.openLandscapeTrailingInset
}

public func isDuoOpenPortrait(topInset: CGFloat) -> Bool {
    topInset == DuoPhoneState.openPortraitTopInset
}

#if canImport(SwiftUI)
import SwiftUI

public extension EdgeInsets {
    /// Open-Duo state using `top` and `trailing`.
    var duoPhoneState: DuoPhoneState {
        DuoPhoneState(topInset: top, trailingInset: trailing)
    }

    var isDuo: Bool {
        duoPhoneState.isDuo
    }

    var isDuoOpenLandscape: Bool {
        duoPhoneState.isOpenLandscape
    }

    var isDuoOpenPortrait: Bool {
        duoPhoneState.isOpenPortrait
    }
}
#endif
