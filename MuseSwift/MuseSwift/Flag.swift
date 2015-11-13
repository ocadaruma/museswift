import Foundation

@IBDesignable public class Beam: ScoreElement {
  @IBInspectable public var lineWidth: CGFloat = 0
  @IBInspectable public var rightDown: Bool = false

  public override func drawRect(rect: CGRect) {
    let (w, h) = size
    let ctx = UIGraphicsGetCurrentContext()

    tintColor.setFill()

    if rightDown {
      CGContextMoveToPoint(ctx, 0, 0)
      CGContextAddLineToPoint(ctx, w, h - lineWidth)
      CGContextAddLineToPoint(ctx, w, h)
      CGContextAddLineToPoint(ctx, 0, lineWidth)
    } else {
      CGContextMoveToPoint(ctx, 0, h - lineWidth)
      CGContextAddLineToPoint(ctx, w, 0)
      CGContextAddLineToPoint(ctx, w, lineWidth)
      CGContextAddLineToPoint(ctx, 0, h)
    }

    CGContextFillPath(ctx)
  }
}

@IBDesignable public class FlagEighth: ScoreElement {
  @IBInspectable public var invert: Bool = false

  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    if invert {
      let ctx = UIGraphicsGetCurrentContext()

      CGContextTranslateCTM(ctx, w / 2, h / 2)
      CGContextRotateCTM(ctx, CGFloat(M_PI))
      CGContextTranslateCTM(ctx, -w / 2, -h / 2)
      let flipVertical = CGAffineTransformMake(-1, 0, 0, 1, w, 0)
      CGContextConcatCTM(ctx, flipVertical)
    }

    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.00157, h * 0.00027))
    path.addCurveToPoint(CGPointMake(w * 0.98198, h * 0.5791766666666667), controlPoint1: CGPointMake(w * 0.12961999999999999, h * 0.18935666666666667), controlPoint2: CGPointMake(w * 0.85393, h * 0.39008666666666664))
    path.addCurveToPoint(CGPointMake(w * 0.67964, h * 1.00156), controlPoint1: CGPointMake(w * 1.02345, h * 0.6404099999999999), controlPoint2: CGPointMake(w * 1.02345, h * 0.8795999999999999))
    path.addLineToPoint(CGPointMake(w * 0.6232, h * 1.0016566666666666))
    path.addCurveToPoint(CGPointMake(w * 0.91226, h * 0.69606), controlPoint1: CGPointMake(w * 0.7989499999999999, h * 0.9308633333333334), controlPoint2: CGPointMake(w * 0.94747, h * 0.80686))
    path.addCurveToPoint(CGPointMake(w * 0.0012, h * 0.36567333333333335), controlPoint1: CGPointMake(w * 0.8770399999999999, h * 0.5852566666666666), controlPoint2: CGPointMake(w * 0.85393, h * 0.45594666666666667))

    tintColor.setFill()
    path.fill()
  }
}

@IBDesignable public class FlagSixteenth: ScoreElement {
  @IBInspectable public var invert: Bool = false

  public override func drawRect(rect: CGRect) {
    let (w, height) = size
    let h = height * 230 / 300

    if invert {
      let ctx = UIGraphicsGetCurrentContext()

      CGContextTranslateCTM(ctx, w / 2, height / 2);
      CGContextRotateCTM(ctx, CGFloat(M_PI))
      CGContextTranslateCTM(ctx, -w / 2, -height / 2)

      let flipVertical = CGAffineTransformMake(-1, 0, 0, 1, w, 0)
      CGContextConcatCTM(ctx, flipVertical)
    }

    let y = height * 70.0 / 300;

    // Path2 drawing
    let path2 = UIBezierPath()
    path2.moveToPoint(CGPointMake(w * 0.00037999999999999997, y + h * 0.0015391304347826087))
    path2.addCurveToPoint(CGPointMake(w * 0.98078, y + h * 0.5787173913043477), controlPoint1: CGPointMake(w * 0.12842, y + h * 0.1900608695652174), controlPoint2: CGPointMake(w * 0.85273, y + h * 0.39019565217391305))
    path2.addCurveToPoint(CGPointMake(w * 0.6784399999999999, y + h * 0.9998391304347826), controlPoint1: CGPointMake(w * 1.0222499999999999, y + h * 0.6397695652173913), controlPoint2: CGPointMake(w * 1.0222499999999999, y + h * 0.8782434782608696))
    path2.addLineToPoint(CGPointMake(w * 0.622, y + h * 0.9999347826086957))
    path2.addCurveToPoint(CGPointMake(w * 0.91106, y + h * 0.6952478260869566), controlPoint1: CGPointMake(w * 0.7977500000000001, y + h * 0.9293521739130435), controlPoint2: CGPointMake(w * 0.94627, y + h * 0.8057217391304348))
    path2.addCurveToPoint(CGPointMake(0, y + h * 0.3658521739130435), controlPoint1: CGPointMake(w * 0.8758499999999999, y + h * 0.5847782608695652), controlPoint2: CGPointMake(w * 0.85273, y + h * 0.4558565217391304))

    tintColor.setFill()
    path2.fill()

    let h2 = height * 180 / 300

    // Path drawing
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * -0.0010299999999999999, h2 * 0.0019666666666666665))
    path.addCurveToPoint(CGPointMake(w * 0.27767, h2 * 0.29969444444444443), controlPoint1: CGPointMake(w * -0.0010299999999999999, h2 * 0.0019666666666666665), controlPoint2: CGPointMake(w * 0.02165, h2 * 0.13217777777777778))
    path.addCurveToPoint(CGPointMake(w * 0.94416, h2 * 0.6549111111111111), controlPoint1: CGPointMake(w * 0.5337, h2 * 0.46721666666666667), controlPoint2: CGPointMake(w * 0.80715, h2 * 0.5408555555555555))
    path.addCurveToPoint(CGPointMake(w * 0.8944, h2 * 0.9093166666666667), controlPoint1: CGPointMake(w * 1.08117, h2 * 0.7689666666666666), controlPoint2: CGPointMake(w * 0.8944, h2 * 0.9093166666666667))
    path.addLineToPoint(CGPointMake(w * 0.8097, h2 * 0.9742166666666667))
    path.addCurveToPoint(CGPointMake(w * 0.7697700000000001, h2 * 0.9669055555555556), controlPoint1: CGPointMake(w * 0.7988599999999999, h2 * 0.9620833333333334), controlPoint2: CGPointMake(w * 0.66976, h2 * 1.0451888888888887))
    path.addCurveToPoint(CGPointMake(w * 0.8860800000000001, h2 * 0.7219611111111112), controlPoint1: CGPointMake(w * 0.86977, h2 * 0.8886277777777778), controlPoint2: CGPointMake(w * 0.9465300000000001, h2 * 0.8108777777777778))
    path.addCurveToPoint(CGPointMake(w * -0.0025, h2 * 0.3889777777777778), controlPoint1: CGPointMake(w * 0.82563, h2 * 0.6330444444444444), controlPoint2: CGPointMake(w * 0.52323, h2 * 0.5006222222222222))
    path.addLineToPoint(CGPointMake(w * -0.0010299999999999999, h2 * 0.0019666666666666665))

    path.fill()
  }
}
