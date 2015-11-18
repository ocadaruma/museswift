import Foundation

public class ScoreLayout {
  public let staffHeight: CGFloat
  public let staffLineWidth: CGFloat
  public let barWidth: CGFloat
  public let widthPerUnitNoteLength: CGFloat
  public let barMargin: CGFloat
  public let minimumNoteLineLength: CGFloat
  public let maxBeamGradient: CGFloat

  public init(
    staffHeight: CGFloat,
    staffLineWidth: CGFloat,
    barWidth: CGFloat,
    widthPerUnitNoteLength: CGFloat,
    barMargin: CGFloat,
    minimumNoteLineLength: CGFloat,
    maxBeamGradient: CGFloat) {
      self.staffHeight = staffHeight
      self.staffLineWidth = staffLineWidth
      self.barWidth = barWidth
      self.widthPerUnitNoteLength = widthPerUnitNoteLength
      self.barMargin = barMargin
      self.minimumNoteLineLength = minimumNoteLineLength
      self.maxBeamGradient = maxBeamGradient
  }

  public static let defaultLayout = ScoreLayout(
    staffHeight: 60,
    staffLineWidth: 1,
    barWidth: 2,
    widthPerUnitNoteLength: 40,
    barMargin: 10,
    minimumNoteLineLength: 30,
    maxBeamGradient: 1.0 / 5)
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
      return layout.staffHeight / (5 - 1)
    }
  }

  private var _canvas: UIView? = nil
  public var canvas: UIView? { get {return _canvas} }

  public func loadVoice(tuneHeader: TuneHeader, voiceHeader: VoiceHeader, voice: Voice) -> Void {

    if let c = _canvas {
      c.removeFromSuperview()
    }

    _canvas = UIView(frame: bounds)
    let c = _canvas!
    addSubview(c)

    var notesInBeam: [(CGRect, Note)] = []
    var offset: CGFloat = 0
    var currentPositionIsInBeam: Bool

    for e in voice.elements {
      currentPositionIsInBeam = false

      switch e {
      case let s as Simple:
        switch s {
        case .BarLine:
          let v = Block()
          v.frame = CGRect(x: offset - layout.barMargin, y: staffTop, width: layout.barWidth, height: layout.staffHeight)
          c.addSubview(v)
        case .DoubleBarLine:
          let v = DoubleBar()
          v.frame = CGRect(x: offset - layout.barMargin, y: staffTop, width: layout.barWidth * 3, height: layout.staffHeight)
          c.addSubview(v)
        case .Space: () //TODO
        case .LineBreak: () //TODO
        case .RepeatEnd: () //TODO
        case .RepeatStart: () //TODO
        case .Tie: () //TODO
        case .SlurEnd: () //TODO
        case .SlurStart: () //TODO
        }
      case let note as Note:
        var v: UIView
        let length = note.length.actualLength(tuneHeader.unitNoteLength.denominator)
        let ballRect = pitchRect(note.pitch, x: offset)

        if (length >= 1) {
          v = WholeNote()
        } else if (length >= 0.5) {
          v = WhiteNote()
          let b = Block()
          let lineHeight = staffInterval * 3
          let lineWidth = layout.staffLineWidth * 2
          if (shouldInvert(note.pitch)) {
            b.frame = CGRectMake(offset, ballRect.origin.y + ballRect.size.height * 0.6, lineWidth, lineHeight)
          } else {
            b.frame = CGRectMake(offset + ballRect.size.width - lineWidth, ballRect.origin.y - lineHeight + ballRect.size.height * 0.4, lineWidth, lineHeight)
          }
          c.addSubview(b)

          for dot in dots(note.pitch, offset: offset, length: length, denominator: 0.5) {
            c.addSubview(dot)
          }
        } else {
          v = BlackNote()
          if (length >= 0.25) {
            let b = Block()
            let lineHeight = staffInterval * 3
            let lineWidth = layout.staffLineWidth * 2
            if (shouldInvert(note.pitch)) {
              b.frame = CGRectMake(offset, ballRect.origin.y + ballRect.size.height * 0.6, lineWidth, lineHeight)
            } else {
              b.frame = CGRectMake(offset + ballRect.size.width - lineWidth, ballRect.origin.y - lineHeight + ballRect.size.height * 0.4, lineWidth, lineHeight)
            }
            c.addSubview(b)
            for dot in dots(note.pitch, offset: offset, length: length, denominator: 0.25) {
              c.addSubview(dot)
            }
          } else if (length >= 0.125) {
            currentPositionIsInBeam = true
            notesInBeam.append((pitchRect(note.pitch, x: offset), note))
            for dot in dots(note.pitch, offset: offset, length: length, denominator: 0.125) {
              c.addSubview(dot)
            }
          } else if (length >= 0.0625) {
            currentPositionIsInBeam = true
            notesInBeam.append((pitchRect(note.pitch, x: offset), note))
            for dot in dots(note.pitch, offset: offset, length: length, denominator: 0.0625) {
              c.addSubview(dot)
            }
          }
        }

        v.frame = ballRect
        c.addSubview(v)

        offset += noteLengthToWidth(note.length)
      case let chord as Chord:
        offset += noteLengthToWidth(chord.length)
      case let tuplet as Tuplet: () //TODO
      case let rest as Rest:
        let length = rest.length.actualLength(tuneHeader.unitNoteLength.denominator)

        var v: UIView? = nil
        if (length >= 1) {
          v = Block()
          v?.frame = CGRectMake(offset, staffTop + staffInterval, staffInterval * 1.5, staffInterval * 0.6)
        } else if (length >= 0.5) {
          v = Block()
          let h = staffInterval * 0.6
          v?.frame = CGRectMake(offset, staffTop + staffInterval * 2 - h, staffInterval * 1.5, h)
        } else if (length >= 0.25) {
          v = QuarterRest()
          let w = staffInterval * 1.1
          v?.frame = CGRectMake(offset, staffTop + staffInterval / 2, w, staffInterval * 2.5)
        } else if (length >= 0.125) {
          v = EighthRest()
          v?.frame = CGRectMake(offset, staffTop + staffInterval + layout.staffLineWidth, staffInterval * 1.3, staffInterval * 2)
        } else if (length >= 0.0625) {
          v = SixteenthRest()
          v?.frame = CGRectMake(offset, staffTop + staffInterval + layout.staffLineWidth, staffInterval * 1.3, staffInterval * 3)
        }

        if let b = v {
          canvas?.addSubview(b)
        }

        offset += noteLengthToWidth(rest.length)
      case let rest as MultiMeasureRest:
        offset += noteLengthToWidth(NoteLength(numerator: rest.num, denominator: 1))
      default: ()
      }

      if !currentPositionIsInBeam {
        for notes in notesInBeam.grouped(4) {
          for group in notes.spanBy({$0.1.length}) {
            if group.count == 1 {
              let (rect, note) = group.first!
              let v = BlackNote(frame: rect)
              let b = Block()
              let lineHeight = staffInterval * 3
              let lineWidth = layout.staffLineWidth * 2

              var flagFrame: CGRect
              let invert = shouldInvert(note.pitch)

              if (invert) {
                b.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height * 0.6, lineWidth, lineHeight)
                let y = rect.origin.y + rect.size.height
                flagFrame = CGRectMake(rect.origin.x, y, rect.size.width, b.frame.size.height - y + b.frame.origin.y)
              } else {
                b.frame = CGRectMake(rect.origin.x + rect.size.width - lineWidth, rect.origin.y - lineHeight + rect.size.height * 0.4, lineWidth, lineHeight)
                flagFrame = CGRectMake(rect.origin.x + rect.size.width, b.frame.origin.y, rect.size.width, rect.origin.y - b.frame.origin.y)
              }

              let length = note.length.actualLength(tuneHeader.unitNoteLength.denominator)
              if length >= 0.125 {
                let flag = FlagEighth(frame: flagFrame)
                flag.invert = invert
                c.addSubview(flag)
              } else {
                let flag = FlagSixteenth(frame: flagFrame)
                flag.invert = invert
                c.addSubview(flag)
              }

              c.addSubview(b)
              c.addSubview(v)
            } else if group.nonEmpty {
              let lowest = group.minBy({$0.1.pitch})!
              let highest = group.maxBy({$0.1.pitch})!

              let first = group.first!
              let last = group.last!

              let a = (last.0.origin.y - first.0.origin.y) / (last.0.origin.x - first.0.origin.x)
              let slope = a.abs < layout.maxBeamGradient ? a : layout.maxBeamGradient * a.sign

              let upperF = linearFunction(slope,
                point: Point2D(x: highest.0.origin.x + highest.0.size.width, y: highest.0.origin.y - layout.minimumNoteLineLength))
              let lowerF = linearFunction(slope,
                point: Point2D(x: lowest.0.origin.x, y: lowest.0.origin.y + lowest.0.size.height + layout.minimumNoteLineLength))

              let staffYCenter = staffTop + staffInterval * 2
              let upperDiff = group.map({ abs(staffYCenter - upperF($0.0.origin.x + $0.0.size.width)) }).sum()
              let lowerDiff = group.map({ abs(staffYCenter - lowerF($0.0.origin.x)) }).sum()
              let rightDown = first.1.pitch > last.1.pitch

              let beam = Beam()
              beam.lineWidth = layout.staffLineWidth * 5

              if (upperDiff < lowerDiff) {
                for (r, _) in group {
                  let b = Block()
                  let x = r.origin.x + r.size.width - layout.staffLineWidth * 2
                  let y = upperF(x)
                  b.frame = CGRectMake(x, y, layout.staffLineWidth * 2, r.origin.y - y + r.size.height * 0.4)
                  c.addSubview(b)
                }

                let x1 = first.0.origin.x + first.0.size.width - layout.staffLineWidth * 2
                let y1 = upperF(x1)
                let x2 = last.0.origin.x + last.0.size.width
                let y2 = upperF(x2)
                beam.rightDown = rightDown
                beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.staffLineWidth * 5))

                if first.1.length.actualLength(tuneHeader.unitNoteLength.denominator) <= 0.0625 {
                  let beam2 = Beam(frame: CGRectMake(beam.frame.origin.x, beam.frame.origin.y + beam.lineWidth * 1.5 , beam.frame.size.width, beam.frame.size.height))
                  beam2.lineWidth = beam.lineWidth
                  beam2.rightDown = rightDown
                  c.addSubview(beam2)
                }
              } else {
                for (r, _) in group {
                  let b = Block()
                  let x = r.origin.x
                  let y = lowerF(x)
                  b.frame = CGRectMake(x, r.origin.y + r.size.height * 0.6, layout.staffLineWidth * 2, y - r.origin.y - r.size.height * 0.6)
                  c.addSubview(b)
                }

                let x1 = first.0.origin.x
                let y1 = lowerF(x1)
                let x2 = last.0.origin.x + layout.staffLineWidth * 2
                let y2 = lowerF(x2)
                beam.rightDown = rightDown
                beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.staffLineWidth * 5))

                if first.1.length.actualLength(tuneHeader.unitNoteLength.denominator) <= 0.0625 {
                  let beam2 = Beam(frame: CGRectMake(beam.frame.origin.x, beam.frame.origin.y - beam.lineWidth * 1.5 , beam.frame.size.width, beam.frame.size.height))
                  beam2.lineWidth = beam.lineWidth
                  beam2.rightDown = rightDown
                  c.addSubview(beam2)
                }
              }

              c.addSubview(beam)
            }
          }
        }
        notesInBeam = []
      }
    }
  }

  private func pitchToY(pitch: Pitch) -> CGFloat {
    let noteInterval = staffInterval / 2
    let c0 = staffTop + noteInterval * 9

    return c0 - CGFloat(7 * pitch.offset + pitch.name.rawValue) * noteInterval
  }

  private func pitchRect(pitch: Pitch, x: CGFloat) -> CGRect {
    let width = staffInterval * 1.2
    return CGRect(x: x, y: pitchToY(pitch), width: width, height: staffInterval)
  }

  private func dotRect(pitch: Pitch, x: CGFloat) -> CGRect {
    let step = 7 * pitch.offset + pitch.name.rawValue
    let noteInterval = staffInterval / 2
    let y = staffTop + noteInterval * 9 - CGFloat(step + (step + 1) % 2) * noteInterval

    let l = layout.staffLineWidth * 5
    return CGRectMake(x + staffInterval * 1.5, y + noteInterval - l / 2, l, l)
  }

  private func dots(pitch: Pitch, offset: CGFloat, length: Float, denominator: Float) -> [Oval] {
    var result = [Oval]()
    let length1 = length - denominator
    let denom1 = denominator / 2
    if length1 >= denom1 {
      let dot1 = Oval(frame: dotRect(pitch, x: offset))
      result.append(dot1)

      let length2 = length1 - denom1
      let denom2 = denom1 / 2
      if length2 >= denom2 {
        result.append(Oval(frame: CGRectMake(
          dot1.frame.origin.x + dot1.frame.size.width + layout.staffLineWidth,
          dot1.frame.origin.y,
          dot1.frame.size.width,
          dot1.frame.size.height)))
      }
    }

    return result
  }

  private func shouldInvert(pitch: Pitch) -> Bool {
    return (pitch.offset * 7) + pitch.name.rawValue >= 0 * 7 + PitchName.B.rawValue
  }

//  private func outsideOfStaff(pitch: Pitch) -> Bool {
//    let p = (pitch.offset * 7) + pitch.name.rawValue
//    return p >= 1 * 7 + PitchName.A.rawValue || p <= 0 * 7 + PitchName.C.rawValue
//  }

  private func noteLengthToWidth(noteLength: NoteLength) -> CGFloat {
    return layout.widthPerUnitNoteLength * CGFloat(noteLength.numerator) / CGFloat(noteLength.denominator)
  }

  private func drawStaff() {
    let width = bounds.size.width
    let top = staffTop
    let ctx = UIGraphicsGetCurrentContext()

    CGContextSetLineWidth(ctx, layout.staffLineWidth)
    CGContextSetStrokeColorWithColor(ctx, UIColor.lightGrayColor().CGColor)
    for i in 0..<5 {
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