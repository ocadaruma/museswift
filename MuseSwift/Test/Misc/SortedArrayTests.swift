import XCTest
import MuseSwift

class SortedArrayTests: XCTestCase {
  func testInsertAscending() {
    let array = SortedArray<String, Int>(keySelector: {$0.characters.count})

    let strings = (1...100).map({[String](count: $0, repeatedValue: "a").joinWithSeparator("")})
    for s in strings { array.insert(s) }

    for i in 0..<strings.count {
      XCTAssertEqual(array[i], strings[i])
    }

    let array2 = SortedArray<Int, Int>(keySelector: identity)

    let nums = 1...100
    for i in nums { array2.insert(i) }

    for i in 0..<nums.count {
      XCTAssertEqual(array2[i], array2[i])
    }
  }

  func testInsertDescending() {
    let array = SortedArray<String, Int>(keySelector: {$0.characters.count})

    let strings = (1...100).map({[String](count: $0, repeatedValue: "a").joinWithSeparator("")})
    for s in strings.reverse() { array.insert(s) }

    for i in 0..<strings.count {
      XCTAssertEqual(array[i], strings[i])
    }

    let array2 = SortedArray<Int, Int>(keySelector: identity)

    let nums = [Int](1...100)
    for i in nums.reverse() { array2.insert(i) }

    for i in 0..<nums.count {
      XCTAssertEqual(array2[i], nums[i])
    }
  }

  func testInsertRandomly() {
    let array = SortedArray<String, Int>(keySelector: {$0.characters.count})

    array.insert("abc")
    array.insert("book")
    array.insert("z")

    XCTAssertEqual(array[0], "z")
    XCTAssertEqual(array[1], "abc")
    XCTAssertEqual(array[2], "book")

    let array2 = SortedArray<Int, Int>(keySelector: identity)

    array2.insert(50)
    array2.insert(19)
    array2.insert(3)
    array2.insert(11)
    array2.insert(1)

    XCTAssertEqual(array2[0], 1)
    XCTAssertEqual(array2[1], 3)
    XCTAssertEqual(array2[2], 11)
    XCTAssertEqual(array2[3], 19)
    XCTAssertEqual(array2[4], 50)

    let array3 = SortedArray<Int, Int>(keySelector: identity)

    let nums = (1...100).map({_ in random()})
    let sortedNums = nums.sort()

    for i in nums { array3.insert(i) }

    for i in 0..<nums.count {
      XCTAssertEqual(array3[i], sortedNums[i])
    }
  }
}

