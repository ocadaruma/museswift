import Foundation

public struct ParseResult<T> {
  public let result: T?
  public let ateLength: Int
  public init(result: T?, ateLength: Int) {
    self.result = result
    self.ateLength = ateLength
  }

  public var isEmpty: Bool {
    return result == nil
  }
}

public struct ArrayParseResult<T> {
  public let result: [T]
  public let ateLength: Int
  public init(result: [T], ateLength: Int) {
    self.result = result
    self.ateLength = ateLength
  }

  public var isEmpty: Bool {
    return result.isEmpty
  }
}

public struct EatResult {
  public let result: Bool
  public let ateLength: Int
  public init(result: Bool, ateLength: Int) {
    self.result = result
    self.ateLength = ateLength
  }

  public var isEmpty: Bool {
    return result
  }
}

public let emptyEatResult = EatResult(result: false, ateLength: 0)

public func emptyParseResult<T>() -> ParseResult<T> {
  return ParseResult<T>(result: nil, ateLength: 0)
}

public func emptyArrayParseResult<T>() -> ArrayParseResult<T> {
  return ArrayParseResult<T>(result: [], ateLength: 0)
}

func createParser<T>(pattern: String, op: [MatchResult] -> T) -> String -> (ParseResult<T>, String) {
  return { (string: String) -> (ParseResult<T>, String) in
    let scanner = StringScanner(string: string)
    let matches = scanner.scan(pattern)
    if matches.isEmpty {
      return (ParseResult(result: nil, ateLength: 0), string)
    } else {
      return (ParseResult(result: op(matches), ateLength: matches[0].match.characters.count), scanner.result)
    }
  }
}

func eatPattern(pattern: String) -> String -> (EatResult, String) {
  return { (string: String) -> (EatResult, String) in
    let scanner = StringScanner(string: string)
    let matches = scanner.scan(pattern)
    if matches.isEmpty {
      return (emptyEatResult, string)
    } else {
      return (EatResult(result: true, ateLength: matches[0].match.characters.count), scanner.result)
    }
  }
}

func || <T, U> (f: T -> (ParseResult<U>, T), g: T -> (ParseResult<U>, T)) -> T -> (ParseResult<U>, T) {
  return { a -> (ParseResult<U>, T) in
    let (fR, rest) = f(a)

    switch fR.result {
    case .Some(_): return (fR, rest)
    case .None: return g(rest)
    }
  }
}

func && <T, U, V> (f: T -> (ParseResult<U>, T), g: T -> (ParseResult<V>, T)) -> T -> (ParseResult<U>, ParseResult<V>, T) {
  return { a -> (ParseResult<U>, ParseResult<V>, T) in
    let (fR, rest) = f(a)

    switch fR.result {
    case .Some(_):
      let (gR, gRest) = g(rest)
      return (fR, gR, gRest)
    case .None: return (emptyParseResult(), emptyParseResult(), rest)
    }
  }
}

infix operator &> { associativity left }
infix operator &< { associativity left }

func &> <T, U, V> (f: T -> (ParseResult<U>, T), g: T -> (ParseResult<V>, T)) -> T -> (ParseResult<V>, T) {
  return { a -> (ParseResult<V>, T) in
    let (fR, rest) = f(a)

    switch fR.result {
    case .Some(_):
      let (gR, gRest) = g(rest)
      switch gR.result {
      case .Some(let g):
        return (ParseResult(result: g, ateLength: fR.ateLength + gR.ateLength), gRest)
      case .None: return (emptyParseResult(), a)
      }
    case .None: return (emptyParseResult(), a)
    }
  }
}

func &> <T, U> (f: T -> (EatResult, T), g: T -> (ParseResult<U>, T)) -> T -> (ParseResult<U>, T) {
  return { a -> (ParseResult<U>, T) in
    let (fR, rest) = f(a)
    if fR.result {
      let (gR, gRest) = g(rest)
      switch gR.result {
      case .Some(let r): return (ParseResult(result: r, ateLength: fR.ateLength + gR.ateLength), gRest)
      case .None: return (emptyParseResult(), a)
      }
    } else {
      return (emptyParseResult(), a)
    }
  }
}

func &> <T, U> (f: T -> (EatResult, T), g: T -> (ArrayParseResult<U>, T)) -> T -> (ArrayParseResult<U>, T) {
  return { a -> (ArrayParseResult<U>, T) in
    let (fR, rest) = f(a)
    if fR.result {
      let (gR, gRest) = g(rest)
      if !gR.isEmpty {
        return (ArrayParseResult(result: gR.result, ateLength: fR.ateLength + gR.ateLength), gRest)
      } else {
        return (emptyArrayParseResult(), a)
      }
    } else {
      return (emptyArrayParseResult(), a)
    }
  }
}

func &< <T, U> (f: T -> (ParseResult<U>, T), g: T -> (EatResult, T)) -> T -> (ParseResult<U>, T) {
  return { a -> (ParseResult<U>, T) in
    let (fR, rest) = f(a)

    switch fR.result {
    case .Some(let r):
      let (gR, gRest) = g(rest)
      return (gR.result ? ParseResult(result: r, ateLength: fR.ateLength + gR.ateLength) : emptyParseResult(),
        gR.result ? gRest : a)
    case .None: return (emptyParseResult(), a)
    }
  }
}

func &< <T, U> (f: T -> (ArrayParseResult<U>, T), g: T -> (EatResult, T)) -> T -> (ArrayParseResult<U>, T) {
  return { a -> (ArrayParseResult<U>, T) in
    let (fR, rest) = f(a)

    if fR.isEmpty {
      return (emptyArrayParseResult(), a)
    } else {
      let (gR, gRest) = g(rest)
      return (gR.result ? ArrayParseResult(result: fR.result, ateLength: fR.ateLength + gR.ateLength) : emptyArrayParseResult(),
        gR.result ? gRest : a)
    }
  }
}

func many<T, U>(f: T -> (ParseResult<U>, T)) -> T -> (ArrayParseResult<U>, T) {
  return { a -> (ArrayParseResult<U>, T) in
    var fR: ParseResult<U>
    var rest: T = a
    var result: [U] = []
    var ateLength = 0

    repeat {
      (fR, rest) = f(rest)
      if let r = fR.result {
        result.append(r)
        ateLength += fR.ateLength
      }
    } while (fR.result != nil)
    return (ArrayParseResult(result: result, ateLength: ateLength), rest)
  }
}

func many<T>(f: T -> (EatResult, T)) -> T -> (EatResult, T) {
  return { a -> (EatResult, T) in
    var rest: T = a
    var ateLength = 0
    var result: EatResult = emptyEatResult
    repeat {
      (result, rest) = f(rest)
      ateLength += result.ateLength
    } while (result.result)
    return (EatResult(result: result.result, ateLength: ateLength), rest)
  }
}

func many<T, U>(f: T -> (ParseResult<U>, T), n: Int) -> T -> (ArrayParseResult<U>, T) {
  return { a -> (ArrayParseResult<U>, T) in
    var fR: ParseResult<U>
    var rest: T = a
    var result: [U] = []
    var ateLength = 0

    for _ in 0..<n {
      (fR, rest) = f(rest)
      if let r = fR.result {
        result.append(r)
        ateLength += fR.ateLength
      }
      if fR.result == nil {
        break
      }
    }

    if result.count == n {
      return (ArrayParseResult(result: result, ateLength: ateLength), rest)
    } else {
      return (emptyArrayParseResult(), a)
    }
  }
}
