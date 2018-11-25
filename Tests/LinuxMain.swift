import XCTest

import ANSITests

var tests = [XCTestCaseEntry]()
tests += ANSITests.allTests()
XCTMain(tests)