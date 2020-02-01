@testable import Pomodoro
import XCTest

class HookTests: XCTestCase {
    func testExample() {
        let expectation = XCTestExpectation(description: "Execution should complete successfully.")

        Hook.didStart.execute { result in
            if case .success = result {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
