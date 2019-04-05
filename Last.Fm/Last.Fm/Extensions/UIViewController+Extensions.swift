
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

    public func showAnimation(rootVC: UIViewController, shouldStartAnimation: Bool) {
        let animationView = UIView()
        let animationSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)

        if shouldStartAnimation {
            animationView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            animationView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            rootVC.view.addSubview(animationView)
            rootVC.view.bringSubviewToFront(animationView)

            animationSpinner.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            animationSpinner.center = animationView.center
            animationView.tag = 55555
            animationSpinner.startAnimating()
            animationView.addSubview(animationSpinner)
        } else {
            if let viewWithTag = rootVC.view.viewWithTag(55555) {
                animationSpinner.stopAnimating()
                viewWithTag.removeFromSuperview()
            }
        }
    }
}

