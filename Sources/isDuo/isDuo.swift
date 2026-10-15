import CoreGraphics

/// Duo layout inferred from safe-area insets and the screen frame.
public enum DuoPhoneState: Sendable, Equatable {
    /// Spanned landscape. The hinge is the trailing inset of 84.
    case openLandscape
    /// Spanned portrait. The hinge is the top inset of 82.
    case openPortrait
    /// Folded Duo held in portrait.
    /// Insets are top 0, leading 0, bottom 34, trailing 84, and the screen is taller than it is wide.
    case closed
    /// Insets do not match a Duo.
    case notDuo

    /// Trailing safe-area inset reported when a Duo is open in landscape.
    public static let openLandscapeTrailingInset: CGFloat = 84
    /// Top safe-area inset reported when a Duo is open in portrait.
    public static let openPortraitTopInset: CGFloat = 82
    /// Top safe-area inset reported when a Duo is closed.
    public static let closedTopInset: CGFloat = 0
    /// Leading safe-area inset reported when a Duo is closed.
    public static let closedLeadingInset: CGFloat = 0
    /// Bottom safe-area inset reported when a Duo is closed.
    public static let closedBottomInset: CGFloat = 34
    /// Trailing safe-area inset reported when a Duo is closed.
    public static let closedTrailingInset: CGFloat = 84

    public var isDuo: Bool {
        self != .notDuo
    }

    public var isOpenLandscape: Bool {
        self == .openLandscape
    }

    public var isOpenPortrait: Bool {
        self == .openPortrait
    }

    public var isClosed: Bool {
        self == .closed
    }

    /// Classifies a Duo from safe-area insets and the screen frame.
    ///
    /// Closed is checked before open landscape, because both report a trailing inset of 84.
    /// - Duo closed: top 0, leading 0, bottom 34, trailing 84, and `screenFrame.width < screenFrame.height`
    /// - Duo open landscape: `trailingInset == 84`
    /// - Duo open portrait: `topInset == 82`
    public init(
        topInset: CGFloat,
        leadingInset: CGFloat = 0,
        bottomInset: CGFloat = 0,
        trailingInset: CGFloat,
        screenFrame: CGRect = .zero
    ) {
        if Self.isClosedLayout(
            topInset: topInset,
            leadingInset: leadingInset,
            bottomInset: bottomInset,
            trailingInset: trailingInset,
            screenFrame: screenFrame
        ) {
            self = .closed
        } else if trailingInset == Self.openLandscapeTrailingInset {
            self = .openLandscape
        } else if topInset == Self.openPortraitTopInset {
            self = .openPortrait
        } else {
            self = .notDuo
        }
    }

    private static func isClosedLayout(
        topInset: CGFloat,
        leadingInset: CGFloat,
        bottomInset: CGFloat,
        trailingInset: CGFloat,
        screenFrame: CGRect
    ) -> Bool {
        topInset == closedTopInset
            && leadingInset == closedLeadingInset
            && bottomInset == closedBottomInset
            && trailingInset == closedTrailingInset
            && screenFrame.width < screenFrame.height
    }
}

/// Classifies the current phone from safe-area insets and the screen frame.
public func duoPhoneState(
    topInset: CGFloat,
    leadingInset: CGFloat = 0,
    bottomInset: CGFloat = 0,
    trailingInset: CGFloat,
    screenFrame: CGRect = .zero
) -> DuoPhoneState {
    DuoPhoneState(
        topInset: topInset,
        leadingInset: leadingInset,
        bottomInset: bottomInset,
        trailingInset: trailingInset,
        screenFrame: screenFrame
    )
}

public func isDuo(
    topInset: CGFloat,
    leadingInset: CGFloat = 0,
    bottomInset: CGFloat = 0,
    trailingInset: CGFloat,
    screenFrame: CGRect = .zero
) -> Bool {
    duoPhoneState(
        topInset: topInset,
        leadingInset: leadingInset,
        bottomInset: bottomInset,
        trailingInset: trailingInset,
        screenFrame: screenFrame
    ).isDuo
}

public func isDuoOpenLandscape(trailingInset: CGFloat) -> Bool {
    trailingInset == DuoPhoneState.openLandscapeTrailingInset
}

public func isDuoOpenPortrait(topInset: CGFloat) -> Bool {
    topInset == DuoPhoneState.openPortraitTopInset
}

public func isDuoClosed(
    topInset: CGFloat,
    leadingInset: CGFloat,
    bottomInset: CGFloat,
    trailingInset: CGFloat,
    screenFrame: CGRect
) -> Bool {
    duoPhoneState(
        topInset: topInset,
        leadingInset: leadingInset,
        bottomInset: bottomInset,
        trailingInset: trailingInset,
        screenFrame: screenFrame
    ).isClosed
}

#if canImport(SwiftUI)
import SwiftUI

public extension EdgeInsets {
    /// Duo state from these insets and a screen frame.
    /// Closed requires `screenFrame.width < screenFrame.height`.
    func duoPhoneState(screenFrame: CGRect) -> DuoPhoneState {
        DuoPhoneState(
            topInset: top,
            leadingInset: leading,
            bottomInset: bottom,
            trailingInset: trailing,
            screenFrame: screenFrame
        )
    }

    func isDuo(screenFrame: CGRect) -> Bool {
        duoPhoneState(screenFrame: screenFrame).isDuo
    }

    func isDuoOpenLandscape(screenFrame: CGRect) -> Bool {
        duoPhoneState(screenFrame: screenFrame).isOpenLandscape
    }

    func isDuoOpenPortrait(screenFrame: CGRect) -> Bool {
        duoPhoneState(screenFrame: screenFrame).isOpenPortrait
    }

    func isDuoClosed(screenFrame: CGRect) -> Bool {
        duoPhoneState(screenFrame: screenFrame).isClosed
    }
}

public extension GeometryProxy {
    /// Duo state using this view's safe area and its frame in the global coordinate space.
    var duoPhoneState: DuoPhoneState {
        safeAreaInsets.duoPhoneState(screenFrame: frame(in: .global))
    }
}
#endif
