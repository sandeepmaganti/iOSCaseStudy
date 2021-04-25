import UIKit

extension UIButton {
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    func addCircleRadius() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }
}
