@testable import Pomodoro
import XCTest

class TimeIntervalExtensionTests: XCTestCase {
    func testNoUnit() {
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("0"), TimeInterval(0))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("1"), TimeInterval(1))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("2"), TimeInterval(2))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("3"), TimeInterval(3))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("4"), TimeInterval(4))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("5"), TimeInterval(5))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("6"), TimeInterval(6))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("7"), TimeInterval(7))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("8"), TimeInterval(8))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("9"), TimeInterval(9))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("100"), TimeInterval(100))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("1500"), TimeInterval(1500))
    }

    func testMinuteUnit() {
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("0m"), TimeInterval(0))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("1m"), TimeInterval(60))
        XCTAssertEqual(try TimeInterval.fromHumanReadableString("25m"), TimeInterval(1500))
    }
}
