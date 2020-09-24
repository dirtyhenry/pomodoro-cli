import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(pomodoroTests.allTests),
        ]
    }
#endif
