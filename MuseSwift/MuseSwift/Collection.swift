import Foundation

public extension CollectionType {
  private typealias Z = Generator.Element

  public func grouped(n: Int) -> [[Generator.Element]] {
    assert(n > 0, "group size must be greater than 0")

    var result = [[Z]]()
    var size: Int = 0
    var acc = [Z]()

    for e in self {
      if size >= n {
        result.append(acc)
        acc = []
        size = 0
      }

      size += 1
      acc.append(e)
    }

    if !acc.isEmpty {
      result.append(acc)
    }

    return result
  }

  public func forall(f: (Generator.Element) -> Bool) -> Bool {
    return !contains(f)
  }

  public func groupBy<T: Equatable>(f: (Z) -> T) -> [T: [Z]] {
    var result = [T: [Z]]()

    for e in self {
      let a = f(e)
      if let _ = result[a] {
        result[a]?.append(e)
      } else {
        result[a] = [e]
      }
    }

    return result
  }

  public var nonEmpty: Bool {
    get {
      return !isEmpty
    }
  }
}
