import UIKit
import TroposCore

@objc(TRAppearanceController) final class AppearanceController: NSObject {
  static func configureAppearance() {
    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.defaultUltraLightFont(size: 20), NSForegroundColorAttributeName: UIColor.lightTextColor()]
    
    let attributes = [NSFontAttributeName: UIFont.defaultUltraLightFont(size: 16), NSForegroundColorAttributeName: UIColor.lightTextColor()]
    UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
  }
}
