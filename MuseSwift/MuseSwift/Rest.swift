import Foundation

@IBDesignable public class QuarterRest : ScoreElement {
  override public func drawRect(rect: CGRect) {
    let (w, h) = size

    // Path drawing
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.12912, h * -0.00039999999999999996))
    path.addLineToPoint(CGPointMake(w * 0.8967400000000001, h * 0.30782000000000004))
    path.addCurveToPoint(CGPointMake(w * 0.5737599999999999, h * 0.5365), controlPoint1: CGPointMake(w * 0.6418699999999999, h * 0.40385333333333334), controlPoint2: CGPointMake(w * 0.55253, h * 0.44053))
    path.addCurveToPoint(CGPointMake(w * 0.99992, h * 0.80235), controlPoint1: CGPointMake(w * 0.59498, h * 0.6324666666666667), controlPoint2: CGPointMake(w * 0.79484, h * 0.73582))
    path.addLineToPoint(CGPointMake(w * 0.9632, h * 0.8142133333333333))
    path.addCurveToPoint(CGPointMake(w * 0.38633, h * 0.8081699999999999), controlPoint1: CGPointMake(w * 0.7380599999999999, h * 0.7937133333333334), controlPoint2: CGPointMake(w * 0.45793999999999996, h * 0.76783))
    path.addCurveToPoint(CGPointMake(w * 0.51789, h * 0.9922733333333333), controlPoint1: CGPointMake(w * 0.31473, h * 0.8485133333333333), controlPoint2: CGPointMake(w * 0.2852, h * 0.9081766666666666))
    path.addLineToPoint(CGPointMake(w * 0.48587, h * 1.00113))
    path.addCurveToPoint(CGPointMake(w * 0.01755, h * 0.7573333333333333), controlPoint1: CGPointMake(w * 0.21686, h * 0.9222933333333333), controlPoint2: CGPointMake(w * -0.08527, h * 0.8531366666666667))
    path.addCurveToPoint(CGPointMake(w * 0.7057899999999999, h * 0.7147733333333333), controlPoint1: CGPointMake(w * 0.12038, h * 0.6615300000000001), controlPoint2: CGPointMake(w * 0.47478000000000004, h * 0.6898833333333333))
    path.addLineToPoint(CGPointMake(w * 0.05793, h * 0.49602))
    path.addCurveToPoint(CGPointMake(w * 0.42826000000000003, h * 0.24957333333333334), controlPoint1: CGPointMake(w * 0.24928, h * 0.41585333333333335), controlPoint2: CGPointMake(w * 0.42521000000000003, h * 0.31671))
    path.addCurveToPoint(CGPointMake(w * 0.0797, h * 0.017193333333333335), controlPoint1: CGPointMake(w * 0.43065, h * 0.19700666666666666), controlPoint2: CGPointMake(w * 0.31473, h * 0.11691))
    path.addLineToPoint(CGPointMake(w * 0.12912, h * -0.00039999999999999996))


    tintColor.setFill()
    path.fill()
  }
}

@IBDesignable public class EighthRest : ScoreElement {
  override public func drawRect(rect: CGRect) {
    let (w, h) = size

    // Path drawing
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.00041, h * 0.15148))
    path.addCurveToPoint(CGPointMake(w * 0.06429, h * 0.04735333333333333), controlPoint1: CGPointMake(w * 0.00041, h * 0.10025333333333333), controlPoint2: CGPointMake(w * 0.035070000000000004, h * 0.0665))
    path.addCurveToPoint(CGPointMake(w * 0.23873999999999998, h * -0.00218), controlPoint1: CGPointMake(w * 0.0935, h * 0.028200000000000003), controlPoint2: CGPointMake(w * 0.15036, h * -0.00218))
    path.addCurveToPoint(CGPointMake(w * 0.4115, h * 0.04874666666666667), controlPoint1: CGPointMake(w * 0.32711, h * -0.00218), controlPoint2: CGPointMake(w * 0.37081000000000003, h * 0.022073333333333334))
    path.addCurveToPoint(CGPointMake(w * 0.467, h * 0.18278666666666665), controlPoint1: CGPointMake(w * 0.45218, h * 0.07541333333333333), controlPoint2: CGPointMake(w * 0.46265, h * 0.13194))
    path.addLineToPoint(CGPointMake(w * 0.9166500000000001, h * -0.0003933333333333333))
    path.addLineToPoint(CGPointMake(w * 1.00367, h * 0.02578))
    path.addLineToPoint(CGPointMake(w * 0.50715, h * 0.9945333333333334))
    path.addLineToPoint(CGPointMake(w * 0.39106, h * 0.9599866666666667))
    path.addCurveToPoint(CGPointMake(w * 0.7879900000000001, h * 0.2012), controlPoint1: CGPointMake(w * 0.5516599999999999, h * 0.7738733333333333), controlPoint2: CGPointMake(w * 0.80765, h * 0.30632666666666664))
    path.addCurveToPoint(CGPointMake(w * 0.24391, h * 0.3040733333333333), controlPoint1: CGPointMake(w * 0.76833, h * 0.09607333333333333), controlPoint2: CGPointMake(w * 0.36529000000000006, h * 0.3040733333333333))
    path.addCurveToPoint(CGPointMake(w * 0.05588, h * 0.24938666666666667), controlPoint1: CGPointMake(w * 0.12252, h * 0.3040733333333333), controlPoint2: CGPointMake(w * 0.08204, h * 0.2665333333333333))
    path.addCurveToPoint(CGPointMake(w * 0.00041, h * 0.15148), controlPoint1: CGPointMake(w * 0.02972, h * 0.23224), controlPoint2: CGPointMake(w * 0.00041, h * 0.20271333333333333))

    tintColor.setFill()
    path.fill()
  }
}

@IBDesignable public class SixteenthRest : ScoreElement {
  override public func drawRect(rect: CGRect) {
    let (w, h) = size

    // Path drawing
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(w * 0.14828, h * 0.10742499999999999))
    path.addCurveToPoint(CGPointMake(w * 0.21616, h * 0.02835), controlPoint1: CGPointMake(w * 0.14828, h * 0.068835), controlPoint2: CGPointMake(w * 0.18289000000000002, h * 0.04353))
    path.addCurveToPoint(CGPointMake(w * 0.38091, h * -0.00201), controlPoint1: CGPointMake(w * 0.24944, h * 0.01317), controlPoint2: CGPointMake(w * 0.29961, h * -0.003135))
    path.addCurveToPoint(CGPointMake(w * 0.56918, h * 0.04283000000000001), controlPoint1: CGPointMake(w * 0.46222, h * -0.0008849999999999999), controlPoint2: CGPointMake(w * 0.5230899999999999, h * 0.01233))
    path.addCurveToPoint(CGPointMake(w * 0.5748599999999999, h * 0.15206), controlPoint1: CGPointMake(w * 0.61527, h * 0.07333), controlPoint2: CGPointMake(w * 0.60061, h * 0.116965))
    path.addCurveToPoint(CGPointMake(w * 0.7166, h * 0.11991), controlPoint1: CGPointMake(w * 0.61303, h * 0.149235), controlPoint2: CGPointMake(w * 0.6889700000000001, h * 0.12785))
    path.addCurveToPoint(CGPointMake(w * 0.80149, h * 0.08906), controlPoint1: CGPointMake(w * 0.7442300000000001, h * 0.11197499999999999), controlPoint2: CGPointMake(w * 0.7834699999999999, h * 0.096415))
    path.addCurveToPoint(CGPointMake(w * 0.91264, h * 0.012470000000000002), controlPoint1: CGPointMake(w * 0.8512900000000001, h * 0.068725), controlPoint2: CGPointMake(w * 0.86899, h * 0.049714999999999995))
    path.addLineToPoint(CGPointMake(w * 1.00184, h * 0.026585))
    path.addCurveToPoint(CGPointMake(w * 0.7815300000000001, h * 0.32972999999999997), controlPoint1: CGPointMake(w * 0.94676, h * 0.10237), controlPoint2: CGPointMake(w * 0.83661, h * 0.25394500000000003))
    path.addCurveToPoint(CGPointMake(w * 0.29559, h * 0.9983799999999999), controlPoint1: CGPointMake(w * 0.6600499999999999, h * 0.49689), controlPoint2: CGPointMake(w * 0.41708, h * 0.8312149999999999))
    path.addLineToPoint(CGPointMake(w * 0.18503, h * 0.9740800000000001))
    path.addLineToPoint(CGPointMake(w * 0.57133, h * 0.516035))
    path.addCurveToPoint(CGPointMake(w * 0.22712, h * 0.600395), controlPoint1: CGPointMake(w * 0.48183, h * 0.56322), controlPoint2: CGPointMake(w * 0.34513, h * 0.600325))
    path.addCurveToPoint(CGPointMake(w * -0.00296, h * 0.5072), controlPoint1: CGPointMake(w * 0.1091, h * 0.600465), controlPoint2: CGPointMake(w * -0.00296, h * 0.541825))
    path.addCurveToPoint(CGPointMake(w * 0.06017, h * 0.42293), controlPoint1: CGPointMake(w * -0.00296, h * 0.47257), controlPoint2: CGPointMake(w * 0.01199, h * 0.44503))
    path.addCurveToPoint(CGPointMake(w * 0.22712, h * 0.390115), controlPoint1: CGPointMake(w * 0.10833999999999999, h * 0.40082999999999996), controlPoint2: CGPointMake(w * 0.16957999999999998, h * 0.390115))
    path.addCurveToPoint(CGPointMake(w * 0.38826, h * 0.42174), controlPoint1: CGPointMake(w * 0.28465, h * 0.390115), controlPoint2: CGPointMake(w * 0.33110999999999996, h * 0.393905))
    path.addCurveToPoint(CGPointMake(w * 0.41557, h * 0.518375), controlPoint1: CGPointMake(w * 0.4454, h * 0.44957500000000006), controlPoint2: CGPointMake(w * 0.43494999999999995, h * 0.49278500000000003))
    path.addCurveToPoint(CGPointMake(w * 0.66495, h * 0.3465), controlPoint1: CGPointMake(w * 0.52461, h * 0.48267000000000004), controlPoint2: CGPointMake(w * 0.5991599999999999, h * 0.41644))
    path.addCurveToPoint(CGPointMake(w * 0.85563, h * 0.12622999999999998), controlPoint1: CGPointMake(w * 0.73075, h * 0.276555), controlPoint2: CGPointMake(w * 0.8090900000000001, h * 0.19241499999999997))
    path.addCurveToPoint(CGPointMake(w * 0.37675, h * 0.21166000000000001), controlPoint1: CGPointMake(w * 0.7206199999999999, h * 0.16417), controlPoint2: CGPointMake(w * 0.54149, h * 0.21166000000000001))
    path.addCurveToPoint(CGPointMake(w * 0.14828, h * 0.10742499999999999), controlPoint1: CGPointMake(w * 0.21202000000000001, h * 0.21166000000000001), controlPoint2: CGPointMake(w * 0.14828, h * 0.146015))

    tintColor.setFill()
    path.fill()
  }
}