import Foundation

func calcDenominator(absoluteLength: Float) -> Denominator {
  if absoluteLength >= 1 {
    return .Whole
  } else if absoluteLength >= 0.5 {
    return .Half
  } else if absoluteLength >= 0.25 {
    return .Quarter
  } else if absoluteLength >= 0.125 {
    return .Eighth
  } else if absoluteLength >= 0.0625 {
    return .Sixteenth
  } else if absoluteLength >= 0.03125 {
    return .ThirtySecond
  } else {
    return .SixtyFourth
  }
}
