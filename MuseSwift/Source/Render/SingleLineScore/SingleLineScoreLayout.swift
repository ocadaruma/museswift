import Foundation

let staffNum: Int = 5

let Whole: Float = 1
let Half: Float = Whole / 2
let Quarter: Float = Half / 2
let Eighth: Float = Quarter / 2
let Sixteenth: Float = Eighth / 2

public class SingleLineScoreLayout {
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
  public let tupletFontSize: CGFloat

  public init(
    staffHeight: CGFloat = 60,
    staffLineWidth: CGFloat = 1,
    stemWidth: CGFloat = 2,
    widthPerUnitNoteLength: CGFloat = 40,
    barMarginRight: CGFloat = 10,
    minStemHeight: CGFloat = 30,
    maxBeamSlope: CGFloat = 0.2,
    dotMarginLeft: CGFloat = 3,
    outsideStaffLineWidth: CGFloat = 1,
    outsideStaffLineXLength: CGFloat = 28.8,
    noteHeadSize: CGSize = CGSize(width: 18, height: 15),
    beamLineWidth: CGFloat = 5,
    tupletFontSize: CGFloat = 20) {
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
      self.tupletFontSize = tupletFontSize
  }

  public static let defaultLayout = SingleLineScoreLayout()

  public var staffInterval: CGFloat {
    return staffHeight / CGFloat(staffNum - 1)
  }
}