import UIKit
import TroposCore

enum SettingsTableViewControllerSegueIdentifier: String {
    case PrivacyPolicy = "ShowWebViewController"
    case Acknowledgements = "ShowTextViewController"
}

enum Section: Int {
    case UnitSystem
    case Info
    case About
}

enum UnitSystemSection: Int {
    case Metric
    case Imperial
}

enum InfoSection: Int {
    case PrivacyPolicy
    case Acknowledgements
    case Forecast
}

enum AboutSection: Int {
    case Thoughtbot
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet var thoughtbotImageView: UIImageView!
    private let settingsController = SettingsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        settingsController.unitSystemChanged.subscribeNext { unitSystem in
//            if let system = TRUnitSystem(rawValue: unitSystem as! Int) {
//                self.tableView.checkCellAtIndexPath(self.indexPathForUnitSystem(system))
//            }
//        }

//        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil).subscribeNext { _ in
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//            }
//        }

        thoughtbotImageView.tintColor = .lightTextColor();
        thoughtbotImageView.image = thoughtbotImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.checkCellAtIndexPath(indexPathForUnitSystem(settingsController.unitSystem))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = SettingsTableViewControllerSegueIdentifier(rawValue: segue.identifier ?? "") {
            switch identifier {
            case .PrivacyPolicy:
                let webViewController = segue.destinationViewController as? WebViewController
                webViewController?.URL = NSURL(string: "http://www.troposweather.com/privacy/")!
            case .Acknowledgements:
                break
//                let textViewController = segue.destinationViewController as? TextViewController
//                let fileURL = NSBundle.mainBundle().URLForResource("Acknowledgements", withExtension: "plist")
//                let parser = fileURL.flatMap { AcknowledgementsParser(fileURL: $0) }
//                textViewController?.text = parser?.displayString()
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (Section.UnitSystem.rawValue, _):
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.uncheckCellsInSection(indexPath.section)
            selectUnitSystemAtIndexPath(indexPath)
        case (Section.Info.rawValue, InfoSection.Forecast.rawValue):
            UIApplication.sharedApplication().openURL(NSURL(string: "https://forecast.io")!)
        case (Section.About.rawValue, AboutSection.Thoughtbot.rawValue):
            UIApplication.sharedApplication().openURL(NSURL(string: "https://thoughtbot.com")!)
        default: break
        }
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = .defaultLightFont(size: 13)
            headerView.textLabel?.textColor = .lightTextColor()
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.About.rawValue: return appVersionString()
        default: return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }

    private func appVersionString() -> String? {
        let bundle = NSBundle.mainBundle()
        guard let infoDictionary = bundle.infoDictionary as? [String: String] else {
          return .None
        }

        guard let version = infoDictionary["CFBundleShortVersionString"] else { return .None }
        guard let buildNumber = infoDictionary["CFBundleVersion"] else { return .None }

        return "Tropos \(version) (\(buildNumber))".uppercaseString

    }

    private func selectUnitSystemAtIndexPath(indexPath: NSIndexPath) {
        if let system = UnitSystem(rawValue: indexPath.row) {
            settingsController.unitSystem = system
        }
    }

    private func indexPathForUnitSystem(unitSystem: UnitSystem) -> NSIndexPath {
        return NSIndexPath(forRow: unitSystem.rawValue, inSection: 0)
    }
}

extension UITableView {
    func checkCellAtIndexPath(indexPath: NSIndexPath) {
        cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }
    
    func uncheckCellsInSection(section: Int) {
        for index in 0 ..< numberOfRowsInSection(section) {
            let indexPath = NSIndexPath(forRow: index, inSection: section)
            cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        }
    }
}
