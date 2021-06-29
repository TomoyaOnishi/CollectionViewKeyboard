import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if indexPath.item == 9 {
            cell.backgroundColor = .systemBlue
        } else {
            cell.backgroundColor = .secondarySystemBackground
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width - 30, height: 100)
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.window?.endEditing(true)
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.keyboardDismissMode = .interactive
        }
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override var canBecomeFirstResponder: Bool { true }

    lazy var commentView: UIView = {
        let container = UIView()
        let textField = UITextField()
        textField.delegate = self
        textField.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        textField.placeholder = "placeholder"
        container.addSubview(textField)
        container.frame.size.height = 64
        container.backgroundColor = .systemRed
        container.frame.size.width = 100
        return container
    }()

    override var inputAccessoryView: UIView? {
        return commentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardChange(_ notification: Notification) {
        if notification.name == UIApplication.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        } else if let userInfo = notification.userInfo, let nsValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            bottomConstraint.constant = nsValue.cgRectValue.height
            view.layoutIfNeeded()
            collectionView.scrollToItem(at: IndexPath(item: 9, section: 0), at: .bottom, animated: false)
            collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.bounds.height), animated: false)
        }
    }
}
