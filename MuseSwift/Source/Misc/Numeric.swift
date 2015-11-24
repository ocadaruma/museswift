import Foundation

extension Double {
  public var degree: Double {
    return self / M_PI * 180
  }

  public var rad: Double {
    return self * M_PI / 180
  }
}

public protocol Numeric: Comparable {
  static var Zero: Self { get }
  static var One: Self { get }

  func +(lhs: Self, rhs: Self) -> Self
  func -(lhs: Self, rhs: Self) -> Self
  func *(lhs: Self, rhs: Self) -> Self
  func /(lhs: Self, rhs: Self) -> Self

  prefix func -(n: Self) -> Self
}

extension Numeric {
  public var abs: Self {
    if self < Self.Zero {
      return self * -Self.One
    } else {
      return self
    }
  }

  public var sign: Self {
    if self < Self.Zero {
      return -Self.One
    } else if self > Self.Zero {
      return Self.One
    } else {
      return Self.Zero
    }
  }
}

extension Int: Numeric {
  public static var Zero: Int { return 0 }
  public static var One: Int { return 1 }
}

extension Double: Numeric {
  public static var Zero: Double { return 0 }
  public static var One: Double { return 1 }
}

extension Float: Numeric {
  public static var Zero: Float { return 0 }
  public static var One: Float { return 1 }
}

extension CGFloat: Numeric {
  public static var Zero: CGFloat { return 0 }
  public static var One: CGFloat { return 1 }
}

public struct Point2D<T: Numeric> {
  public let x: T
  public let y: T

  public init(x: T, y: T) {
    self.x = x
    self.y = y
  }
}

public func linearFunction<T: Numeric>(slope: T, point: Point2D<T>) -> (T) -> T {
  let b = point.y - (slope * point.x)
  return { (x: T) -> T in slope * x + b }
}