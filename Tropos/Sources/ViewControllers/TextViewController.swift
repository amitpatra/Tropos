import UIKit

class TextViewController: UIViewController {
    @IBOutlet var textView: UITextView!

    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.contentInset = UIEdgeInsetsZero
        textView.textContainerInset = UIEdgeInsetsZero
        textView.font = UIFont.defaultRegularFont(size: 14)
        textView.textColor = .lightTextColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = text
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentOffset = .zero
    }
}
