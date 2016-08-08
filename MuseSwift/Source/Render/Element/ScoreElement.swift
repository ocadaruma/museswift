import UIKit

public enum ElementType { case None, Discrete, Continuous }

public class ScoreElement: UIView {
  public var elementType: ElementType = .None

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clearColor()
    tintColor = UIColor.whiteColor()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clearColor()
    tintColor = UIColor.whiteColor()
  }
}
