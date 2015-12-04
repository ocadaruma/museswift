import Foundation

public class SortedArray<T, U: Comparable> {
  private var array = [T]()
  private let keySelector: T -> U

  public init(keySelector: T -> U) {
    self.keySelector = keySelector
  }

  // use binary insertion sort.
  public func insert(x: T) -> Void {
    if isEmpty {
      array.append(x)
    } else {
      let target = keySelector(x)

      func iter(i: Int, imin: Int, imax: Int) -> Int {
        let key = keySelector(array[i])
        if key == target {
          return i
        } else if i <= imin || imax <= i {
          if keySelector(array[imax]) < target {
            return imax + 1
          } else if key < target {
            return i + 1
          } else {
            return i
          }
        } else if key < target {
          return iter(i + (imax - i) / 2, imin: i, imax: imax)
        } else {
          return iter(imin + (i - imin) / 2, imin: imin, imax: i)
        }
      }

      let i = iter((count - 1) / 2, imin: 0, imax: count - 1)
      array.insert(x, atIndex: i)
    }
  }

  public func get(index: Int) -> T? {
    if index < count {
      return self[index]
    } else {
      return nil
    }
  }

  public var first: T? {
    return array.first
  }

  public var last: T? {
    return array.last
  }

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var nonEmpty: Bool {
    return array.nonEmpty
  }

  public var count: Int {
    return array.count
  }

  public subscript(index: Int) -> T {
    return array[index]
  }
}