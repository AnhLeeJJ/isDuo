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

@Test func closedWhenTrailingIs84AndScreenIsPortrait() {
    let screenFrame = CGRect(x: 0, y: 0, width: 390, height: 844)
    let state = duoPhoneState(topInset: 59, trailingInset: 84, screenFrame: screenFrame)

    #expect(state == .closed)
    #expect(state.isDuo)
    #expect(state.isClosed)
    #expect(!state.isOpenLandscape)
    #expect(isDuoClosed(trailingInset: 84, screenFrame: screenFrame))
}

@Test func trailing84OnLandscapeScreenIsOpenLandscape() {
    let screenFrame = CGRect(x: 0, y: 0, width: 844, height: 390)

    #expect(duoPhoneState(topInset: 0, trailingInset: 84, screenFrame: screenFrame) == .openLandscape)
    #expect(!isDuoClosed(trailingInset: 84, screenFrame: screenFrame))
}

@Test func squareScreenIsNotClosed() {
    let screenFrame = CGRect(x: 0, y: 0, width: 400, height: 400)

    #expect(duoPhoneState(topInset: 0, trailingInset: 84, screenFrame: screenFrame) == .openLandscape)
}

#if canImport(SwiftUI)
import SwiftUI

@Test func edgeInsetsUseScreenFrame() {
    let landscapeFrame = CGRect(x: 0, y: 0, width: 844, height: 390)
    let portraitFrame = CGRect(x: 0, y: 0, width: 390, height: 844)
    let landscape = EdgeInsets(top: 47, leading: 0, bottom: 21, trailing: 84)
    let portrait = EdgeInsets(top: 82, leading: 0, bottom: 34, trailing: 0)
    let closed = EdgeInsets(top: 0, leading: 0, bottom: 34, trailing: 84)
    let phone = EdgeInsets(top: 59, leading: 0, bottom: 34, trailing: 0)

    #expect(landscape.duoPhoneState(screenFrame: landscapeFrame) == .openLandscape)
    #expect(landscape.isDuo(screenFrame: landscapeFrame))
    #expect(landscape.isDuoOpenLandscape(screenFrame: landscapeFrame))
    #expect(portrait.duoPhoneState(screenFrame: portraitFrame) == .openPortrait)
    #expect(portrait.isDuoOpenPortrait(screenFrame: portraitFrame))
    #expect(closed.duoPhoneState(screenFrame: portraitFrame) == .closed)
    #expect(closed.isDuoClosed(screenFrame: portraitFrame))
    #expect(closed.duoPhoneState(screenFrame: landscapeFrame) == .openLandscape)
    #expect(phone.duoPhoneState(screenFrame: portraitFrame) == .notDuo)
    #expect(!phone.isDuo(screenFrame: portraitFrame))
}
#endif
