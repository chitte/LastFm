
import UIKit

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }

        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Int {
    public var formatNumber: String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)M"

        case 1000...:
            var formatted = num / 1000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(self)"

        default:
            return "\(sign)\(self)"
        }
    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
}

extension UIViewController {
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

    func showErrorDialogBox(on rootVc: UIViewController, with errorMsg: String) {
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        rootVc.present(alertController, animated: true, completion: nil)
    }

//    func alert(message: String) -> UIAlertController {
//        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(alertAction)
//        return alertController
//    }

}
