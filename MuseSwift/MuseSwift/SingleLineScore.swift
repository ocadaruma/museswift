import Foundation

private let staffNum: Int = 5

private let Whole: Float = 1
private let Half: Float = Whole / 2
private let Quarter: Float = Half / 2
private let Eighth: Float = Quarter / 2
private let Sixteenth: Float = Eighth / 2

public class ScoreLayout {
  public let staffHeight: CGFloat
  public let staffLineWidth: CGFloat
  public let stemWidth: CGFloat
  public let widthPerUnitNoteLength: CGFloat
  public let barMarginRight: CGFloat
  public let minStemHeight: CGFloat
  public let maxBeamSlope: CGFloat
  public let dotMarginLeft: CGFloat
  public let outsideStaffLineWidth: CGFloat
  public let outsideStaffLineXLength: CGFloat
  public let noteHeadSize: CGSize
  public let beamLineWidth: CGFloat

  public init(
    staffHeight: CGFloat = 60,
    staffLineWidth: CGFloat = 1,
    stemWidth: CGFloat = 2,
    widthPerUnitNoteLength: CGFloat = 40,
    barMarginRight: CGFloat = 10,
    minStemHeight: CGFloat = 30,
    maxBeamSlope: CGFloat = 0.2,
    dotMarginLeft: CGFloat = 3,
    outsideStaffLineWidth: CGFloat = 2,
    outsideStaffLineXLength: CGFloat = 28.8,
    noteHeadSize: CGSize = CGSize(width: 18, height: 15),
    beamLineWidth: CGFloat = 5) {
      self.staffHeight = staffHeight
      self.staffLineWidth = staffLineWidth
      self.stemWidth = stemWidth
      self.widthPerUnitNoteLength = widthPerUnitNoteLength
      self.barMarginRight = barMarginRight
      self.minStemHeight = minStemHeight
      self.maxBeamSlope = maxBeamSlope
      self.dotMarginLeft = dotMarginLeft
      self.outsideStaffLineWidth = outsideStaffLineWidth
      self.outsideStaffLineXLength = outsideStaffLineXLength
      self.noteHeadSize = noteHeadSize
      self.beamLineWidth = beamLineWidth
  }

  public static let defaultLayout = ScoreLayout()
}

@IBDesignable public class SingleLineScore: UIView {
  public var layout: ScoreLayout = ScoreLayout.defaultLayout {
    didSet {
      setNeedsDisplay()
    }
  }

  private var staffTop: CGFloat {
    get {
      return (bounds.size.height - layout.staffHeight) / 2
    }
  }

  private var staffInterval: CGFloat {
    get {
      return layout.staffHeight / CGFloat(staffNum - 1)
    }
  }

  /// score elemeents will be added to this view.
  private var _canvas: UIView! = nil
  public var canvas: UIView { get {return _canvas} }

  public func loadVoice(tuneHeader: TuneHeader, voiceHeader: VoiceHeader, voice: Voice) -> Void {
    if let c = _canvas { c.removeFromSuperview() }
    _canvas = UIView(frame: bounds)
    addSubview(canvas)

    var notesInBeam: [(CGRect, Note)] = []
    var xOffset: CGFloat = 0
    var currentPositionIsInBeam: Bool

    for element in voice.elements {
      currentPositionIsInBeam = false

      switch element {
      case let simple as Simple:
        switch simple {
        case .BarLine:
          canvas.addSubview(
            Block(frame:
              CGRect(
                x: xOffset - layout.barMarginRight,
                y: staffTop,
                width: layout.stemWidth,
                height: layout.staffHeight)))
        case .DoubleBarLine:
          canvas.addSubview(
            DoubleBar(frame:
              CGRect(
                x: xOffset - layout.barMarginRight,
                y: staffTop,
                width: layout.stemWidth * 3,
                height: layout.staffHeight)))
        case .Space: break
        case .LineBreak: break
        case .RepeatEnd: break //TODO
        case .RepeatStart: break //TODO
        case .Tie: break //TODO
        case .SlurEnd: break //TODO
        case .SlurStart: break //TODO
        case .End: break
        }
      case let note as Note:
        var noteHead: ScoreElement
        let length = note.length.actualLength(tuneHeader.unitNoteLength.denominator)
        let noteHeadFrame = noteHeadFrameFor(note.pitch, xOffset: xOffset)

        if (length >= Whole) { // whole note
          noteHead = WholeNote()
        } else if (length >= Half) { // half note
          noteHead = WhiteNote()
          canvas.addSubview(stemForNote(noteHeadFrame, pitch: note.pitch))

          for dot in dots(note.pitch, x: noteHeadFrame.rightTop.x, length: length, denominator: Half) {
            canvas.addSubview(dot)
          }
        } else {
          noteHead = BlackNote()
          if (length >= Quarter) { // quarter note
            canvas.addSubview(stemForNote(noteHeadFrame, pitch: note.pitch))
            for dot in dots(note.pitch, x: noteHeadFrame.rightTop.x, length: length, denominator: Quarter) {
              canvas.addSubview(dot)
            }
          } else if (length >= Eighth) { // eighth note
            currentPositionIsInBeam = true
            notesInBeam.append((noteHeadFrameFor(note.pitch, xOffset: xOffset), note))
            for dot in dots(note.pitch, x: noteHeadFrame.rightTop.x, length: length, denominator: Eighth) {
              canvas.addSubview(dot)
            }
          } else if (length >= Sixteenth) { // sixteenth note
            currentPositionIsInBeam = true
            notesInBeam.append((noteHeadFrameFor(note.pitch, xOffset: xOffset), note))
            for dot in dots(note.pitch, x: noteHeadFrame.rightTop.x, length: length, denominator: Sixteenth) {
              canvas.addSubview(dot)
            }
          }
        }

        // render accidental
        accidentalView(note.pitch, x: xOffset).foreach({self.canvas.addSubview($0)})

        // render staff (if pitch is high or low.)
        for stave in outsideStaff(xOffset, pitch: note.pitch) { canvas.addSubview(stave) }

        noteHead.frame = noteHeadFrame
        canvas.addSubview(noteHead)

        xOffset += noteLengthToWidth(note.length)
      case let chord as Chord:
        xOffset += noteLengthToWidth(chord.length)
      case let tuplet as Tuplet: break //TODO
      case let rest as Rest:
        let length = rest.length.actualLength(tuneHeader.unitNoteLength.denominator)

        var restOpt: ScoreElement! = nil

        if (length >= Whole) {
          restOpt = Block()
          let width = staffInterval * 1.5
          restOpt.frame = CGRect(
            x: xOffset + noteLengthToWidth(rest.length) / 2 - (width / 2),
            y: staffTop + staffInterval,
            width: width,
            height: staffInterval * 0.6)
        } else if (length >= Half) {
          restOpt = Block()
          let width = staffInterval * 1.5
          let height = staffInterval * 0.6
          restOpt.frame = CGRect(
            x: xOffset + noteLengthToWidth(rest.length) / 2 - (width / 2),
            y: staffTop + staffInterval * 2 - height,
            width: width,
            height: height)
          for dot in dotsForRest(restOpt.frame.rightTop.x, length: length, denominator: Half) { canvas.addSubview(dot) }
        } else if (length >= Quarter) {
          restOpt = QuarterRest()
          restOpt.frame = CGRect(
            x: xOffset,
            y: staffTop + staffInterval / 2,
            width: staffInterval * 1.1,
            height: staffInterval * 2.5)
          for dot in dotsForRest(restOpt.frame.rightTop.x, length: length, denominator: Quarter) { canvas.addSubview(dot) }
        } else if (length >= Eighth) {
          restOpt = EighthRest()
          restOpt.frame = CGRect(
            x: xOffset,
            y: staffTop + staffInterval + layout.staffLineWidth,
            width: staffInterval * 1.3,
            height: staffInterval * 2)
          for dot in dotsForRest(restOpt.frame.rightTop.x, length: length, denominator: Eighth) { canvas.addSubview(dot) }
        } else if (length >= Sixteenth) {
          restOpt = SixteenthRest()
          restOpt.frame = CGRect(
            x: xOffset,
            y: staffTop + staffInterval + layout.staffLineWidth,
            width: staffInterval * 1.3,
            height: staffInterval * 3)
          for dot in dotsForRest(restOpt.frame.rightTop.x, length: length, denominator: Sixteenth) { canvas.addSubview(dot) }
        }

        if let r = restOpt { canvas.addSubview(r) }

        xOffset += noteLengthToWidth(rest.length)
      case let rest as MultiMeasureRest:
        xOffset += noteLengthToWidth(NoteLength(numerator: rest.num, denominator: 1))
      default: break
      }

      if !currentPositionIsInBeam {
        renderNotesInBeam(notesInBeam, unitDenominator: tuneHeader.unitNoteLength.denominator)
        notesInBeam = []
      }
    }

    if notesInBeam.nonEmpty { renderNotesInBeam(notesInBeam, unitDenominator: tuneHeader.unitNoteLength.denominator) }
  }

  private func renderNotesInBeam(notesInBeam: [(CGRect, Note)], unitDenominator: UnitDenominator) -> Void {
    for notes in notesInBeam.grouped(4) {
      for group in notes.spanBy({$0.1.length}) {
        if group.count == 1 {
          let (rect, note) = group.first!
          let noteHead = BlackNote(frame: rect)
          let stem = Block()
          let lineHeight = staffInterval * 3
          let lineWidth = layout.stemWidth

          var flagFrame: CGRect
          let invert = shouldInvert(note.pitch)

          if (invert) {
            stem.frame = CGRect(x: rect.x, y: rect.y + rect.height * 0.6, width: lineWidth, height: lineHeight)
            flagFrame = CGRect(x: rect.x, y: rect.leftBottom.y, width: rect.width, height: stem.frame.leftBottom.y - rect.leftBottom.y)
          } else {
            stem.frame = CGRect(x: rect.rightTop.x - lineWidth, y: rect.y - lineHeight + rect.height * 0.4, width: lineWidth, height: lineHeight)
            flagFrame = CGRect(x: rect.rightTop.x, y: stem.frame.y, width: rect.width, height: rect.y - stem.frame.y)
          }

          let length = note.length.actualLength(unitDenominator)
          if length >= Eighth {
            let flag = FlagEighth(frame: flagFrame)
            flag.invert = invert
            canvas.addSubview(flag)
            for d in dots(note.pitch, x: rect.rightTop.x, length: length, denominator: Eighth) { canvas.addSubview(d) }
          } else if length >= Sixteenth {
            let flag = FlagSixteenth(frame: flagFrame)
            flag.invert = invert
            canvas.addSubview(flag)
            for d in dots(note.pitch, x: rect.rightTop.x, length: length, denominator: Sixteenth) { canvas.addSubview(d) }
          }

          canvas.addSubview(stem)
          canvas.addSubview(noteHead)

        } else if group.nonEmpty {
          let (lowestRect, _) = group.maxBy({$0.0.origin.y})! // maxBy is correct.
          let (highestRect, _) = group.minBy({$0.0.origin.y})! // minBy is correct.

          let (firstRect, firstNote) = group.first!
          let (lastRect, _) = group.last!

          let a = (lastRect.y - firstRect.y) / (lastRect.x - firstRect.x)
          let slope = a.abs < layout.maxBeamSlope ? a : layout.maxBeamSlope * a.sign

          let upperF = linearFunction(slope,
            point: Point2D(x: highestRect.rightTop.x, y: highestRect.y - layout.minStemHeight))
          let lowerF = linearFunction(slope,
            point: Point2D(x: lowestRect.x, y: lowestRect.leftBottom.y + layout.minStemHeight))

          let staffYCenter = staffTop + staffInterval * 2
          let upperDiff = group.map({ abs(staffYCenter - upperF($0.0.origin.x + $0.0.size.width)) }).sum()
          let lowerDiff = group.map({ abs(staffYCenter - lowerF($0.0.origin.x)) }).sum()
          let rightDown = firstRect.y < lastRect.y

          let beam = Beam()
          beam.lineWidth = layout.beamLineWidth

          if (upperDiff < lowerDiff) {
            for (r, _) in group {
              let x = r.rightTop.x - layout.staffLineWidth * CGFloat(staffNum / 2)
              let y = upperF(x)
              canvas.addSubview(Block(frame:
                CGRect(x: x, y: y, width: layout.stemWidth, height: r.y - y + r.height * 0.4)))
            }

            let x1 = firstRect.rightTop.x - layout.stemWidth
            let y1 = upperF(x1)
            let x2 = lastRect.rightTop.x
            let y2 = upperF(x2)
            beam.rightDown = rightDown
            beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.beamLineWidth))

            if firstNote.length.actualLength(unitDenominator) <= Sixteenth {
              let beam2 = Beam(frame: beam.frame.withY(beam.frame.y + beam.lineWidth * 1.5))
              beam2.lineWidth = beam.lineWidth
              beam2.rightDown = rightDown
              canvas.addSubview(beam2)
            }
          } else {
            for (r, _) in group {
              let x = r.x
              let y = lowerF(x)
              canvas.addSubview(Block(frame:
                CGRect(x: x, y: r.y + r.height * 0.6, width: layout.stemWidth, height: y - r.y - r.height * 0.6)))
            }

            let x1 = firstRect.x
            let y1 = lowerF(x1)
            let x2 = lastRect.x + layout.stemWidth
            let y2 = lowerF(x2)
            beam.rightDown = rightDown
            beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.beamLineWidth))

            if firstNote.length.actualLength(unitDenominator) <= Sixteenth {
              let beam2 = Beam(frame: beam.frame.withY(beam.frame.y - beam.lineWidth * 1.5))
              beam2.lineWidth = beam.lineWidth
              beam2.rightDown = rightDown
              canvas.addSubview(beam2)
            }
          }

          canvas.addSubview(beam)
        }
      }
    }
  }

  private func noteHeadTop(pitch: Pitch) -> CGFloat {
    let noteInterval = staffInterval / 2
    let c0 = staffTop + noteInterval * 9

    return c0 - CGFloat(7 * pitch.offset + pitch.name.rawValue) * noteInterval
  }

  private func noteHeadFrameFor(pitch: Pitch, xOffset: CGFloat) -> CGRect {
    let width = layout.noteHeadSize.width
    return CGRect(x: xOffset, y: noteHeadTop(pitch), width: width, height: layout.noteHeadSize.height)
  }

  private func accidentalView(pitch: Pitch, x: CGFloat) -> ScoreElement? {
    let pRect = noteHeadFrameFor(pitch, xOffset: x)
    var view: ScoreElement? = nil

    switch pitch.accidental {
    case .Some(.DoubleFlat):
      view = DoubleFlat(frame:
        CGRect(
          x: pRect.origin.x - staffInterval * 1.5,
          y: pRect.origin.y - staffInterval * 1.2,
          width: staffInterval * 1.2,
          height: staffInterval * 1.2 + pRect.size.height))
    case .Some(.Flat):
      view = Flat(frame:
        CGRect(
          x: pRect.origin.x - staffInterval,
          y: pRect.origin.y - staffInterval * 1.2,
          width: staffInterval * 0.8,
          height: staffInterval * 1.2 + pRect.size.height))
    case .Some(.Natural):
      view = Natural(frame:
        CGRect(
          x: pRect.origin.x - staffInterval,
          y: pRect.origin.y - staffInterval * 0.5,
          width: staffInterval * 0.6,
          height: staffInterval * 2))
    case .Some(.Sharp):
      view = Sharp(frame:
        CGRect(
          x: pRect.origin.x - staffInterval,
          y: pRect.origin.y - staffInterval * 0.5,
          width: staffInterval * 0.8,
          height: staffInterval * 2))
    case .Some(.DoubleSharp):
      view = DoubleSharp(frame:
        CGRect(
          x: pRect.origin.x - staffInterval * 1.2,
          y: pRect.origin.y,
          width: staffInterval,
          height: staffInterval))
    default: break
    }

    return view
  }

  private func dotRect(pitch: Pitch, x: CGFloat) -> CGRect {
    let step = 7 * pitch.offset + pitch.name.rawValue
    let noteInterval = staffInterval / 2
    let y = staffTop + noteInterval * 9 - CGFloat(step + (step + 1) % 2) * noteInterval

    let d = layout.staffLineWidth * 5
    return CGRect(x: x + layout.dotMarginLeft, y: y + noteInterval - d / 2, width: d, height: d)
  }

  private func dots(pitch: Pitch, x: CGFloat, length: Float, denominator: Float) -> [Oval] {
    var result = [Oval]()
    let length1 = length - denominator
    let denom1 = denominator / 2
    if length1 >= denom1 {
      let dot1 = Oval(frame: dotRect(pitch, x: x))
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

  private func dotsForRest(x: CGFloat, length: Float, denominator: Float) -> [Oval] {
    return dots(Pitch(name: .C, accidental: nil, offset: 1), x: x, length: length, denominator: denominator)
  }

  private func stemForNote(noteHeadFrame: CGRect, pitch: Pitch) -> Block {
    let stem = Block()
    let stemHeight = staffInterval * 3
    if (shouldInvert(pitch)) {
      stem.frame = CGRect(
        x: noteHeadFrame.x,
        y: noteHeadFrame.y + noteHeadFrame.height * 0.6,
        width: layout.stemWidth,
        height: stemHeight)
    } else {
      stem.frame = CGRect(
        x: noteHeadFrame.rightTop.x - layout.stemWidth,
        y: noteHeadFrame.y - stemHeight + noteHeadFrame.height * 0.4,
        width: layout.stemWidth,
        height: stemHeight)
    }

    return stem
  }

  private func shouldInvert(pitch: Pitch) -> Bool {
    return (pitch.offset * 7) + pitch.name.rawValue >= 0 * 7 + PitchName.B.rawValue
  }

  private func outsideStaff(x: CGFloat, pitch: Pitch) -> [Block] {
    let p = (pitch.offset * 7) + pitch.name.rawValue
    let upperBound = 1 * 7 + PitchName.A.rawValue
    let lowerBound = 0 * 7 + PitchName.C.rawValue
    let rect = noteHeadFrameFor(pitch, xOffset: x)
    var staff = [Block]()

    let x = rect.x - (layout.outsideStaffLineXLength - rect.width) / 2
    if p >= upperBound {
      for i in 1...(1 + (p - upperBound).abs / 2) {
        let y = staffTop - (CGFloat(i) * staffInterval)
        staff.append(Block(frame: CGRect(x: x, y: y, width: layout.outsideStaffLineXLength, height: layout.outsideStaffLineWidth)))
      }
    } else if p <= lowerBound {
      for i in 1...(1 + (p - lowerBound).abs / 2) {
        let y = staffTop + layout.staffHeight - layout.staffLineWidth + (CGFloat(i) * staffInterval)
        staff.append(Block(frame: CGRect(x: x, y: y, width: layout.outsideStaffLineXLength, height: layout.outsideStaffLineWidth)))
      }
    }

    return staff
  }

  private func noteLengthToWidth(noteLength: NoteLength) -> CGFloat {
    return layout.widthPerUnitNoteLength * CGFloat(noteLength.numerator) / CGFloat(noteLength.denominator)
  }

  private func drawStaff() {
    let width = bounds.size.width
    let top = staffTop
    let ctx = UIGraphicsGetCurrentContext()

    CGContextSetLineWidth(ctx, layout.staffLineWidth)
    CGContextSetStrokeColorWithColor(ctx, UIColor.lightGrayColor().CGColor)
    for i in 0..<staffNum {
      let offset = staffInterval * CGFloat(i)

      CGContextMoveToPoint(ctx, 0, top + offset)
      CGContextAddLineToPoint(ctx, width, top + offset)
      CGContextStrokePath(ctx)
    }
  }

  public override func drawRect(rect: CGRect) {
    drawStaff()
  }
}
