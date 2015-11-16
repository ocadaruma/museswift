import XCTest
@testable import MuseSwift

class CollectionTests: XCTestCase {
  func testGrouped() {
    let xs1 = [1, 2, 3, 4, 5]
    XCTAssertEqual(xs1.grouped(2), [[1, 2], [3, 4], [5]])
    XCTAssertEqual(xs1.grouped(6), [[1, 2, 3, 4, 5]])
    XCTAssertEqual(xs1.grouped(1), [[1], [2], [3], [4], [5]])

    let xs2 = [Int]()
    XCTAssertEqual(xs2.grouped(1), [])
  }

  func testGroupBy() {
    let xs1 = [1, 2, 3, 4, 5]

    XCTAssert(xs1.groupBy { $0 % 2 } == [0: [2, 4], 1: [1, 3, 5]])
    XCTAssert(xs1.groupBy { $0 } == [1: [1], 2: [2], 3: [3], 4: [4], 5: [5]])

    XCTAssert([Int]().groupBy { $0 }.isEmpty)
  }
}
