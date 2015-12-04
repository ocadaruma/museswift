import UIKit

public class ScoreElement: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clearColor()
    tintColor = UIColor.blackColor()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clearColor()
    tintColor = UIColor.blackColor()
  }
}
