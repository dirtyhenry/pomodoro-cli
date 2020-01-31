import XCTest

import pomodoroTests

var tests = [XCTestCaseEntry]()
tests += pomodoroTests.allTests()
XCTMain(tests)
