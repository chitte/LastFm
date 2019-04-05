
import UIKit

enum NetworkConnectionError: String {
    static let title = "Whoops!"
    case networkConnection = "Your network connection may be too weak to fetch album details"

    var description: String { return self.rawValue }
}

extension UIViewController {
    func showAlert(title: String, msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
