import Foundation

private extension Pitch {
  var step: Int {
    get { return offset * 7 + name.rawValue }
  }
}

class SingleLineScoreRenderer {
  let unitDenominator: UnitDenominator
  let layout: ScoreLayout
  let bounds: CGRect

  init(
    unitDenominator: UnitDenominator,
    layout: ScoreLayout,
    bounds: CGRect) {
      self.unitDenominator = unitDenominator
      self.layout = layout
      self.bounds = bounds
  }

  var staffTop: CGFloat {
    get { return (bounds.height - layout.staffHeight) / 2 }
  }

  private var BOn3rdStave: Pitch {
    get { return Pitch(name: .B, accidental: nil, offset: 0) }
  }

  private var AAbove1stStave: Pitch {
    get { return Pitch(name: .A, accidental: nil, offset: 1) }
  }

  private var MiddleC: Pitch {
    get { return Pitch(name: .C, accidental: nil, offset: 0) }
  }

  private enum NoteHeadColumn {
    case Left, Right
    var invert: NoteHeadColumn {
      get { return self == .Left ? .Right : .Left }
    }
  }

  private func noteHeadTop(pitch: Pitch) -> CGFloat {
    let noteInterval = layout.staffInterval / 2
    let c0 = staffTop + noteInterval * 9

    return c0 - CGFloat(7 * pitch.offset + pitch.name.rawValue) * noteInterval
  }

  private func canRenderInSingleColumn(sortedPitches: [Pitch]) -> Bool {
    var singleColumn = true
    var previousPitch: Pitch? = nil
    for pitch in sortedPitches {
      if let p = previousPitch {
        if (pitch.step - p.step).abs < 2 {
          singleColumn = false
          break
        }
      }
      previousPitch = pitch
    }

    return singleColumn
  }

  private func createDotFrame(pitch: Pitch, x: CGFloat) -> CGRect {
    let step = 7 * pitch.offset + pitch.name.rawValue
    let noteInterval = layout.staffInterval / 2
    let y = staffTop + noteInterval * 9 - CGFloat(step + (step + 1) % 2) * noteInterval

    let d = layout.staffLineWidth * 5
    return CGRect(x: x + layout.dotMarginLeft, y: y + noteInterval - d / 2, width: d, height: d)
  }

  private func createDots(pitch: Pitch, x: CGFloat, length: Float, denominator: Float) -> [Oval] {
    var result = [Oval]()
    let length1 = length - denominator
    let denom1 = denominator / 2
    if length1 >= denom1 {
      let dot1 = Oval(frame: createDotFrame(pitch, x: x))
      result.append(dot1)

      let length2 = length1 - denom1
      let denom2 = denom1 / 2
      if length2 >= denom2 {
        result.append(
          Oval(frame: dot1.frame.withX(dot1.frame.x + dot1.frame.width + layout.staffLineWidth)))
      }
    }

    return result
  }

  private func createDotsForRest(x: CGFloat, length: Float, denominator: Float) -> [Oval] {
    return createDots(Pitch(name: .C, accidental: nil, offset: 1), x: x, length: length, denominator: denominator)
  }

  private func createNoteHeadFrame(pitch: Pitch, xOffset: CGFloat) -> CGRect {
    let width = layout.noteHeadSize.width
    return CGRect(x: xOffset, y: noteHeadTop(pitch), width: width, height: layout.noteHeadSize.height)
  }

  private func createOutsideStaff(xOffset: CGFloat, pitch: Pitch) -> [Block] {
    let step = pitch.step
    let upperBound = AAbove1stStave.step
    let lowerBound = MiddleC.step
    let frame = createNoteHeadFrame(pitch, xOffset: xOffset)
    var staff = [Block]()

    let x = frame.x - (layout.outsideStaffLineXLength - frame.width) / 2
    if step >= upperBound {
      for i in 1...(1 + (step - upperBound).abs / 2) {
        let y = staffTop - (CGFloat(i) * layout.staffInterval)
        staff.append(Block(frame: CGRect(x: x, y: y, width: layout.outsideStaffLineXLength, height: layout.outsideStaffLineWidth)))
      }
    } else if step <= lowerBound {
      for i in 1...(1 + (step - lowerBound).abs / 2) {
        let y = staffTop + layout.staffHeight - layout.staffLineWidth + (CGFloat(i) * layout.staffInterval)
        staff.append(Block(frame: CGRect(x: x, y: y, width: layout.outsideStaffLineXLength, height: layout.outsideStaffLineWidth)))
      }
    }

    return staff
  }

  private func createAccidental(pitch: Pitch, xOffset: CGFloat) -> ScoreElement? {
    let noteHeadFrame = createNoteHeadFrame(pitch, xOffset: xOffset)
    var view: ScoreElement? = nil

    switch pitch.accidental {
    case .Some(.DoubleFlat):
      view = DoubleFlat(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval * 1.5,
          y: noteHeadFrame.y - layout.staffInterval * 1.2,
          width: layout.staffInterval * 1.2,
          height: layout.staffInterval * 1.2 + noteHeadFrame.height))
    case .Some(.Flat):
      view = Flat(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval,
          y: noteHeadFrame.y - layout.staffInterval * 1.2,
          width: layout.staffInterval * 0.8,
          height: layout.staffInterval * 1.2 + noteHeadFrame.height))
    case .Some(.Natural):
      view = Natural(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval,
          y: noteHeadFrame.y - layout.staffInterval * 0.5,
          width: layout.staffInterval * 0.6,
          height: layout.staffInterval * 2))
    case .Some(.Sharp):
      view = Sharp(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval,
          y: noteHeadFrame.y - layout.staffInterval * 0.5,
          width: layout.staffInterval * 0.8,
          height: layout.staffInterval * 2))
    case .Some(.DoubleSharp):
      view = DoubleSharp(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval * 1.2,
          y: noteHeadFrame.y,
          width: layout.staffInterval,
          height: layout.staffInterval))
    default: break
    }

    return view
  }

  func noteLengthToWidth(noteLength: NoteLength) -> CGFloat {
    return layout.widthPerUnitNoteLength * CGFloat(noteLength.numerator) / CGFloat(noteLength.denominator)
  }

  func createRestUnit(xOffset: CGFloat, rest: Rest) -> RestUnit {
    let length = rest.length.actualLength(unitDenominator)

    var restView: ScoreElement! = nil
    var dots = [Oval]()

    if (length >= Whole) {
      restView = Block()
      let width = layout.staffInterval * 1.5
      restView.frame = CGRect(
        x: xOffset + noteLengthToWidth(rest.length) / 2 - (width / 2),
        y: staffTop + layout.staffInterval,
        width: width,
        height: layout.staffInterval * 0.6)
    } else if (length >= Half) {
      restView = Block()
      let width = layout.staffInterval * 1.5
      let height = layout.staffInterval * 0.6
      restView.frame = CGRect(
        x: xOffset + noteLengthToWidth(rest.length) / 2 - (width / 2),
        y: staffTop + layout.staffInterval * 2 - height,
        width: width,
        height: height)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Half)
    } else if (length >= Quarter) {
      restView = QuarterRest()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval / 2,
        width: layout.staffInterval * 1.1,
        height: layout.staffInterval * 2.5)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Quarter)
    } else if (length >= Eighth) {
      restView = EighthRest()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval + layout.staffLineWidth,
        width: layout.staffInterval * 1.3,
        height: layout.staffInterval * 2)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Eighth)
    } else if (length >= Sixteenth) {
      restView = SixteenthRest()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval + layout.staffLineWidth,
        width: layout.staffInterval * 1.3,
        height: layout.staffInterval * 3)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Sixteenth)
    }

    return RestUnit(dots: dots, restView: restView, xOffset: xOffset)
  }

  private func createStem(noteHeadFrames: [CGRect], invert: Bool, singleColumn: Bool) -> Block {
    let bottomFrame = noteHeadFrames.maxBy({$0.y})!
    let topFrame = noteHeadFrames.minBy({$0.y})!

    let stem = Block()
    let stemHeight = layout.staffInterval * 3
    let x = singleColumn && invert ? topFrame.x : noteHeadFrames.map({$0.maxX}).minElement()!

    if invert {
      stem.frame = CGRect(
        x: x,
        y: topFrame.y + topFrame.height * 0.6,
        width: layout.stemWidth,
        height: stemHeight + bottomFrame.y - topFrame.y)
    } else {
      stem.frame = CGRect(
        x: x - layout.stemWidth,
        y: topFrame.y - stemHeight,
        width: layout.stemWidth,
        height: stemHeight + bottomFrame.y - topFrame.y + bottomFrame.height * 0.4)
    }

    return stem
  }

  func createNoteUnit(xOffset: CGFloat, note: Note) -> NoteUnit {
    return createNoteUnit(xOffset, chord: Chord(length: note.length, pitches: [note.pitch]))
  }

  func createNoteUnit(xOffset: CGFloat, chord: Chord) -> NoteUnit {
    let invert = chord.pitches.map({$0.step}).sum() / chord.pitches.count >= BOn3rdStave.step
    let sortedPitches = invert ? chord.pitches.sortBy({$0.step}).reverse() : chord.pitches.sortBy({$0.step})
    let singleColumn = canRenderInSingleColumn(sortedPitches)

    var noteHeadFrames = [(pitch: Pitch, frame: CGRect, column: NoteHeadColumn)]()
    var previousPitch: Pitch? = nil

    if singleColumn {
      for pitch in sortedPitches {
        noteHeadFrames.append((pitch: pitch, frame: createNoteHeadFrame(pitch, xOffset: xOffset), column: .Left))
      }
    } else {
      var column = invert ? NoteHeadColumn.Right : .Left
      for pitch in sortedPitches {
        if let p = previousPitch {
          if (pitch.step - p.step).abs < 2 {
            column = column.invert
          }
        }

        noteHeadFrames.append((
          pitch: pitch,
          frame: createNoteHeadFrame(pitch, xOffset: xOffset).offsetBy(dx: column == .Right ? layout.noteHeadSize.width : 0, dy: 0),
          column: column))
        previousPitch = pitch
      }
    }

    var stem: Block? = nil
    var dots = [Oval]()
    var noteHeads = [ScoreElement]()
    var accidentals = [ScoreElement]()
    var outsideStaff = [Block]()

    let length = chord.length.actualLength(unitDenominator)


    for (pitch, frame, column) in noteHeadFrames {
      let noteHead: ScoreElement
      let shouldAddDots = length < Whole && (singleColumn || column == .Right)
      var d = [Oval]()

      if (length >= Whole) { // whole note
        noteHead = WholeNote()
      } else if (length >= Half) { // half note
        noteHead = WhiteNote()
        if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Half) }
      } else {
        noteHead = BlackNote()
        if (length >= Quarter) { // quarter note
          if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Quarter) }
        } else if (length >= Eighth) { // eighth note
          if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Eighth) }
        } else if (length >= Sixteenth) { // sixteenth note
          if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Sixteenth) }
        }
      }

      outsideStaff += createOutsideStaff(frame.minX, pitch: pitch)
      createAccidental(pitch, xOffset: xOffset).foreach({accidentals.append($0)})

      noteHead.frame = frame
      noteHeads.append(noteHead)
      dots += d
    }

    stem = createStem(noteHeadFrames.map({$0.frame}), invert: invert, singleColumn: singleColumn)

    return NoteUnit(
      stem: stem,
      dots: dots,
      noteHeads: noteHeads,
      accidentals: accidentals,
      outsideStaff: outsideStaff,
      singleColumn: singleColumn,
      xOffset: xOffset)
  }
}

class NoteUnit {
  let stem: Block?
  let dots: [Oval]
  let noteHeads: [ScoreElement]
  let accidentals: [ScoreElement]
  let outsideStaff: [ScoreElement]
  let singleColumn: Bool
  let xOffset: CGFloat

  init(
    stem: Block? = nil,
    dots: [Oval] = [],
    noteHeads: [ScoreElement] = [],
    accidentals: [ScoreElement] = [],
    outsideStaff: [ScoreElement] = [],
    singleColumn: Bool = true,
    xOffset: CGFloat) {
      self.stem = stem
      self.dots = dots
      self.noteHeads = noteHeads
      self.accidentals = accidentals
      self.outsideStaff = outsideStaff
      self.singleColumn = singleColumn
      self.xOffset = xOffset
  }

  func renderToView(view: UIView) {
    stem.foreach({view.addSubview($0)})
    dots.forEach({view.addSubview($0)})
    noteHeads.forEach({view.addSubview($0)})
    accidentals.forEach({view.addSubview($0)})
    outsideStaff.forEach({view.addSubview($0)})
  }
}

class RestUnit {
  let dots: [Oval]
  let restView: ScoreElement
  let xOffset: CGFloat

  init(
    dots: [Oval] = [],
    restView: ScoreElement,
    xOffset: CGFloat) {
      self.dots = dots
      self.restView = restView
      self.xOffset = xOffset
  }

  func renderToView(view: UIView) {
    dots.forEach({view.addSubview($0)})
    view.addSubview(restView)
  }
}
