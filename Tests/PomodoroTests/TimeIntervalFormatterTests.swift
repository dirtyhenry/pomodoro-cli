@testable import Pomodoro
import XCTest

class TimeIntervalExtensionTests: XCTestCase {
    func testNoUnit() {
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "0"), TimeInterval(0))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "1"), TimeInterval(1))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "2"), TimeInterval(2))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "3"), TimeInterval(3))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "4"), TimeInterval(4))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "5"), TimeInterval(5))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "6"), TimeInterval(6))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "7"), TimeInterval(7))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "8"), TimeInterval(8))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "9"), TimeInterval(9))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "100"), TimeInterval(100))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "1500"), TimeInterval(1500))
    }

    func testMinuteUnit() {
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "0m"), TimeInterval(0))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "1m"), TimeInterval(60))
        XCTAssertEqual(TimeIntervalFormatter().timeInterval(from: "25m"), TimeInterval(1500))
    }
}
