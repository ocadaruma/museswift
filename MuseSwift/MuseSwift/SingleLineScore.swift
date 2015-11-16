import Foundation

public class ScoreLayout {
  public let staffHeight: CGFloat
  public let staffLineWidth: CGFloat
  public let barWidth: CGFloat
  public let widthPerUnitNoteLength: CGFloat
  public let barMargin: CGFloat

  public init(
    staffHeight: CGFloat,
    staffLineWidth: CGFloat,
    barWidth: CGFloat,
    widthPerUnitNoteLength: CGFloat,
    barMargin: CGFloat) {
      self.staffHeight = staffHeight
      self.staffLineWidth = staffLineWidth
      self.barWidth = barWidth
      self.widthPerUnitNoteLength = widthPerUnitNoteLength
      self.barMargin = barMargin
  }

  public static let defaultLayout = ScoreLayout(
    staffHeight: 60,
    staffLineWidth: 1,
    barWidth: 2,
    widthPerUnitNoteLength: 40,
    barMargin: 10)
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

    var elementsInBeam: [Note] = []
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
          canvas?.addSubview(b)
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
            canvas?.addSubview(b)
          } else if (length >= 0.125) {
            currentPositionIsInBeam = true
          } else if (length >= 0.0625) {
            currentPositionIsInBeam = true
          }
        }

        v.frame = ballRect
        c.addSubview(v)

//          let b = Block()
//          let r: CGFloat = 1.5
//          let w = v.frame.size.width
//
//          b.frame = CGRect(
//            x: v.frame.origin.x + w * (1 - r) / 2,
//            y: v.frame.origin.y + v.frame.size.height / 2,
//            width: w * r,
//            height: layout.staffLineWidth)
//          c.addSubview(b)


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
        for elems in elementsInBeam.grouped(4) {
          elems.groupBy({$0.length})
        }
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

  private func shouldInvert(pitch: Pitch) -> Bool {
    return (pitch.offset * 7) + pitch.name.rawValue > 0 * 7 + PitchName.B.rawValue
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