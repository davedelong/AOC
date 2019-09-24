import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Advent_of_CodeTests.allTests),
    ]
}
#endif
