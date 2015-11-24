import Foundation

public enum Either<T, U> {
  case Left(left: T)
  case Right(right: U)

  public var isLeft: Bool {
    get {
      switch self {
      case .Left(_): return true
      case .Right(_): return false
      }
    }
  }

  public var isRight: Bool {
    get {
      return !isLeft
    }
  }

  public var left: LeftProjection<T, U> {
    get { return LeftProjection(e: self) }
  }

  public var right: RightProjection<T, U> {
    get { return RightProjection(e: self) }
  }
}

public class LeftProjection<T, U> {
  public let e: Either<T, U>

  public init(e: Either<T, U>) {
    self.e = e
  }

  public func get() -> T {
    let result: T!
    switch e {
    case .Left(let left): result = left
    case .Right(_): result = nil
    }
    return result
  }

  public func getOrElse(or: T) -> T {
    switch e {
    case .Left(let left): return left
    case .Right(_): return or
    }
  }

  public func toArray() -> [T] {
    switch e {
    case .Left(let left): return [left]
    case .Right(_): return []
    }
  }

  public func map<V>(f: T -> V) -> Either<V, U> {
    switch e {
    case .Left(let left): return .Left(left: f(left))
    case .Right(let right): return .Right(right: right)
    }
  }
}

public class RightProjection<T, U> {
  public let e: Either<T, U>

  public init(e: Either<T, U>) {
    self.e = e
  }

  public func get() -> U {
    let result: U!
    switch e {
    case .Left(_): result = nil
    case .Right(let right): result = right
    }
    return result
  }

  public func getOrElse(or: U) -> U {
    switch e {
    case .Left(_): return or
    case .Right(let right): return right
    }
  }

  public func toArray() -> [U] {
    switch e {
    case .Left(_): return []
    case .Right(let right): return [right]
    }
  }

  public func map<V>(f: U -> V) -> Either<T, V> {
    switch e {
    case .Left(let left): return .Left(left: left)
    case .Right(let right): return .Right(right: f(right))
    }
  }
}