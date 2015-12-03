import Foundation

@IBDesignable public class FlatElement: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    // Path drawing
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * -0.005984375, h * 0.0014249999999999998))
    path.addLineToPoint(CGPointMake(w * -0.005984375, h * 1.00188))
    path.addCurveToPoint(CGPointMake(w * 0.74609375, h * 0.824875), controlPoint1: CGPointMake(w * 0.144234375, h * 0.951595), controlPoint2: CGPointMake(w * 0.5745625, h * 0.876105))
    path.addCurveToPoint(CGPointMake(w * 0.99775, h * 0.6432800000000001), controlPoint1: CGPointMake(w * 0.917625, h * 0.77364), controlPoint2: CGPointMake(w * 1.01584375, h * 0.6849500000000001))
    path.addCurveToPoint(CGPointMake(w * 0.67990625, h * 0.55025), controlPoint1: CGPointMake(w * 0.97965625, h * 0.601605), controlPoint2: CGPointMake(w * 0.91353125, h * 0.561195))
    path.addCurveToPoint(CGPointMake(w * 0.0206875, h * 0.6432800000000001), controlPoint1: CGPointMake(w * 0.44628125, h * 0.539305), controlPoint2: CGPointMake(w * 0.059046875, h * 0.63771))
    path.addCurveToPoint(CGPointMake(w * 0.0449375, h * 0.84895), controlPoint1: CGPointMake(w * 0.007421875, h * 0.6452), controlPoint2: CGPointMake(w * 0.041203125, h * 0.8286450000000001))
    path.addCurveToPoint(CGPointMake(w * 0.595828125, h * 0.635535), controlPoint1: CGPointMake(w * 0.061328125, h * 0.587975), controlPoint2: CGPointMake(w * 0.510375, h * 0.614))
    path.addCurveToPoint(CGPointMake(w * 0.67990625, h * 0.71084), controlPoint1: CGPointMake(w * 0.68128125, h * 0.657075), controlPoint2: CGPointMake(w * 0.67990625, h * 0.6812699999999999))
    path.addCurveToPoint(CGPointMake(w * 0.4820625, h * 0.83643), controlPoint1: CGPointMake(w * 0.67990625, h * 0.740415), controlPoint2: CGPointMake(w * 0.631046875, h * 0.791005))
    path.addCurveToPoint(CGPointMake(w * 0.08853125, h * 0.93096), controlPoint1: CGPointMake(w * 0.3330625, h * 0.88185), controlPoint2: CGPointMake(w * 0.16515625, h * 0.90546))
    path.addLineToPoint(CGPointMake(w * 0.09765625, h * 0.0014249999999999998))
    path.addLineToPoint(CGPointMake(w * -0.005984375, h * 0.0014249999999999998))

    tintColor.setFill()
    path.fill()
  }
}

@IBDesignable public class DoubleFlatElement: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (width, h) = size
    let w = width / 2
    let x = w

    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * -0.005984375, h * 0.0014249999999999998))
    path.addLineToPoint(CGPointMake(w * -0.005984375, h * 1.00188))
    path.addCurveToPoint(CGPointMake(w * 0.74609375, h * 0.824875), controlPoint1: CGPointMake(w * 0.144234375, h * 0.951595), controlPoint2: CGPointMake(w * 0.5745625, h * 0.876105))
    path.addCurveToPoint(CGPointMake(w * 0.99775, h * 0.6432800000000001), controlPoint1: CGPointMake(w * 0.917625, h * 0.77364), controlPoint2: CGPointMake(w * 1.01584375, h * 0.6849500000000001))
    path.addCurveToPoint(CGPointMake(w * 0.67990625, h * 0.55025), controlPoint1: CGPointMake(w * 0.97965625, h * 0.601605), controlPoint2: CGPointMake(w * 0.91353125, h * 0.561195))
    path.addCurveToPoint(CGPointMake(w * 0.0206875, h * 0.6432800000000001), controlPoint1: CGPointMake(w * 0.44628125, h * 0.539305), controlPoint2: CGPointMake(w * 0.059046875, h * 0.63771))
    path.addCurveToPoint(CGPointMake(w * 0.0449375, h * 0.84895), controlPoint1: CGPointMake(w * 0.007421875, h * 0.6452), controlPoint2: CGPointMake(w * 0.041203125, h * 0.8286450000000001))
    path.addCurveToPoint(CGPointMake(w * 0.595828125, h * 0.635535), controlPoint1: CGPointMake(w * 0.061328125, h * 0.587975), controlPoint2: CGPointMake(w * 0.510375, h * 0.614))
    path.addCurveToPoint(CGPointMake(w * 0.67990625, h * 0.71084), controlPoint1: CGPointMake(w * 0.68128125, h * 0.657075), controlPoint2: CGPointMake(w * 0.67990625, h * 0.6812699999999999))
    path.addCurveToPoint(CGPointMake(w * 0.4820625, h * 0.83643), controlPoint1: CGPointMake(w * 0.67990625, h * 0.740415), controlPoint2: CGPointMake(w * 0.631046875, h * 0.791005))
    path.addCurveToPoint(CGPointMake(w * 0.08853125, h * 0.93096), controlPoint1: CGPointMake(w * 0.3330625, h * 0.88185), controlPoint2: CGPointMake(w * 0.16515625, h * 0.90546))
    path.addLineToPoint(CGPointMake(w * 0.09765625, h * 0.0014249999999999998))
    path.addLineToPoint(CGPointMake(w * -0.005984375, h * 0.0014249999999999998))

    let path2 = UIBezierPath()
    path2.moveToPoint(CGPointMake(x + w * -0.005984375, h * 0.0014249999999999998))
    path2.addLineToPoint(CGPointMake(x + w * -0.005984375, h * 1.00188))
    path2.addCurveToPoint(CGPointMake(x + w * 0.74609375, h * 0.824875), controlPoint1: CGPointMake(x + w * 0.144234375, h * 0.951595), controlPoint2: CGPointMake(x + w * 0.5745625, h * 0.876105))
    path2.addCurveToPoint(CGPointMake(x + w * 0.99775, h * 0.6432800000000001), controlPoint1: CGPointMake(x + w * 0.917625, h * 0.77364), controlPoint2: CGPointMake(x + w * 1.01584375, h * 0.6849500000000001))
    path2.addCurveToPoint(CGPointMake(x + w * 0.67990625, h * 0.55025), controlPoint1: CGPointMake(x + w * 0.97965625, h * 0.601605), controlPoint2: CGPointMake(x + w * 0.91353125, h * 0.561195))
    path2.addCurveToPoint(CGPointMake(x + w * 0.0206875, h * 0.6432800000000001), controlPoint1: CGPointMake(x + w * 0.44628125, h * 0.539305), controlPoint2: CGPointMake(x + w * 0.059046875, h * 0.63771))
    path2.addCurveToPoint(CGPointMake(x + w * 0.0449375, h * 0.84895), controlPoint1: CGPointMake(x + w * 0.007421875, h * 0.6452), controlPoint2: CGPointMake(x + w * 0.041203125, h * 0.8286450000000001))
    path2.addCurveToPoint(CGPointMake(x + w * 0.595828125, h * 0.635535), controlPoint1: CGPointMake(x + w * 0.061328125, h * 0.587975), controlPoint2: CGPointMake(x + w * 0.510375, h * 0.614))
    path2.addCurveToPoint(CGPointMake(x + w * 0.67990625, h * 0.71084), controlPoint1: CGPointMake(x + w * 0.68128125, h * 0.657075), controlPoint2: CGPointMake(x + w * 0.67990625, h * 0.6812699999999999))
    path2.addCurveToPoint(CGPointMake(x + w * 0.4820625, h * 0.83643), controlPoint1: CGPointMake(x + w * 0.67990625, h * 0.740415), controlPoint2: CGPointMake(x + w * 0.631046875, h * 0.791005))
    path2.addCurveToPoint(CGPointMake(x + w * 0.08853125, h * 0.93096), controlPoint1: CGPointMake(x + w * 0.3330625, h * 0.88185), controlPoint2: CGPointMake(x + w * 0.16515625, h * 0.90546))
    path2.addLineToPoint(CGPointMake(x + w * 0.09765625, h * 0.0014249999999999998))
    path2.addLineToPoint(CGPointMake(x + w * -0.005984375, h * 0.0014249999999999998))

    tintColor.setFill()
    path.fill()
    path2.fill()
  }
}

@IBDesignable public class SharpElement: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    let ctx = UIGraphicsGetCurrentContext()

    tintColor.setStroke()
    CGContextSetLineWidth(ctx, w / 10)
    CGContextMoveToPoint(ctx, w / 4, 0)
    CGContextAddLineToPoint(ctx, w / 4, h)
    CGContextStrokePath(ctx)

    CGContextMoveToPoint(ctx, w / 4 * 3, 0)
    CGContextAddLineToPoint(ctx, w / 4 * 3, h)
    CGContextStrokePath(ctx)


    CGContextSetLineWidth(ctx, w / 5)
    CGContextMoveToPoint(ctx, 0, h / 3)
    CGContextAddLineToPoint(ctx, w, h / 6)
    CGContextStrokePath(ctx)

    CGContextMoveToPoint(ctx, w, h / 3 * 2)
    CGContextAddLineToPoint(ctx, 0, h / 6 * 5)
    CGContextStrokePath(ctx)
  }
}

@IBDesignable public class DoubleSharpElement: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()

    tintColor.setFill()
    tintColor.setStroke()

    let (w, h) = size
    let lineWidth = w / 5

    CGContextSetLineWidth(ctx, lineWidth)

    CGContextFillRect(ctx, CGRectMake(0, 0, w / 3, h / 3))
    CGContextFillRect(ctx, CGRectMake(w / 3 * 2, 0, w / 3, h / 3))
    CGContextFillRect(ctx, CGRectMake(0, h / 3 * 2, w / 3, h / 3))
    CGContextFillRect(ctx, CGRectMake(w / 3 * 2, h / 3 * 2, w / 3, h / 3))

    CGContextMoveToPoint(ctx, 0, 0)
    CGContextAddLineToPoint(ctx, w, h)
    CGContextStrokePath(ctx)

    CGContextMoveToPoint(ctx, w, 0)
    CGContextAddLineToPoint(ctx, 0, h)
    CGContextStrokePath(ctx)
  }
}

@IBDesignable public class NaturalElement: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.013340000000000001, h * -0.000195))
    path.addLineToPoint(CGPointMake(w * 0.00878, h * 0.79714))
    path.addLineToPoint(CGPointMake(w * 0.88244, h * 0.7215699999999999))
    path.addLineToPoint(CGPointMake(w * 0.88244, h * 0.654495))
    path.addLineToPoint(CGPointMake(w * 0.11694, h * 0.7215699999999999))
    path.addLineToPoint(CGPointMake(w * 0.11694, h * 0.33222999999999997))
    path.addLineToPoint(CGPointMake(w * 0.88244, h * 0.261785))
    path.addLineToPoint(CGPointMake(w * 0.88244, h * 1.00082))
    path.addLineToPoint(CGPointMake(w * 1.00844, h * 1.00082))
    path.addLineToPoint(CGPointMake(w * 1.00844, h * 0.177515))
    path.addLineToPoint(CGPointMake(w * 0.11694, h * 0.261785))
    path.addLineToPoint(CGPointMake(w * 0.11694, h * -0.000195))
    path.addLineToPoint(CGPointMake(w * 0.013340000000000001, h * -0.000195))

    tintColor.setFill()
    path.fill()
  }
}
