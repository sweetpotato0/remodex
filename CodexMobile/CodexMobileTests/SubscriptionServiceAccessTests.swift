// FILE: SubscriptionServiceAccessTests.swift
// Purpose: Verifies self-hosted builds do not meter local sends behind the Pro paywall path.
// Layer: Unit Test
// Exports: SubscriptionServiceAccessTests
// Depends on: XCTest, CodexMobile

import XCTest
@testable import CodexMobile

@MainActor
final class SubscriptionServiceAccessTests: XCTestCase {
    func testFreshUserHasAppAccessWithoutMetering() {
        let service = makeService()

        XCTAssertEqual(service.freeSendCount, 0)
        XCTAssertEqual(service.remainingFreeSendAttempts, Int.max)
        XCTAssertTrue(service.hasFreeSendAccess)
        XCTAssertTrue(service.hasAppAccess)
    }

    func testSendAttemptsAreNotConsumed() {
        let service = makeService()

        for _ in 0..<7 {
            service.consumeFreeSendAttemptIfNeeded()
        }

        XCTAssertEqual(service.freeSendCount, 0)
        XCTAssertEqual(service.remainingFreeSendAttempts, Int.max)
        XCTAssertTrue(service.hasFreeSendAccess)
        XCTAssertTrue(service.hasAppAccess)
    }

    private func makeService() -> SubscriptionService {
        let suiteName = "SubscriptionServiceAccessTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.removePersistentDomain(forName: suiteName)
        return SubscriptionService(defaults: defaults)
    }
}
