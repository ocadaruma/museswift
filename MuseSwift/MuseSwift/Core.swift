import Foundation

public enum PitchName: Int {
  case C = 0, D, E, F, G, A, B
}

public enum Accidental {
  case Natural, Flat, Sharp, DoubleFlat, DoubleSharp
}

public struct Pitch : Equatable {
  public let name: PitchName
  public let accidental: Accidental?
  public let offset: Int
  public init(name: PitchName, accidental: Accidental?, offset: Int) {
    self.name = name
    self.accidental = accidental
    self.offset = offset
  }
}

public func ==(lhs: Pitch, rhs: Pitch) -> Bool {
  return lhs.offset == rhs.offset &&
    lhs.accidental == rhs.accidental &&
    lhs.name == rhs.name
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

public struct NoteLength : Equatable {
  public let numerator: Int
  public let denominator: Int
  public init(numerator: Int, denominator: Int) {
    self.numerator = numerator
    self.denominator = denominator
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
