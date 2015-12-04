import Foundation

protocol RenderUnit {
  var allElements: [ScoreElement] { get }
}

extension RenderUnit {
  func renderToView(view: UIView) {
    for e in self.allElements { view.addSubview(e) }
  }

  func toNoteUnits() -> [NoteUnit] {
    var result = [NoteUnit]()

    switch self {
    case let n as NoteUnit: result.append(n)
    case let b as BeamUnit: result += b.noteUnits
    case let t as TupletUnit:
      result += t.units.flatMap({ u -> [NoteUnit] in
        switch u {
        case let n as NoteUnit: return [n]
        case let b as BeamUnit: return b.noteUnits
        case let t as TupletUnit: return t.toNoteUnits()
        default: return []
        }
      })
    default: break
    }

    return result
  }
}

class NoteUnit: RenderUnit {
  let dots: [EllipseElement]
  let noteHeads: [ScoreElement]
  let accidentals: [ScoreElement]
  let fillingStaff: [ScoreElement]
  let stem: RectElement?
  let flag: ScoreElement?
  let sparse: Bool
  let invert: Bool
  let xOffset: CGFloat

  let allElements: [ScoreElement]

  init(
    dots: [EllipseElement],
    noteHeads: [ScoreElement],
    accidentals: [ScoreElement],
    fillingStaff: [ScoreElement],
    stem: RectElement?,
    flag: ScoreElement?,
    sparse: Bool,
    invert: Bool,
    xOffset: CGFloat) {
      self.dots = dots
      self.noteHeads = noteHeads
      self.accidentals = accidentals
      self.fillingStaff = fillingStaff
      self.stem = stem
      self.flag = flag
      self.sparse = sparse
      self.invert = invert
      self.xOffset = xOffset

      var elements: [ScoreElement] = noteHeads + accidentals + fillingStaff + dots
      stem.foreach({elements.append($0)})
      flag.foreach({elements.append($0)})
      self.allElements = elements
  }
}

class RestUnit: RenderUnit {
  let dots: [EllipseElement]
  let restView: ScoreElement
  let xOffset: CGFloat

  let allElements: [ScoreElement]

  init(
    dots: [EllipseElement],
    restView: ScoreElement,
    xOffset: CGFloat) {
      self.dots = dots
      self.restView = restView
      self.xOffset = xOffset

      self.allElements = [restView] + dots
  }
}

class BeamUnit: RenderUnit {
  let noteUnits: [NoteUnit]
  let beams: [BeamElement]
  let invert: Bool

  let allElements: [ScoreElement]

  init(
    noteUnits: [NoteUnit],
    beams: [BeamElement],
    invert: Bool
    ) {
      self.noteUnits = noteUnits
      self.beams = beams
      self.invert = invert

      var elements = [ScoreElement]()
      elements += self.noteUnits.flatMap({$0.allElements})

      self.allElements = elements + beams
  }
}

class TupletUnit: RenderUnit {
  let units: [RenderUnit]
  let bracket: BracketElement
  let invert: Bool

  let allElements: [ScoreElement]

  init(
    units: [RenderUnit],
    bracket: BracketElement,
    invert: Bool
    ) {
      self.units = units
      self.bracket = bracket
      self.invert = invert

      var elements = [ScoreElement]()
      elements += self.units.flatMap({$0.allElements})
      elements.append(bracket)
      
      self.allElements = elements
  }
}