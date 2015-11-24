import Foundation

public protocol Header { }

public struct Reference : Header {
  public let number: Int
  public init(number: Int) {
    self.number = number
  }
}

public struct TuneTitle : Header {
  public let title: String
  public init(title: String) {
    self.title = title
  }
}

public struct Composer : Header {
  public let name: String
  public init(name: String) {
    self.name = name
  }
}

public struct Meter : Header {
  public let numerator: Int
  public let denominator: Int
  public init(numerator: Int, denominator: Int) {
    self.numerator = numerator
    self.denominator = denominator
  }
}

public struct UnitNoteLength : Header {
  public let denominator: UnitDenominator
  public init(denominator: UnitDenominator) {
    self.denominator = denominator
  }
}

public struct Tempo : Header {
  public let bpm: Int
  public let inLength: NoteLength
  public init(bpm: Int, inLength: NoteLength) {
      self.bpm = bpm
      self.inLength = inLength
  }
}

public enum KeySignature {
  case Sharp1, Sharp2, Sharp3, Sharp4, Sharp5, Sharp6, Sharp7
  case Zero
  case Flat1, Flat2, Flat3, Flat4, Flat5, Flat6, Flat7
}

public struct Key : Header {
  public let keySignature: KeySignature
  public let octave: Int
  public init(keySignature: KeySignature, octave: Int = 0) {
    self.keySignature = keySignature
    self.octave = octave
  }
}

public struct VoiceHeader : Header {
  public let id: String
  public let clef: Clef
  public init(id: String, clef: Clef) {
    self.id = id
    self.clef = clef
  }
}
