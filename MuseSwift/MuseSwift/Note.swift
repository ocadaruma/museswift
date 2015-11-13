import Foundation

@IBDesignable public class BlackNote: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    // Oval drawing
    let oval = UIBezierPath()
    oval.moveToPoint(CGPointMake(w * 0.19588999999999998, h * 0.20055555555555557))
    oval.addCurveToPoint(CGPointMake(w * 0.09838, h * 0.8963777777777778), controlPoint1: CGPointMake(w * -0.02521, h * 0.4212), controlPoint2: CGPointMake(w * -0.06887, h * 0.7327333333333333))
    oval.addCurveToPoint(CGPointMake(w * 0.80152, h * 0.7931777777777778), controlPoint1: CGPointMake(w * 0.26562, h * 1.0600222222222222), controlPoint2: CGPointMake(w * 0.58043, h * 1.0138222222222222))
    oval.addCurveToPoint(CGPointMake(w * 0.8990300000000001, h * 0.09735555555555556), controlPoint1: CGPointMake(w * 1.02262, h * 0.5725333333333333), controlPoint2: CGPointMake(w * 1.06627, h * 0.2610111111111111))
    oval.addCurveToPoint(CGPointMake(w * 0.19588999999999998, h * 0.20055555555555557), controlPoint1: CGPointMake(w * 0.73179, h * -0.0662888888888889), controlPoint2: CGPointMake(w * 0.41698, h * -0.02008888888888889))

    // Oval color fill
    tintColor.setFill()
    oval.fill()
  }
}

@IBDesignable public class WhiteNote: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    // Oval drawing
    let oval = UIBezierPath(rect: bounds)

    // Oval color fill
    tintColor.setFill()
    oval.fill()

    // Oval2 drawing
    let oval2 = UIBezierPath()
    oval2.moveToPoint(CGPointMake(w * 0.71433, h * 0.32087))
    oval2.addCurveToPoint(CGPointMake(w * 0.25504, h * 0.11904), controlPoint1: CGPointMake(w * 0.5733, h * 0.10984), controlPoint2: CGPointMake(w * 0.36767, h * 0.0194857))
    oval2.addCurveToPoint(CGPointMake(w * 0.30644, h * 0.681414), controlPoint1: CGPointMake(w * 0.14241, h * 0.2186), controlPoint2: CGPointMake(w * 0.16542, h * 0.47))
    oval2.addCurveToPoint(CGPointMake(w * 0.76573, h * 0.883257), controlPoint1: CGPointMake(w * 0.44746, h * 0.892457), controlPoint2: CGPointMake(w * 0.65309, h * 0.98281))
    oval2.addCurveToPoint(CGPointMake(w * 0.71433, h * 0.32087), controlPoint1: CGPointMake(w * 0.87836, h * 0.7836857), controlPoint2: CGPointMake(w * 0.85535, h * 0.5319))


    // Oval2 color fill
    backgroundColor?.setFill()
    oval2.fill()
  }
}
