import UIKit

class TRTableViewCell: UITableViewCell {
  override func awakeFromNib() {
    super.awakeFromNib()
    textLabel?.font = UIFont.defaultLightFont(size: 18.0)
  }
}
