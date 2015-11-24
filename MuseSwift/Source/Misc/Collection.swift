import Foundation

extension CollectionType {
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

  public func forall(f: Generator.Element -> Bool) -> Bool {
    return !contains(f)
  }

  public func groupBy<T: Equatable>(f: Z -> T) -> [T: [Z]] {
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

  public func spanBy<T: Equatable>(f: Z -> T) -> [[Z]] {
    var result = [[Z]]()

    var acc = [Z]()
    for e in self {
      if let a = acc.first {
        if f(e) == f(a) {
          acc.append(e)
        } else {
          result.append(acc)
          acc = [e]
        }
      } else {
        acc.append(e)
      }
    }

    if acc.nonEmpty {
      result.append(acc)
    }

    return result
  }

  public func minBy<T: Comparable>(f: Z -> T) -> Z? {
    return self.minElement({ f($0) < f($1) })
  }

  public func maxBy<T: Comparable>(f: Z -> T) -> Z? {
    return self.maxElement({ f($0) < f($1) })
  }

  public func sortBy<T: Comparable>(f: Z -> T) -> [Z] {
    return self.sort({ f($0) < f($1) })
  }

  public func partitionBy(f: Z -> Bool) -> ([Z], [Z]) {
    var trues = [Z]()
    var falses = [Z]()

    for e in self {
      if f(e) {
        trues.append(e)
      } else {
        falses.append(e)
      }
    }

    return (trues, falses)
  }

  public var nonEmpty: Bool {
    return !isEmpty
  }
}

extension CollectionType where Generator.Element: Numeric {
  public func sum() -> Generator.Element {
    return self.reduce(Generator.Element.Zero, combine: { $0 + $1 })
  }

  public func product() -> Generator.Element {
    return self.reduce(Generator.Element.One, combine: { $0 * $1 })
  }
}
