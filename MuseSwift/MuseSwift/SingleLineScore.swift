import Foundation

public class ScoreLayout {
  public let staffHeight: CGFloat
  public let staffLineWidth: CGFloat
  public let barWidth: CGFloat
  public let widthPerUnitNoteLength: CGFloat

  public init(
    staffHeight: CGFloat,
    staffLineWidth: CGFloat,
    barWidth: CGFloat,
    widthPerUnitNoteLength: CGFloat) {
      self.staffHeight = staffHeight
      self.staffLineWidth = staffLineWidth
      self.barWidth = barWidth
      self.widthPerUnitNoteLength = widthPerUnitNoteLength
  }

  public static let defaultLayout = ScoreLayout(
    staffHeight: 50,
    staffLineWidth: 1,
    barWidth: 2,
    widthPerUnitNoteLength: 30)
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

  private var _canvas: UIView? = nil
  public var canvas: UIView? { get {return _canvas} }

  public func loadVoice(
    tuneHeader: TuneHeader,
    voiceHeader: VoiceHeader,
    voice: Voice) -> Void {

      if let c = _canvas {
      c.removeFromSuperview()
    }

    _canvas = UIView(frame: bounds)
    let c = _canvas!
    addSubview(c)

    var elementsInBeam: [MusicalElement] = []
    var offset: CGFloat = 0

    for e in voice.elements {
      switch e {
      case let s as Simple:
        switch s {
        case .BarLine:
          let v = Block()
          v.frame = CGRect(x: offset, y: staffTop, width: layout.barWidth, height: layout.staffHeight)
          c.addSubview(v)
        case .DoubleBarLine:
          let v = DoubleBar()
          v.frame = CGRect(x: offset, y: staffTop, width: layout.barWidth * 3, height: layout.staffHeight)
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
        let l = note.length.actualLength(tuneHeader.unitNoteLength.denominator)
        if (l >= 1) {
          v = WholeNote()
        } else if (l >= 0.5) {
          v = WhiteNote()
        } else {
          v = BlackNote()
        }

        v.frame = pitchRect(note.pitch, x: offset)
        c.addSubview(v)

        offset += noteLengthToWidth(note.length)
      case let chord as Chord:
        offset += noteLengthToWidth(chord.length)
      case let tuplet as Tuplet: () //TODO
      case let rest as Rest:
        offset += noteLengthToWidth(rest.length)
      case let rest as MultiMeasureRest:
        offset += noteLengthToWidth(NoteLength(numerator: rest.num, denominator: 1))
      default: ()
      }
    }
  }

  private func pitchToY(pitch: Pitch) -> CGFloat {
    let staffInterval = layout.staffHeight / (5 - 1)
    let noteInterval = staffInterval / 2
    let c0 = staffTop + noteInterval * 9

    return c0 - CGFloat(7 * pitch.offset + pitch.name.rawValue) * noteInterval
  }

  private func pitchRect(pitch: Pitch, x: CGFloat) -> CGRect {
    let height = layout.staffHeight / (5 - 1)
    let width = height * 1.3
    return CGRect(x: x, y: pitchToY(pitch), width: width, height: height)
  }

  private func noteLengthToWidth(noteLength: NoteLength) -> CGFloat {
    return layout.widthPerUnitNoteLength * CGFloat(noteLength.numerator) / CGFloat(noteLength.denominator)
  }

  private func drawStaff() {
    let width = bounds.size.width
    let top = staffTop
    let ctx = UIGraphicsGetCurrentContext()

    let staffInterval = layout.staffHeight / (5 - 1)
    CGContextSetLineWidth(ctx, layout.staffLineWidth)
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