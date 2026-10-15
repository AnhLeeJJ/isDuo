import CoreGraphics
import Testing
@testable import isDuo

@Test func openLandscapeWhenTrailingInsetIs84() {
    let state = duoPhoneState(topInset: 0, trailingInset: 84)

    #expect(state == .openLandscape)
    #expect(state.isDuo)
    #expect(state.isOpenLandscape)
    #expect(isDuo(topInset: 0, trailingInset: 84))
    #expect(isDuoOpenLandscape(trailingInset: 84))
    #expect(!isDuoOpenPortrait(topInset: 0))
}

@Test func openPortraitWhenTopInsetIs82() {
    let state = duoPhoneState(topInset: 82, trailingInset: 0)

    #expect(state == .openPortrait)
    #expect(state.isDuo)
    #expect(state.isOpenPortrait)
    #expect(isDuo(topInset: 82, trailingInset: 0))
    #expect(isDuoOpenPortrait(topInset: 82))
    #expect(!isDuoOpenLandscape(trailingInset: 0))
}

@Test func landscapeWinsWhenBothSignaturesMatch() {
    #expect(duoPhoneState(topInset: 82, trailingInset: 84) == .openLandscape)
}

@Test func otherInsetsAreNotDuo() {
    let state = duoPhoneState(topInset: 59, trailingInset: 0)

    #expect(state == .notDuo)
    #expect(!state.isDuo)
    #expect(!isDuo(topInset: 47, trailingInset: 21))
    #expect(!isDuoOpenLandscape(trailingInset: 83))
    #expect(!isDuoOpenPortrait(topInset: 83))
}

#if canImport(SwiftUI)
import SwiftUI

@Test func edgeInsetsUseTopAndTrailing() {
    let landscape = EdgeInsets(top: 47, leading: 0, bottom: 21, trailing: 84)
    let portrait = EdgeInsets(top: 82, leading: 0, bottom: 34, trailing: 0)
    let phone = EdgeInsets(top: 59, leading: 0, bottom: 34, trailing: 0)

    #expect(landscape.duoPhoneState == .openLandscape)
    #expect(landscape.isDuo)
    #expect(landscape.isDuoOpenLandscape)
    #expect(portrait.duoPhoneState == .openPortrait)
    #expect(portrait.isDuoOpenPortrait)
    #expect(phone.duoPhoneState == .notDuo)
    #expect(!phone.isDuo)
}
#endif
