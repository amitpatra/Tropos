import UIKit
import TroposCore

@objc(TRAppearanceController) final class AppearanceController: NSObject {
    static func configureAppearance() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.defaultLightFont(size: 20), NSForegroundColorAttributeName: UIColor.lightTextColor()]
        navigationBar.tintColor = .lightTextColor()

        let attributes = [NSFontAttributeName: UIFont.defaultLightFont(size: 17), NSForegroundColorAttributeName: UIColor.lightTextColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
    }
}
