import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PMNetworkingTests.allTests),
    ]
}
#endif
