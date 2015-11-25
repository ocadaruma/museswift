import Foundation

public enum PitchName: Int {
  case C = 0, D, E, F, G, A, B
}

public enum Accidental: Int {
  case DoubleFlat = -2, Flat, Natural, Sharp, DoubleSharp
}

public struct Pitch : Equatable, Comparable {
  public let name: PitchName
  public let accidental: Accidental?
  public let octave: Int
  public init(name: PitchName, accidental: Accidental?, octave: Int) {
    self.name = name
    self.accidental = accidental
    self.octave = octave
  }
}

public func ==(lhs: Pitch, rhs: Pitch) -> Bool {
  return lhs.octave == rhs.octave &&
    lhs.accidental == rhs.accidental &&
    lhs.name == rhs.name
}

public func <(lhs: Pitch, rhs: Pitch) -> Bool {
  let left = lhs.octave * 7 + lhs.name.rawValue + (lhs.accidental?.rawValue ?? 0)
  let right = rhs.octave * 7 + rhs.name.rawValue + (rhs.accidental?.rawValue ?? 0)
  return left < right
}

public func <=(lhs: Pitch, rhs: Pitch) -> Bool {
  return lhs < rhs || lhs == rhs
}

public func >=(lhs: Pitch, rhs: Pitch) -> Bool {
  return !(lhs < rhs)
}

public enum UnitDenominator: Int {
  case Whole = 1
  case Half = 2
  case Quarter = 4
  case Eighth = 8
  case Sixteenth = 16
  case ThirtySecond = 32
  case SixtyFourth = 64
}

public struct NoteLength : Hashable {
  public let numerator: Int
  public let denominator: Int
  public init(numerator: Int, denominator: Int) {
    self.numerator = numerator
    self.denominator = denominator
  }

  public var hashValue: Int {
    return numerator.hashValue ^ denominator.hashValue
  }

  public func actualLength(unit: UnitDenominator) -> Float {
    return Float(numerator) / Float(denominator) / Float(unit.rawValue)
  }
}

public func ==(lhs: NoteLength, rhs: NoteLength) -> Bool {
  return lhs.numerator == rhs.numerator &&
    lhs.denominator == rhs.denominator
}

public enum ClefName : String {
  case Treble = "treble"
  case Bass = "bass"
}

public struct Clef : Equatable {
  public let clefName: ClefName
  public init(clefName: ClefName) {
    self.clefName = clefName
  }
}

public func ==(lhs: Clef, rhs: Clef) -> Bool {
  return lhs.clefName == rhs.clefName
}
