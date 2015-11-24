import Foundation

public struct Voice {
  public let id: String
  public let elements: [MusicalElement]
}

public struct TuneHeader {
  public let reference: Reference?
  public let tuneTitle: TuneTitle?
  public let composer: Composer?
  public let meter: Meter
  public let unitNoteLength: UnitNoteLength
  public let tempo: Tempo
  public let key: Key
  public let voiceHeaders: [VoiceHeader]
}

public struct TuneBody {
  public let voices: [Voice]
}

public struct Tune {
  public let tuneHeader: TuneHeader
  public let tuneBody: TuneBody
}
