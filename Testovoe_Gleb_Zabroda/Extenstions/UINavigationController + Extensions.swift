import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = .orange
    }
}

