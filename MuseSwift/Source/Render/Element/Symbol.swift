import Foundation

@IBDesignable public class SymbolFour: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.37420000000000003, h * 0.00036))
    path.addCurveToPoint(CGPointMake(w * 0.26739, h * 0.2962), controlPoint1: CGPointMake(w * 0.36329999999999996, h * 0.11050666666666667), controlPoint2: CGPointMake(w * 0.3053, h * 0.22973333333333334))
    path.addCurveToPoint(CGPointMake(w * 0.00256, h * 0.6867933333333334), controlPoint1: CGPointMake(w * 0.21154, h * 0.39414), controlPoint2: CGPointMake(w * 0.11517, h * 0.5639866666666666))
    path.addLineToPoint(CGPointMake(w * 0.00373, h * 0.73252))
    path.addLineToPoint(CGPointMake(w * 0.50448, h * 0.7339133333333333))
    path.addCurveToPoint(CGPointMake(w * 0.48951, h * 0.9422133333333332), controlPoint1: CGPointMake(w * 0.50307, h * 0.8242866666666667), controlPoint2: CGPointMake(w * 0.51082, h * 0.9184666666666668))
    path.addCurveToPoint(CGPointMake(w * 0.30974, h * 0.9703533333333333), controlPoint1: CGPointMake(w * 0.46820999999999996, h * 0.9659666666666668), controlPoint2: CGPointMake(w * 0.40563000000000005, h * 0.9702066666666667))
    path.addLineToPoint(CGPointMake(w * 0.31155, h * 1.0013866666666666))
    path.addLineToPoint(CGPointMake(w * 0.99613, h * 1.00068))
    path.addLineToPoint(CGPointMake(w * 0.9963599999999999, h * 0.9703533333333333))
    path.addCurveToPoint(CGPointMake(w * 0.82122, h * 0.94046), controlPoint1: CGPointMake(w * 0.9173300000000001, h * 0.9687133333333332), controlPoint2: CGPointMake(w * 0.84905, h * 0.97148))
    path.addCurveToPoint(CGPointMake(w * 0.80002, h * 0.7333), controlPoint1: CGPointMake(w * 0.79339, h * 0.90944), controlPoint2: CGPointMake(w * 0.80072, h * 0.7633666666666666))
    path.addLineToPoint(CGPointMake(w * 0.99613, h * 0.7334933333333333))
    path.addLineToPoint(CGPointMake(w * 0.99664, h * 0.6856666666666666))
    path.addLineToPoint(CGPointMake(w * 0.80002, h * 0.6844266666666666))
    path.addLineToPoint(CGPointMake(w * 0.80002, h * 0.20690666666666668))
    path.addLineToPoint(CGPointMake(w * 0.50448, h * 0.43389333333333335))
    path.addLineToPoint(CGPointMake(w * 0.50448, h * 0.68538))
    path.addLineToPoint(CGPointMake(w * 0.09287000000000001, h * 0.6856666666666666))
    path.addLineToPoint(CGPointMake(w * 0.82218, h * -0.0013666666666666666))
    path.addLineToPoint(CGPointMake(w * 0.37420000000000003, h * 0.00036))

    tintColor.setFill()
    path.fill()
  }
}

@IBDesignable public class SymbolTwo: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.34715, h * 0.3126933333333334))
    path.addCurveToPoint(CGPointMake(w * 0.17709, h * 0.41348666666666667), controlPoint1: CGPointMake(w * 0.33819000000000005, h * 0.3859666666666667), controlPoint2: CGPointMake(w * 0.25183, h * 0.41378))
    path.addCurveToPoint(CGPointMake(w * 0.00919, h * 0.31050666666666665), controlPoint1: CGPointMake(w * 0.10236, h * 0.4131933333333333), controlPoint2: CGPointMake(w * 0.01474, h * 0.37482666666666664))
    path.addCurveToPoint(CGPointMake(w * 0.12843, h * 0.09495333333333333), controlPoint1: CGPointMake(w * 0.00364, h * 0.24618), controlPoint2: CGPointMake(w * 0.04622, h * 0.14765333333333333))
    path.addCurveToPoint(CGPointMake(w * 0.49493000000000004, h * 0.00033999999999999997), controlPoint1: CGPointMake(w * 0.21064, h * 0.04225333333333334), controlPoint2: CGPointMake(w * 0.34963, h * 0.00033999999999999997))
    path.addCurveToPoint(CGPointMake(w * 0.8449599999999999, h * 0.07929333333333334), controlPoint1: CGPointMake(w * 0.64023, h * 0.00033999999999999997), controlPoint2: CGPointMake(w * 0.75881, h * 0.037919999999999995))
    path.addCurveToPoint(CGPointMake(w * 0.9865900000000001, h * 0.25668), controlPoint1: CGPointMake(w * 0.9311, h * 0.12066666666666667), controlPoint2: CGPointMake(w * 0.992, h * 0.19469999999999998))
    path.addCurveToPoint(CGPointMake(w * 0.85833, h * 0.41079333333333334), controlPoint1: CGPointMake(w * 0.9811799999999999, h * 0.31865333333333334), controlPoint2: CGPointMake(w * 0.94399, h * 0.35588))
    path.addCurveToPoint(CGPointMake(w * 0.23024999999999998, h * 0.7371533333333333), controlPoint1: CGPointMake(w * 0.77267, h * 0.46570666666666666), controlPoint2: CGPointMake(w * 0.51871, h * 0.5460933333333333))
    path.addCurveToPoint(CGPointMake(w * 0.71786, h * 0.81734), controlPoint1: CGPointMake(w * 0.5289200000000001, h * 0.7382466666666666), controlPoint2: CGPointMake(w * 0.60924, h * 0.8167266666666667))
    path.addCurveToPoint(CGPointMake(w * 0.91705, h * 0.7040066666666667), controlPoint1: CGPointMake(w * 0.75469, h * 0.8175533333333334), controlPoint2: CGPointMake(w * 0.8771, h * 0.7813666666666667))
    path.addLineToPoint(CGPointMake(w * 1.00253, h * 0.7179133333333333))
    path.addCurveToPoint(CGPointMake(w * 0.69767, h * 1.0001066666666667), controlPoint1: CGPointMake(w * 0.9509000000000001, h * 0.7657133333333334), controlPoint2: CGPointMake(w * 0.86027, h * 0.9994466666666667))
    path.addCurveToPoint(CGPointMake(w * 0.27235, h * 0.8606999999999999), controlPoint1: CGPointMake(w * 0.5350699999999999, h * 1.0007666666666668), controlPoint2: CGPointMake(w * 0.39596, h * 0.8606999999999999))
    path.addCurveToPoint(CGPointMake(w * 0.06766, h * 1.0001066666666667), controlPoint1: CGPointMake(w * 0.14874, h * 0.8606999999999999), controlPoint2: CGPointMake(w * 0.09022000000000001, h * 0.8921133333333334))
    path.addCurveToPoint(CGPointMake(w * -0.00057, h * 0.9857333333333335), controlPoint1: CGPointMake(w * 0.01463, h * 0.9898466666666667), controlPoint2: CGPointMake(w * 0.00621, h * 0.9857666666666667))
    path.addCurveToPoint(CGPointMake(w * 0.21716000000000002, h * 0.6669466666666667), controlPoint1: CGPointMake(w * -0.00681, h * 0.8456866666666666), controlPoint2: CGPointMake(w * 0.14824, h * 0.7111266666666667))
    path.addCurveToPoint(CGPointMake(w * 0.67015, h * 0.3152466666666667), controlPoint1: CGPointMake(w * 0.28607, h * 0.6227666666666667), controlPoint2: CGPointMake(w * 0.60455, h * 0.38809333333333335))
    path.addCurveToPoint(CGPointMake(w * 0.73047, h * 0.14219333333333334), controlPoint1: CGPointMake(w * 0.73576, h * 0.2424), controlPoint2: CGPointMake(w * 0.7509, h * 0.19107333333333335))
    path.addCurveToPoint(CGPointMake(w * 0.49493000000000004, h * 0.047593333333333335), controlPoint1: CGPointMake(w * 0.71004, h * 0.09331333333333333), controlPoint2: CGPointMake(w * 0.59863, h * 0.047593333333333335))
    path.addCurveToPoint(CGPointMake(w * 0.24273, h * 0.14595333333333335), controlPoint1: CGPointMake(w * 0.39124000000000003, h * 0.047593333333333335), controlPoint2: CGPointMake(w * 0.25267, h * 0.08284666666666667))
    path.addCurveToPoint(CGPointMake(w * 0.34715, h * 0.3126933333333334), controlPoint1: CGPointMake(w * 0.23279, h * 0.20906000000000002), controlPoint2: CGPointMake(w * 0.35611, h * 0.23941999999999997))

    tintColor.setFill()
    path.fill()
  }
}

@IBDesignable public class SymbolC: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.67568, h * 0.37398333333333333))
    path.addCurveToPoint(CGPointMake(w * 0.82632, h * 0.4652583333333334), controlPoint1: CGPointMake(w * 0.68428, h * 0.423725), controlPoint2:CGPointMake(w * 0.74599, h * 0.46615))
    path.addCurveToPoint(CGPointMake(w * 0.9801000000000001, h * 0.32182499999999997), controlPoint1: CGPointMake(w * 0.90664, h * 0.46437500000000004), controlPoint2: CGPointMake(w * 0.9801000000000001, h * 0.3873583333333333))
    path.addCurveToPoint(CGPointMake(w * 0.8691599999999999, h * 0.09818333333333333), controlPoint1: CGPointMake(w * 0.9801000000000001, h * 0.25628333333333336), controlPoint2: CGPointMake(w * 0.97405, h * 0.17100833333333335))
    path.addCurveToPoint(CGPointMake(w * 0.49327, h * 0.002033333333333333), controlPoint1: CGPointMake(w * 0.76426, h * 0.025358333333333333), controlPoint2: CGPointMake(w * 0.63741, h * -0.0014416666666666666))
    path.addCurveToPoint(CGPointMake(w * 0.11083, h * 0.20641666666666666), controlPoint1: CGPointMake(w * 0.34912, h * 0.005508333333333334), controlPoint2: CGPointMake(w * 0.18169000000000002, h * 0.11323333333333332))
    path.addCurveToPoint(CGPointMake(w * 0.00263, h * 0.5167833333333334), controlPoint1: CGPointMake(w * 0.03998, h * 0.2996), controlPoint2: CGPointMake(w * 0.00226, h * 0.42427499999999996))
    path.addCurveToPoint(CGPointMake(w * 0.14776999999999998, h * 0.849925), controlPoint1: CGPointMake(w * 0.00299, h * 0.6092916666666667), controlPoint2: CGPointMake(w * 0.03335, h * 0.7340333333333333))
    path.addCurveToPoint(CGPointMake(w * 0.5043500000000001, h * 1.00485), controlPoint1: CGPointMake(w * 0.2622, h * 0.965825), controlPoint2: CGPointMake(w * 0.39859, h * 0.9975583333333333))
    path.addCurveToPoint(CGPointMake(w * 0.82435, h * 0.89435), controlPoint1: CGPointMake(w * 0.61011, h * 1.0121499999999999), controlPoint2: CGPointMake(w * 0.7257899999999999, h * 0.969375))
    path.addCurveToPoint(CGPointMake(w * 1.00668, h * 0.6233166666666666), controlPoint1: CGPointMake(w * 0.92291, h * 0.819325), controlPoint2:CGPointMake(w * 0.98603, h * 0.703425))
    path.addLineToPoint(CGPointMake(w * 0.95673, h * 0.5937416666666666))
    path.addCurveToPoint(CGPointMake(w * 0.8364499999999999, h * 0.8141166666666667), controlPoint1: CGPointMake(w * 0.95532, h * 0.6533833333333334), controlPoint2: CGPointMake(w * 0.8864700000000001, h * 0.7641666666666667))
    path.addCurveToPoint(CGPointMake(w * 0.50465, h * 0.9397249999999999), controlPoint1: CGPointMake(w * 0.78642, h * 0.8640666666666666), controlPoint2: CGPointMake(w * 0.6532800000000001, h * 0.9792166666666666))
    path.addCurveToPoint(CGPointMake(w * 0.24758, h * 0.5167833333333334), controlPoint1: CGPointMake(w * 0.35601999999999995, h * 0.9002416666666666), controlPoint2: CGPointMake(w * 0.24758, h * 0.777575))
    path.addCurveToPoint(CGPointMake(w * 0.5043500000000001, h * 0.06420833333333334), controlPoint1: CGPointMake(w * 0.24758, h * 0.2559916666666667), controlPoint2: CGPointMake(w * 0.35272, h * 0.09910833333333334))
    path.addCurveToPoint(CGPointMake(w * 0.83947, h * 0.17743333333333336), controlPoint1: CGPointMake(w * 0.65598, h * 0.029316666666666664), controlPoint2: CGPointMake(w * 0.83542, h * 0.11573333333333333))
    path.addCurveToPoint(CGPointMake(w * 0.7203400000000001, h * 0.25249166666666667), controlPoint1: CGPointMake(w * 0.84161, h * 0.20995), controlPoint2: CGPointMake(w * 0.76134, h * 0.21796666666666667))
    path.addCurveToPoint(CGPointMake(w * 0.67568, h * 0.37398333333333333), controlPoint1: CGPointMake(w * 0.6793300000000001, h * 0.287025), controlPoint2: CGPointMake(w * 0.66708, h * 0.32425))

    tintColor.setFill()
    path.fill()
  }
}

@IBDesignable public class DoubleBar: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let (width, height) = size
    let ctx = UIGraphicsGetCurrentContext()
    let w = width / 3
    tintColor.setFill()
    CGContextFillRect(ctx, CGRectMake(0, 0, w, height))
    CGContextFillRect(ctx, CGRectMake(w * 2, 0, w, height))
  }
}
