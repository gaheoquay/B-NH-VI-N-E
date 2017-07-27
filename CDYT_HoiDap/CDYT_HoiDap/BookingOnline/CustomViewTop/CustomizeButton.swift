import UIKit

// MARK: - Rounded Button
@IBDesignable
class RoundedBorderButton: UIButton {
    // IBInspectable
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
}

class DropDownButton: RoundedBorderButton {
    override func draw(_ rect: CGRect) {
        self.imageEdgeInsets =
            UIEdgeInsets(top: 0, left: self.frame.size.width - 20, bottom: 0, right: 0)
    }
}
