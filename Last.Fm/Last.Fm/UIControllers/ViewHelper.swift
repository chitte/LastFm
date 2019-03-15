
import UIKit

func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
}

func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

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
        return "\(n)"

    default:
        return "\(sign)\(n)"
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

func showErrorDialogBox(on rootVc: UIViewController, with errorMsg: String) {
    let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(alertAction)
    rootVc.present(alertController, animated: true, completion: nil)
}
